//
//  XMPPManager.m
//  Shion Touch
//
//  Created by Chris Karr on 3/4/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "XMPPManager.h"
#import "FetchSiteInformationMessage.h"
#import "ApplicationModel.h"
#import "ScriptMessage.h"
#import "SoundManager.h"
#import "LocationManager.h"

#import "Camera.h"
#import "Tivo.h"
#import "MobileDevice.h"

#import "NSDataAdditions.h"

@implementation XMPPManager

@synthesize connectionStatus;
@synthesize statusDetails;
@synthesize connected;

static XMPPManager * sharedManager = nil;

- (XMPPJID *) myJid
{
	return [xmppClient myJID];
}

- (void) fetchCredentials:(NSTimer *) theTimer
{
	[theTimer release];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"fetch_credentials" object:nil];
}

- (void) go
{
	if (xmppClient == nil)
	{
		xmppClient = [[XMPPClient alloc] init];
		[xmppClient addDelegate:self];
		[xmppClient setAutoLogin:NO];
		[xmppClient setAutoRoster:YES];
		[xmppClient setAutoPresence:YES];
		
//		if ([[[UIDevice currentDevice] systemVersion] rangeOfString:@"3"].location == 0)
//		{
//			[xmppClient setAllowsSelfSignedCertificates:NO];
//			[xmppClient setAllowsSSLHostNameMismatch:NO];
//		}
//		else
//		{
			[xmppClient setAllowsSelfSignedCertificates:YES];
			[xmppClient setAllowsSSLHostNameMismatch:YES];
//		}
		
		siteJidMap = [[NSMutableDictionary alloc] init];
		
		endpoints = [[NSMutableArray alloc] init];
		sent = [[NSMutableSet alloc] init];
	}
	
	if ([xmppClient isConnected])
		[xmppClient disconnect];
	
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	NSString * username = [defaults valueForKey:@"username"];
	NSString * password = [defaults valueForKey:@"password"];
	
	if (username == nil || [username isEqual:@""] || password == nil || [password isEqual:@""])
	{
		UIAlertView * error = [[UIAlertView alloc] initWithTitle:@"Credentials Required" 
														 message:@"Please enter your login information." 
														delegate:self 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil];
		[error show];
		
		[[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(fetchCredentials:) userInfo:nil repeats:NO] retain];
		
		[error release];
	}
	else
	{
		username = [username stringByAppendingString:@"@subspace.shiononline.com"];
		
		NSString * deviceName = [defaults valueForKey:@"device_name"];
		
		if (deviceName == nil || [deviceName isEqual:@""])
			deviceName = [[UIDevice currentDevice] name];
		
		NSMutableString * mutableSiteName = [NSMutableString stringWithString:deviceName];
		
		[mutableSiteName replaceOccurrencesOfString:@"’" withString:@"'" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mutableSiteName length])];
		
		[xmppClient setDomain:@"subspace.shiononline.com"];
		[xmppClient setPort:5222];
		
		XMPPJID *jid = [XMPPJID jidWithString:username resource:mutableSiteName];
		
		[xmppClient setMyJID:jid];
		
		[xmppClient setPassword:password];
		
		[xmppClient connect];
		
		self.connectionStatus = @"Initializing connection...";
		self.statusDetails = nil;
		self.connected = NO;
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"xmpp_updated" object:nil];
	}
}

- (void)xmppClientConnecting:(XMPPClient *)sender
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	self.connectionStatus = @"Establishing connection...";
	self.statusDetails = nil;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"xmpp_updated" object:nil];
}

- (void)xmppClientDidConnect:(XMPPClient *)sender
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	self.connectionStatus = @"Authenticating...";
	self.statusDetails = @"Connected to service.";
	[[NSNotificationCenter defaultCenter] postNotificationName:@"xmpp_updated" object:nil];
	
	[xmppClient authenticateUser];
}

- (void)xmppClientDidNotConnect:(XMPPClient *)sender
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	self.connectionStatus = @"Unable to connect to service.";
	self.statusDetails = nil;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"xmpp_updated" object:nil];
}

- (void)xmppClientDidDisconnect:(XMPPClient *)sender
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	self.connectionStatus = @"Disconnected from service.";
	self.statusDetails = nil;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"xmpp_updated" object:nil];
}

- (void)xmppClientDidAuthenticate:(XMPPClient *)sender
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	self.connectionStatus = @"Discovering online sites...";
	self.statusDetails = @"Authenticated.";
	[[NSNotificationCenter defaultCenter] postNotificationName:@"xmpp_updated" object:nil];
	
	[xmppClient fetchRoster];
}

