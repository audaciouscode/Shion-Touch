//
//  ApplicationModel.m
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "ApplicationModel.h"

#import "DDXMLDocument.h"
#import "DDXMLElement.h"

#import "Device.h"
#import "Site.h"

@implementation ApplicationModel

static ApplicationModel * sharedModel = nil;

- (NSArray *) connectedSites
{
	NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"site_name" ascending:YES];
	NSArray * sorts = [NSArray arrayWithObject:sort];
	[sort release];
	
	return [_sites sortedArrayUsingDescriptors:sorts];
}

- (void) addSite:(Site *) site
{
	[_sites addObject:site];
}

- (void) removeObjectWithIdentifier:(NSString *) identifier
{
	NSString * site = nil;
	
	NSMutableArray * toRemove = [NSMutableArray array];
	
	for (Device * d in _devices)
	{
		if ([[d identifier] isEqual:identifier])
		{
			[toRemove addObject:d];
			site = [d site];
			
			NSMutableArray * locDevices = [NSMutableArray arrayWithArray:[[d location] devices]];
			[locDevices removeObject:d];
			
			if ([locDevices count] == 0)
				[_locations removeObject:[d location]];
			else
				[[d location] setDevices:locDevices];
		}
	}
	
	if ([toRemove count] > 0)
	{
		[_devices removeObjectsInArray:toRemove];
		
		if (site != nil && [[self devicesForSite:site] count] == 0 && [[self snapshotsAtSite:site] count] == 0 && [[self triggersAtSite:site] count] == 0)
		{
			Site * s = nil;
			
			for (Site * ss in _sites)
			{
				if ([[ss name] isEqual:site])
					s = ss;
			}
			
			if (s != nil)
				[_sites removeObject:s];
		}
	}
	
	[toRemove removeAllObjects];
	site = nil;

	for (Snapshot * s in _snapshots)
	{
		if ([[s identifier] isEqual:identifier])
		{
			[toRemove addObject:s];

			site = [s site];
		}
	}

	if ([toRemove count] > 0)
	{
		[_snapshots removeObjectsInArray:toRemove];
		
		if (site != nil && [[self devicesForSite:site] count] == 0 && [[self snapshotsAtSite:site] count] == 0 && [[self triggersAtSite:site] count] == 0)
		{
			Site * s = nil;
			
			for (Site * ss in _sites)
			{
				if ([[ss name] isEqual:site])
					s = ss;
			}
			
			if (s != nil)
				[_sites removeObject:s];
		}
	}		

	[toRemove removeAllObjects];
	site = nil;
	
	for (Trigger * t in _triggers)
	{
		if ([[t identifier] isEqual:identifier])
		{
			[toRemove addObject:t];
			
			site = [t site];
		}
	}
	
	if ([toRemove count] > 0)
	{
		[_triggers removeObjectsInArray:toRemove];
		
		if (site != nil && [[self devicesForSite:site] count] == 0 && [[self snapshotsAtSite:site] count] == 0 && [[self triggersAtSite:site] count] == 0)
		{
			Site * s = nil;
			
			for (Site * ss in _sites)
			{
				if ([[ss name] isEqual:site])
					s = ss;
			}
			
			if (s != nil)
				[_sites removeObject:s];
		}
	}		
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"model_updated" object:self];
}

- (NSArray *) favoriteDevices
{
	NSMutableArray * favorites = [NSMutableArray array];

	for (Device * d in _devices)
	{
		if ([d favorite])
			[favorites addObject:d];
	}
	
	return favorites;
}

- (NSArray *) favoriteSnapshots
{
	NSMutableArray * favorites = [NSMutableArray array];
	
	for (Snapshot * s in _snapshots)
	{
		if ([s favorite])
			[favorites addObject:s];
	}
	
	return favorites;
}	

- (NSArray *) favoriteTriggers
{
	NSMutableArray * favorites = [NSMutableArray array];
	
	for (Trigger * t in _triggers)
	{
		if ([t favorite])
			[favorites addObject:t];
	}
	
	return favorites;
}	

- (NSArray *) locations
{

	NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:LOCATION_NAME ascending:YES];
	
	[_locations sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
	
	[sort release];
	
	
	return _locations;
}

+ (ApplicationModel *) sharedModel
{
    @synchronized(self) 
	{
        if (sharedModel == nil) 
		{
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedModel;
}

- (void) addDevice:(Device *) device
{
	NSMutableArray * toRemove = [NSMutableArray array];
	
	for (Device * d in _devices)
	{
		if ([[d valueForKey:@"name"] isEqual:[device valueForKey:@"name"]] &&
			[[d valueForKey:@"address"] isEqual:[device valueForKey:@"address"]] &&
			[[d valueForKey:@"location"] isEqual:[device valueForKey:@"location"]])
		{
			[toRemove addObject:d];
		}
	}
	
	[_devices removeObjectsInArray:toRemove];
	
	[_devices addObject:device];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"model_updated" object:self];
}

- (void) addSnapshot:(Snapshot *) snapshot
{
	NSMutableArray * toRemove = [NSMutableArray array];
	
	for (Snapshot * s in _snapshots)
	{
		if ([[s identifier] isEqual:[snapshot identifier]])
			[toRemove addObject:s];
	}
	
	[_snapshots removeObjectsInArray:toRemove];
	
	[_snapshots addObject:snapshot];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"model_updated" object:self];
}

