//
//  Device.m
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "Device.h"
#import "ApplicationModel.h"
#import "Appliance.h"
#import "Lamp.h"
#import "Thermostat.h"
#import "Phone.h"
#import "Controller.h"
#import "MotionSensor.h"
#import "ApertureSensor.h"
#import "PowerSensor.h"
#import "PowerMeterSensor.h"
#import "House.h"
#import "Chime.h"
#import "MobileDevice.h"
#import "Camera.h"
#import "Tivo.h"
#import "Lock.h"
#import "WeatherSensor.h"

#import "FavoritesManager.h"
#import "XMPPManager.h"
#import "NSString+XMLEntities.h"

#import "DDXMLNode.h"

#define DEVICE_ADDRESS @"device_address"
#define DEVICE_UNIDIRECTIONAL @"device_unidirectional"
#define DEVICE_LAST_UPDATE @"device_last_update"
#define DEVICE_LOCATION @"device_location"
#define DEVICE_MODEL @"device_model"
#define DEVICE_SITE @"device_site"
#define DEVICE_PLATFORM @"device_platform"

@implementation Device

- (BOOL) favorite
{
	return [[FavoritesManager sharedManager] isFavorite:[self identifier]];
}

- (void) setFavorite:(BOOL) favorite
{
	[[FavoritesManager sharedManager] setFavorite:favorite identifier:[self identifier]];

	[[NSNotificationCenter defaultCenter] postNotificationName:@"favorites_changed" object:self];
}

+ (Device *) deviceForXmlElement:(DDXMLElement *) element
{
	Device * device = nil;
	
	NSString * type = [[element attributeForName:@"t"] stringValue];
	
	if ([type isEqual:@"Appliance"])
		device = [[Appliance alloc] initWithXmlElement:element];
	else if ([type isEqual:@"Lamp"])
		device = [[Lamp alloc] initWithXmlElement:element];
	else if ([type isEqual:@"Thermostat"])
		device = [[Thermostat alloc] initWithXmlElement:element];
	else if ([type isEqual:@"Phone"])
		device = [[Phone alloc] initWithXmlElement:element];
	else if ([type isEqual:@"TiVo Digital Video Recorder"])
		device = [[Tivo alloc] initWithXmlElement:element];
	else if ([type isEqual:@"Controller"])
		device = [[Controller alloc] initWithXmlElement:element];
	else if ([type isEqual:@"Motion Sensor"])
		device = [[MotionSensor alloc] initWithXmlElement:element];
	else if ([type isEqual:@"Telephone / Modem"])
		device = [[Phone alloc] initWithXmlElement:element];
	else if ([type isEqual:@"House"])
		device = [[House alloc] initWithXmlElement:element];
	else if ([type isEqual:@"Chime"])
		device = [[Chime alloc] initWithXmlElement:element];
	else if ([type isEqual:@"Mobile Device"])
		device = [[MobileDevice alloc] initWithXmlElement:element];
	else if ([type isEqual:@"Aperture Sensor"])
		device = [[ApertureSensor alloc] initWithXmlElement:element];
	else if ([type isEqual:@"Power Sensor"])
		device = [[PowerSensor alloc] initWithXmlElement:element];
	else if ([type isEqual:@"Weather Station"])
		device = [[WeatherSensor alloc] initWithXmlElement:element];
	else if ([type isEqual:@"Lock"])
		device = [[Lock alloc] initWithXmlElement:element];
	else if ([type isEqual:@"Power Meter Sensor"])
		device = [[PowerMeterSensor alloc] initWithXmlElement:element];
	else if ([type isEqual:@"Camera"])
		device = [[Camera alloc] initWithXmlElement:element];
	else
		device = [[Device alloc] initWithXmlElement:element];

	return [device autorelease];
}

- (void) resetFetched:(NSTimer *) theTimer
{
	fetched = NO;
}