- (void) sendNextIq:(NSTimer *) theTimer
{
	if ([pendingIqs count] > 0)
	{
		XMPPIQ * iq = [pendingIqs objectAtIndex:0];
		
		[xmppClient sendElement:iq];
		
		[pendingIqs removeObjectAtIndex:0];
	}
}

- (void) sendIq:(XMPPIQ *) iq to:(NSString *) jid
{
	NSMutableString * to = [NSMutableString stringWithString:jid];
	
	//	if ([to rangeOfString:@"/Shion"].location == NSNotFound)
	//		[to appendString:@"/Shion"];
	
	[iq addAttributeWithName:@"to" stringValue:to];
	
	// TODO: check connectivity
	
	// [xmppClient sendElement:iq];
	
	[pendingIqs addObject:iq];
}

- (void) removeJid:(XMPPJID *) jid
{
	for (NSString * identifier in [siteJidMap allKeys])
	{
		if ([[siteJidMap valueForKey:identifier] isEqual:[jid full]])
			[[ApplicationModel sharedModel] removeObjectWithIdentifier:identifier];
	}
}

- (void) sendStatus:(NSTimer *) theTimer
{
	NSString * command = [NSString stringWithFormat:@"shion:updateMobileDevice_status(\"%@\", \"%@\")", 
						  [UIDevice currentDevice].identifierForVendor, @"Online", nil]; 

	if (![[LocationManager sharedManager] reportsLocation])
		command = [NSString stringWithFormat:@"shion:updateMobileDevice_status(\"%@\", \"%@\")", 
				   [UIDevice currentDevice].identifierForVendor, @"Private", nil]; 
	
	[[XMPPManager sharedManager] broadcastCommand:command];

}

- (void) xmppClientDidUpdateRoster:(XMPPClient *) sender
{
	self.connected = YES;
	
	NSMutableArray * seen = [NSMutableArray array];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"xmpp_updated" object:nil];
	
	for (XMPPUser * user in [xmppClient unsortedUsers])
	{
		for (XMPPResource * resource in [user unsortedResources])
		{
			if (![sent containsObject:[[resource jid] description]])
			{
				[self sendIq:[FetchSiteInformationMessage iq] to:[[resource jid] full]];
				
				[sent addObject:[[resource jid] description]];
				
				UIDevice * device = [UIDevice currentDevice];

				NSString * command = [NSString stringWithFormat:@"shion:updateMobileDevice_name_address_platform_model_version(\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", 
									  device.identifierForVendor, device.name, @"", @"iOS", device.model, 
									  [NSString stringWithFormat:@"Shion Touch %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]],
									  nil];
				
				[[XMPPManager sharedManager] broadcastCommand:command];

				command = [NSString stringWithFormat:@"shion:updateMobileDevice_caller(\"%@\", \"%@\")", 
						   device.identifierForVendor, @"Unavailable", nil]; 

				[[XMPPManager sharedManager] broadcastCommand:command];

				[self sendStatus:nil];
				
				if (statusTimer == nil)
					statusTimer = [[NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(sendStatus:) userInfo:nil repeats:YES] retain];
			}
			
			[seen addObject:resource];
		}
	}
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)xmppClient:(XMPPClient *)sender didNotAuthenticate:(NSXMLElement *)error
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	self.connectionStatus = @"Unable to login to service.";
	self.statusDetails = @"Please verify your account details.";
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"xmpp_updated" object:nil];
	
	UIAlertView * errorView = [[UIAlertView alloc] initWithTitle:@"Invalid Account" 
														 message:@"Please check your login information." 
														delegate:self 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil];
	[errorView show];
	
	[[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(fetchCredentials:) userInfo:nil repeats:NO] retain];
	
	[errorView release];
}