- (void) addTrigger:(Trigger *) trigger
{
	NSMutableArray * toRemove = [NSMutableArray array];
	
	for (Trigger * t in _triggers)
	{
		if ([[t identifier] isEqual:[trigger identifier]])
			[toRemove addObject:t];
	}
	
	[_triggers removeObjectsInArray:toRemove];
	
	[_triggers addObject:trigger];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"model_updated" object:self];
}

- (void) loadSampleData
{
	NSString * path = [[NSBundle mainBundle] pathForResource:@"init" ofType:@"xml" inDirectory:@"XML"];
	NSData * data = [NSData dataWithContentsOfFile:path];
	
	DDXMLDocument * xml = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];

	DDXMLElement * root = [xml rootElement];

	NSArray * devicesElements = [root elementsForName:@"devices"];
	
	for (DDXMLElement * devices in devicesElements)
	{
		NSArray * elements = [devices elementsForName:@"lamp"];
		
		for (DDXMLElement * deviceXml in elements)
		{
			Device * d = [Device deviceForXmlElement:deviceXml];
			[_devices addObject:d];
		}

		elements = [devices elementsForName:@"appliance"];
		
		for (DDXMLElement * deviceXml in elements)
		{
			Device * d = [Device deviceForXmlElement:deviceXml];
			[_devices addObject:d];
		}

		elements = [devices elementsForName:@"thermostat"];
		
		for (DDXMLElement * deviceXml in elements)
		{
			Device * d = [Device deviceForXmlElement:deviceXml];
			[_devices addObject:d];
		}
		
		elements = [devices elementsForName:@"phone"];
		
		for (DDXMLElement * deviceXml in elements)
		{
			Device * d = [Device deviceForXmlElement:deviceXml];
			[_devices addObject:d];
		}
		
		elements = [devices elementsForName:@"controller"];
		
		for (DDXMLElement * deviceXml in elements)
		{
			Device * d = [Device deviceForXmlElement:deviceXml];
			[_devices addObject:d];
		}
		
		elements = [devices elementsForName:@"sensor"];
		
		for (DDXMLElement * deviceXml in elements)
		{
			Device * d = [Device deviceForXmlElement:deviceXml];
			[_devices addObject:d];
		}
		
		elements = [devices elementsForName:@"house"];
		
		for (DDXMLElement * deviceXml in elements)
		{
			Device * d = [Device deviceForXmlElement:deviceXml];
			[_devices addObject:d];
		}
	}

	NSArray * snapshotsElements = [root elementsForName:@"snapshots"];
	
	for (DDXMLElement * snapshots in snapshotsElements)
	{
		NSArray * elements = [snapshots elementsForName:@"snapshot"];
		
		for (DDXMLElement * snapshotXml in elements)
		{
			Snapshot * s = [Snapshot snapshotForXmlElement:snapshotXml];
			[_snapshots addObject:s];
		}
	}
	
	[xml release];
}

- (id) init
{
	if (self = [super init])
	{
		_locations = [[NSMutableArray alloc] init];
		_devices = [[NSMutableArray alloc] init];
		_snapshots = [[NSMutableArray alloc] init];
		_triggers = [[NSMutableArray alloc] init];
		_sites = [[NSMutableArray alloc] init];
	}
	
	return self;
}