- (id) initWithXmlElement:(DDXMLElement *) element
{
	if (self = [super init])
	{
		events = [[NSMutableArray alloc] init];
		
		CFUUIDRef uuid = CFUUIDCreate(NULL);
		NSString * identifier = [((NSString *) CFUUIDCreateString(NULL, uuid)) autorelease];
		[self setValue:identifier forKey:DEVICE_IDENTIFIER];
		CFRelease(uuid);
		
		[self setValue:@"Unknown Platform" forKey:DEVICE_PLATFORM];

		DDXMLNode * attribute = nil;
		
		if (attribute = [element attributeForName:@"n"])
			[self setValue:[[attribute stringValue] stringByDecodingXMLEntities] forKey:DEVICE_NAME];
		else
			[self setValue:@"Unknown Device" forKey:DEVICE_NAME];

		if (attribute = [element attributeForName:@"a"])
			[self setValue:[[attribute stringValue] stringByDecodingXMLEntities] forKey:DEVICE_ADDRESS];

		if (attribute = [element attributeForName:@"i"])
			[self setValue:[attribute stringValue] forKey:DEVICE_IDENTIFIER];

		if (attribute = [element attributeForName:@"l"])
		{
			Location * location = [[ApplicationModel sharedModel] locationForName:[[attribute stringValue] stringByDecodingXMLEntities] create:YES];
		
			[self setValue:location forKey:DEVICE_LOCATION];
		}

		if (attribute = [element attributeForName:@"m"])
			[self setValue:[[attribute stringValue] stringByDecodingXMLEntities] forKey:DEVICE_MODEL];

		if (attribute = [element attributeForName:@"p"])
			[self setValue:[[attribute stringValue] stringByDecodingXMLEntities] forKey:DEVICE_PLATFORM];
		
		fetched = NO;
		
		fetchTimer = [[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(resetFetched:) userInfo:nil repeats:YES] retain];
	}

	return self;
}

- (CGFloat) intensity
{
	return 1.0;
}

- (NSString *) shortDescription
{
	return [self description];
}

- (void) dealloc
{
	[events release];
	
	[super dealloc];
}

- (void) addEvent:(NSDictionary *) event
{
	NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:event];

	[dict setValue:[event valueForKey:@"t"] forKey:@"type"];
	[dict setValue:[event valueForKey:@"s"] forKey:@"source"];
	[dict setValue:[event valueForKey:@"dt"] forKey:@"date"];
	
	[events addObject:event];

	[self sortEvents];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"view_refresh" object:nil];
	
}

- (NSString *) identifier
{
	return [self valueForKey:DEVICE_IDENTIFIER];
}

- (NSString *) platform
{
	return [self valueForKey:DEVICE_PLATFORM];
}

- (NSString *) name
{
	return [self valueForKey:DEVICE_NAME];
}

- (NSString *) address
{
	return [self valueForKey:DEVICE_ADDRESS];
}

- (NSString *) site
{
	return [self valueForKey:DEVICE_SITE];
}

- (void) setSite:(NSString *) site
{
	[self setValue:site forKey:DEVICE_SITE];
}

- (BOOL) unidirectional;
{
	return [[self valueForKey:DEVICE_UNIDIRECTIONAL] boolValue];
}

- (NSDate *) lastUpdate;
{
	if ([events count] > 0)
		return [[events lastObject] valueForKey:@"date"];
	
	return nil;
}

- (NSString *) description
{
	return [self model];
}

- (Location *) location;
{
	return [self valueForKey:DEVICE_LOCATION];
}

- (NSString *) model;
{
	NSString * model = [self valueForKey:DEVICE_MODEL];
	
	if (model == nil || [model isEqual:@""])
		model = @"Unknown Model";
	
	return model;
}

- (void) updateWithXmlElement:(DDXMLElement *) element
{
	// TODO
}

- (NSString *) type
{
	return @"Unknown Type";
}

- (void) sortEvents
{
	NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
	
	[events sortUsingDescriptors:[NSArray arrayWithObject:sort]];
	 
	 [sort release];
}

- (NSArray *) events
{
	if ([events count] == 0 && fetched == NO)
	{
		[[XMPPManager sharedManager] fetchEventsForDevice:self];
		fetched = YES;
	}
	
	return events;
}

- (UIImage *) statusImage
{
	UIGraphicsBeginImageContext(CGSizeMake(64, 64));		
	CGContextRef context = UIGraphicsGetCurrentContext();		
	UIGraphicsPushContext(context);								

	CGRect circleBounds = CGRectMake(12, 12, 40, 40);
	CGContextSetLineWidth (context, 8.0);

	[[UIColor blackColor] setFill];
	CGContextFillEllipseInRect(context, circleBounds);

	UIColor * color = [[self color] colorWithAlphaComponent:[self intensity]];
	[color setFill];
	CGContextFillEllipseInRect(context, circleBounds);

	[[UIColor blackColor] setStroke];
	CGContextStrokeEllipseInRect(context, circleBounds);
	
	UIGraphicsPopContext();								
	
	UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return image;
}

- (UIColor *) color
{
	return [UIColor grayColor];
}

- (BOOL) editable
{
	return NO;
}

@end