- (NSDictionary *) dictForRecording:(DDXMLElement *) element
{
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	
	if ([[element name] isEqual:@"folder"])
	{
		[dict setValue:[[element attributeForName:@"title"] stringValue] forKey:@"title"];
		
		NSMutableArray * children = [NSMutableArray array];
		
		NSArray * recordings = [element elementsForName:@"recording"];
		for (DDXMLElement * child in recordings)
		{
			[children addObject:[self dictForRecording:child]];
		}		
		
		NSArray * folders = [element elementsForName:@"folder"];
		for (DDXMLElement * child in folders)
		{
			[children addObject:[self dictForRecording:child]];
		}		
		
		[dict setValue:children forKey:@"children"];
	}
	else
	{
		[dict setValue:[[element attributeForName:@"station"] stringValue] forKey:@"station"];
		[dict setValue:[[element attributeForName:@"title"] stringValue] forKey:@"title"];
		[dict setValue:[[element attributeForName:@"episode"] stringValue] forKey:@"episode"];
		[dict setValue:[[element attributeForName:@"episode_number"] stringValue] forKey:@"episode_number"];
		[dict setValue:[[element attributeForName:@"high_definition"] stringValue] forKey:@"high_definition"];
		[dict setValue:[[element attributeForName:@"synopsis"] stringValue] forKey:@"synopsis"];
		[dict setValue:[[element attributeForName:@"rating"] stringValue] forKey:@"rating"];
		[dict setValue:[[element attributeForName:@"duration"] stringValue] forKey:@"duration"];

		NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
		
		[dict setValue:[formatter dateFromString:[[element attributeForName:@"recorded"] stringValue]] forKey:@"recorded"];
		
		[formatter release];
	}
	
	return dict;
}