+ (id) allocWithZone:(NSZone *) zone
{
    @synchronized(self) 
	{
        if (sharedModel == nil) 
		{
            sharedModel = [super allocWithZone:zone];
            return sharedModel;  // assignment and return on first allocation
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

- (Location *) locationForName:(NSString *) name create:(BOOL) createNew
{
	for (Location * l in _locations)
	{
		if ([[l name] isEqual:name])
			return l;
	}
	
	if (createNew)
	{
		Location * l = [[Location alloc] initWithName:name];
		[_locations addObject:l];
		
		return [l autorelease];
	}
	
	return nil;
	
}

- (NSArray *) allDevices
{
	NSMutableArray * devices = [NSMutableArray array];
	
	for (Device * d in _devices)
		[devices addObject:d];
	
	NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:DEVICE_NAME ascending:YES];
	
	[devices sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
	
	[sort release];
	
	return devices;
}

- (NSArray *) devicesWithType:(NSString *) type
{
	NSMutableArray * devices = [NSMutableArray array];
	
	for (Device * d in _devices)
	{
		if ([[d type] isEqual:type])
			[devices addObject:d];
	}
	
	NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:DEVICE_NAME ascending:YES];
	[devices sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
	[sort release];
	
	return devices;
}

- (NSArray *) devicesForSite:(NSString *) site
{
	NSMutableArray * devices = [NSMutableArray array];
	
	for (Device * d in _devices)
	{
		if ([[d site] isEqual:site])
			[devices addObject:d];
	}
	
	NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:DEVICE_NAME ascending:YES];
	[devices sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
	[sort release];
	
	return devices;
}

- (NSArray *) devicesWithPlatform:(NSString *) platform
{
	NSMutableArray * devices = [NSMutableArray array];
	
	for (Device * d in _devices)
	{
		if ([[d platform] isEqual:platform])
			[devices addObject:d];
	}
	
	NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:DEVICE_NAME ascending:YES];
	[devices sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
	[sort release];
	
	return devices;
}

- (NSArray *) allTypes
{
	NSMutableArray * types = [NSMutableArray array];
	
	for (Device * d in _devices)
	{
		if (![types containsObject:[d type]])
			[types addObject:[d type]];
	}
	
	[types sortUsingSelector:@selector(caseInsensitiveCompare:)];
	
	return types;
}	

- (NSArray *) allPlatforms
{
	NSMutableArray * platforms = [NSMutableArray array];
	
	for (Device * d in _devices)
	{
		if (![platforms containsObject:[d platform]])
			[platforms addObject:[d platform]];
	}
	
	[platforms sortUsingSelector:@selector(caseInsensitiveCompare:)];
	
	return platforms;
}	

- (NSArray *) devicesForLocation:(Location *) location
{
	NSArray * devices = [location devices];
	
	if (devices == nil)
	{
		NSMutableArray * localDevices = [NSMutableArray array];
		
		for (Device * d in _devices)
		{
			if ([d location] == location)
				[localDevices addObject:d];
		}

		NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:DEVICE_NAME ascending:YES];
		[localDevices sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
		[sort release];
		
		[location setDevices:localDevices];
		
		return localDevices;
	}
	
	return devices;
}

- (NSArray *) allSites
{
	NSMutableArray * sites = [NSMutableArray array];
	
	for (Device * d in _devices)
	{
		if (![sites containsObject:[d site]] && [d site] != nil)
			[sites addObject:[d site]];
	}

	for (Snapshot * s in _snapshots)
	{
		if (![sites containsObject:[s site]] && [s site] != nil)
			[sites addObject:[s site]];
	}
	
	[sites sortUsingSelector:@selector(caseInsensitiveCompare:)];
	
	return sites;
}	

- (NSArray *) snapshotsAtSite:(NSString *) site
{
	NSMutableArray * snapshots = [NSMutableArray array];
	
	for (Snapshot * s in _snapshots)
	{
		if ([[s site] isEqual:site])
			[snapshots addObject:s];
	}
	
	NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:SNAPSHOT_NAME ascending:YES];
	[snapshots sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
	[sort release];
	
	return snapshots;
}

- (NSArray *) allSnapshots
{
	NSMutableArray * snapshots = [NSMutableArray array];
	
	for (Snapshot * s in _snapshots)
		[snapshots addObject:s];
	
	NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:SNAPSHOT_NAME ascending:YES];
	
	[snapshots sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
	
	[sort release];
	
	return snapshots;
}

- (NSArray *) allCategories
{
	NSMutableArray * categories = [NSMutableArray array];
	
	for (Snapshot * s in _snapshots)
	{
		if (![categories containsObject:[s category]])
			[categories addObject:[s category]];
	}
	
	[categories sortUsingSelector:@selector(caseInsensitiveCompare:)];
	
	return categories;
}

- (NSArray *) snapshotsWithCategory:(NSString *) category
{
	NSMutableArray * snapshots = [NSMutableArray array];
	
	for (Snapshot * s in _snapshots)
	{
		if ([[s category] isEqual:category])
			[snapshots addObject:s];
	}
	
	NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:SNAPSHOT_NAME ascending:YES];
	[snapshots sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
	[sort release];
	
	return snapshots;
}	

- (Device *) deviceForIdentifier:(NSString *) identifier
{
	for (Device * d in _devices)
	{
		if ([[d identifier] isEqual:identifier])
			 return d;
	}
	
	return nil;
}

- (NSArray *) devicesForIdentifier:(NSString *) identifier
{
	NSMutableArray * devices = [NSMutableArray array];
	
	for (Device * d in _devices)
	{
		if ([[d identifier] isEqual:identifier])
			[devices addObject:d];
	}
	
	return devices;
}

- (NSArray *) triggersAtSite:(NSString *) site
{
	NSMutableArray * triggers = [NSMutableArray array];
	
	for (Trigger * t in _triggers)
	{
		if ([[t site] isEqual:site])
			[triggers addObject:t];
	}
	
	NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:TRIGGER_NAME ascending:YES];
	[triggers sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
	[sort release];
	
	return triggers;
}

- (NSArray *) triggerTypes
{
	NSMutableArray * types = [NSMutableArray array];
	
	for (Trigger * t in _triggers)
	{
		if (![types containsObject:[t type]])
			[types addObject:[t type]];
	}

	[types sortUsingSelector:@selector(compare:)];
	
	return types;
}

- (NSArray *) triggersForType:(NSString *) type
{
	NSMutableArray * triggers = [NSMutableArray array];
	
	for (Trigger * t in _triggers)
	{
		if ([[t type] isEqual:type])
			[triggers addObject:t];
	}
	
	NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:TRIGGER_NAME ascending:YES];
	[triggers sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
	[sort release];
	
	return triggers;
}

@end