- (void) processMessage:(DDXMLElement *) message from:(XMPPJID *) jid
{
	ApplicationModel * model = [ApplicationModel sharedModel];
	
	if ([[message name] isEqual:@"site-information"])
	{
		NSString * siteName = [[message attributeForName:@"name"] stringValue];
		
		if (![[[ApplicationModel sharedModel] allSites] containsObject:siteName])
		{
			Site * site = [[Site alloc] init];
			[site setName:siteName];
			
			ApplicationModel * model = [ApplicationModel sharedModel];
			
			for (DDXMLElement * devicesElement in [message elementsForName:@"ds"])
			{
				for (DDXMLNode * node in [devicesElement elementsForName:@"d"])
				{
					if ([node isKindOfClass:[DDXMLElement class]])
					{
						DDXMLElement * deviceElement = (DDXMLElement *) node;
						
						Device * d = [Device deviceForXmlElement:deviceElement];

						if ([deviceElement attributeForName:@"i"] != nil)	
							[siteJidMap setValue:[jid full] forKey:[[deviceElement attributeForName:@"i"] stringValue]];

						[d setSite:siteName];
						
						id showMobile = [[NSUserDefaults standardUserDefaults] valueForKey:@"show_mobile_clients"];
						
						if ((showMobile == nil || [showMobile boolValue] == NO) && [d isKindOfClass:[MobileDevice class]])
						{
							
						}
						else
							[model addDevice:d];
					}
				}
			}
			
			for (DDXMLElement * snapshotsElement in [message elementsForName:@"ss"])
			{
				for (DDXMLNode * node in [snapshotsElement elementsForName:@"s"])
				{
					if ([node isKindOfClass:[DDXMLElement class]])
					{
						DDXMLElement * snapElement = (DDXMLElement *) node;
						
						Snapshot * s = [Snapshot snapshotForXmlElement:snapElement];
						
						if ([snapElement attributeForName:@"i"] != nil)	
							[siteJidMap setValue:[jid full] forKey:[[snapElement attributeForName:@"i"] stringValue]];
						
						[s setSite:siteName];
						
						[model addSnapshot:s];
					}
				}
			}
			
			for (DDXMLElement * triggersElement in [message elementsForName:@"ts"])
			{
				for (DDXMLNode * node in [triggersElement elementsForName:@"t"])
				{
					if ([node isKindOfClass:[DDXMLElement class]])
					{
						DDXMLElement * triggerElement = (DDXMLElement *) node;
						
						Trigger * t = [Trigger triggerForXmlElement:triggerElement];
						
						if ([triggerElement attributeForName:@"i"] != nil)	
							[siteJidMap setValue:[jid full] forKey:[[triggerElement attributeForName:@"i"] stringValue]];
						
						[t setSite:siteName];
						
						[model addTrigger:t];
					}
				}
			}
			
			[model addSite:site];
			[site release];
			
			self.connectionStatus = @"Connected to Shion Online.";
			self.statusDetails = @"Ready for use...";
			[[NSNotificationCenter defaultCenter] postNotificationName:@"xmpp_updated" object:nil];
		}
	}
	else if ([[message name] isEqual:@"es"])
	{
		NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd kk:mm.ssz"];
		
		NSString * deviceId = [[message attributeForName:@"d"] stringValue];
		
		if (deviceId != nil)
		{
			Device * device = [model deviceForIdentifier:deviceId];
			
			if (device != nil)
			{
				NSArray * events = [message elementsForName:@"e"];
				
				for (DDXMLElement * eventElement in events)
				{
					NSMutableDictionary * event = [NSMutableDictionary dictionaryWithDictionary:[eventElement attributesAsDictionary]];
					
					[event setValue:[formatter dateFromString:[event valueForKey:@"dt"]] forKey:@"date"];
					[event setValue:deviceId forKey:@"s"];
					[device addEvent:event];
				}
			}
			
			[device sortEvents];
		}
		
		[formatter release];
	}
	else if ([[message name] isEqual:@"event"])
	{
		NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd kk:mm.ssz"];
		
		NSString * source = [[message attributeForName:@"s"] stringValue];
		
		if (source != nil)
		{
			for (Device * device in [model devicesForIdentifier:source])
			{
				if (device != nil)
				{
					NSMutableDictionary * event = [NSMutableDictionary dictionaryWithDictionary:[message attributesAsDictionary]];
				
					[event setValue:[formatter dateFromString:[event valueForKey:@"dt"]] forKey:@"date"];
				
					for (DDXMLNode * node in [message children])
					{
						if ([node kind] == DDXMLElementKind)
						{
							DDXMLElement * element = (DDXMLElement *) node;
							
							if ([[element name] isEqual:@"dictionary"])
								[event setValuesForKeysWithDictionary:[element attributesAsDictionary]];
						}
					}
				
					[device addEvent:event];
				}
				
				[device sortEvents];
			}
		}
		
		[formatter release];
	}
	else if ([[message name] isEqual:@"beacon"])
	{
		NSString * identifier = [[message attributeForName:@"id"] stringValue];

		if ([identifier isEqual:[UIDevice currentDevice].identifierForVendor])
			[[SoundManager sharedManager] play:@"beacon"];
	}
	else if ([[message name] isEqual:@"photos"])
	{
		NSString * identifier = [[message attributeForName:@"camera"] stringValue];

		Device * device = [model deviceForIdentifier:identifier];
		
		if ([device isKindOfClass:[Camera class]])
		{
			Camera * camera = (Camera *) device;
			
			NSMutableArray * photos = [NSMutableArray array];
			
			for (DDXMLNode * node in [message children])
			{
				if ([node kind] == DDXMLElementKind)
				{
					DDXMLElement * element = (DDXMLElement *) node;
					
					if ([[element name] isEqual:@"photo"])
						[photos addObject:[[element attributeForName:@"id"] stringValue]];
				}
				
				[camera setPhotoList:photos];
			}
		}
	}
	else if ([[message name] isEqual:@"photo"])
	{
		NSString * identifier = [[message attributeForName:@"camera"] stringValue];
		
		Device * device = [model deviceForIdentifier:identifier];
		
		if ([device isKindOfClass:[Camera class]])
		{
			Camera * camera = (Camera *) device;

			NSString * dataString = [message stringValue];

			char * bytes = (char *) [dataString cStringUsingEncoding:NSASCIIStringEncoding];
			
			NSData * imageData = [NSData dataWithBytes:bytes length:[dataString lengthOfBytesUsingEncoding:NSASCIIStringEncoding]];
			
			NSMutableDictionary * photoDict = [NSMutableDictionary dictionary];
			[photoDict setValue:[[message attributeForName:@"id"] stringValue] forKey:@"id"];
			[photoDict setValue:[[message attributeForName:@"date"] stringValue] forKey:@"date"];
			[photoDict setValue:[imageData base64Decoded] forKey:@"data"];
			
			 // photo.id
			 // photo.date
			 // photo.url
			 // photo.caption
			 // --
			 // photo.data

			[camera addPhoto:photoDict];
			
		}
	}
	else if ([[message name] isEqual:@"recordings"])
	{
		NSString * identifier = [[message attributeForName:@"recorder"] stringValue];
		
		Device * device = [model deviceForIdentifier:identifier];
		
		if ([device isKindOfClass:[Tivo class]])
		{
			Tivo * tivo = (Tivo *) device;

			[tivo clearShows];
			
			NSArray * recordingElements = [message elementsForName:@"recording"];
			
			for (DDXMLElement * recordingElement in recordingElements)
			{
				NSDictionary * recordingDict = [self dictForRecording:recordingElement];
				
				[tivo addShow:recordingDict];
			}
			
			NSArray * folderElements = [message elementsForName:@"folder"];
			
			for (DDXMLElement * folderElement in folderElements)
			{
				NSDictionary * folderDict = [self dictForRecording:folderElement];
				
				[tivo addShow:folderDict];
			}
		}
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"model_updated" object:nil];
	}
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) broadcastCommand:(NSString *) command
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

	Device * device = [Device dictionaryWithObject:[UIDevice currentDevice].identifierForVendor forKey:DEVICE_IDENTIFIER];
	
	XMPPIQ * iq = [ScriptMessage iqForDevice:device script:command];

	NSMutableArray * ids = [NSMutableArray array];
	
	for (XMPPUser * user in [xmppClient unsortedUsers])
	{
		for (XMPPResource * resource in [user unsortedResources])
		{
			if (![[[resource jid] full] isEqual:[[xmppClient myJID] full]])
				[ids addObject:[[resource jid] full]];
		}
	}
	
	for (NSString * resource in ids)
	{
		[self sendIq:iq to:resource];
	}
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) sendCommand:(NSString *) command forDevice:(Device *) device
{
	if (device == nil)
		device = [Device dictionaryWithObject:[UIDevice currentDevice].identifierForVendor forKey:DEVICE_IDENTIFIER];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	XMPPIQ * iq = [ScriptMessage iqForDevice:device script:command];
	
	NSString * jid = [siteJidMap valueForKey:[device identifier]];

	NSMutableArray * ids = [NSMutableArray array];
	
	if (jid != nil)
		[ids addObject:jid];
	else
	{
		for (XMPPUser * user in [xmppClient unsortedUsers])
		{
			for (XMPPResource * resource in [user unsortedResources])
			{
				[ids addObject:[[resource jid] full]];
			}
		}
	}
	
	for (NSString * resource in ids)
		[self sendIq:iq to:resource];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) sendCommand:(NSString *) command forSnapshot:(Snapshot *) snapshot
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	XMPPIQ * iq = [ScriptMessage iqForSnapshot:snapshot script:command];
	
	NSString * jid = [siteJidMap valueForKey:[snapshot identifier]];
	
	if (jid != nil)
		[self sendIq:iq to:jid];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) sendCommand:(NSString *) command forTrigger:(Trigger *) trigger
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	XMPPIQ * iq = [ScriptMessage iqForTrigger:trigger script:command];
	
	NSString * jid = [siteJidMap valueForKey:[trigger identifier]];
	
	if (jid != nil)
		[self sendIq:iq to:jid];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) fetchEventsForDevice:(Device *) device
{
	NSDateFormatter * dayFormatter = [[NSDateFormatter alloc] init];
	[dayFormatter setDateFormat:@"yyyy-MM-dd"];
	
	NSDate * date = [NSDate date];
	
	NSTimeInterval dayInterval = 60 * 60 * 24;
	NSTimeInterval earliest = [date timeIntervalSince1970] - (10 * dayInterval);
	
	while ([date timeIntervalSince1970] > earliest)
	{
		NSString * command = [NSString stringWithFormat:@"shion:sendEventsForDevice_toJid_forDateString(\"%@\", \"%@\", \"%@\")", [device identifier], [[xmppClient myJID] full],
							  [dayFormatter stringFromDate:date]];
		
		[self sendCommand:command forDevice:device];
		

		date = [NSDate dateWithTimeIntervalSince1970:([date timeIntervalSince1970] - dayInterval)];
	}
	
	[dayFormatter release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)xmppClient:(XMPPClient *)sender didReceiveIQ:(XMPPIQ *)iq
{
	DDXMLElement * message = [[iq children] lastObject];
	
	[self processMessage:message from:[iq from]];
}

- (void)xmppClient:(XMPPClient *)sender didReceiveError:(NSXMLElement *)error
{
	NSLog(@"Error ::: %@", error);
}

- (XMPPManager *) init
{
	if (self = [super init])
	{
		pendingIqs = [[NSMutableArray alloc] init];
		iqTimer = [[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(sendNextIq:) userInfo:nil repeats:YES] retain];
	}
	
	return self;
}

+ (XMPPManager *) sharedManager
{
    @synchronized(self) 
	{
        if (sharedManager == nil) 
		{
            [[self alloc] init]; // assignment not done here
			
			sharedManager.connectionStatus = @"Initializing...";
        }
    }
    return sharedManager;
}

+ (id) allocWithZone:(NSZone *) zone
{
    @synchronized(self) 
	{
        if (sharedManager == nil) 
		{
            sharedManager = [super allocWithZone:zone];
            return sharedManager;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil
}

- (id) copyWithZone:(NSZone *) zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (unsigned) retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void) release
{
    //do nothing
}

- (id) autorelease
{
    return self;
}

@end
