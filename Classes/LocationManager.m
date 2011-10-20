//
//  LocationManager.m
//  Shion Touch
//
//  Created by Chris Karr on 8/16/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "LocationManager.h"

#import "ApplicationModel.h"
#import "XMPPManager.h"

@implementation LocationManager

static LocationManager * sharedManager = nil;

+ (LocationManager *) sharedManager
{
    @synchronized(self) 
	{
        if (sharedManager == nil) 
		{
            [[self alloc] init]; // assignment not done here
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

- (BOOL) reportsLocation
{
	NSNumber * doReport = [[NSUserDefaults standardUserDefaults] valueForKey:@"report_location"];
	
	BOOL report = NO;
	
	if (doReport != nil)
		report = [doReport boolValue];

	return report;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([self reportsLocation] && locationManager == nil)
	{
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self; 
		locationManager.distanceFilter = 10;
		
		[locationManager startUpdatingLocation];
	}
	else if (![self reportsLocation] && locationManager != nil)
	{
		[locationManager stopUpdatingLocation];
		[locationManager release];
		locationManager = nil;
	}
}

- (id) init
{
	if (self = [super init])
	{
		[[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"report_location" options:0 context:NULL];

		locationManager = nil;

		lastSend = [[NSDate distantPast] retain];

		[self observeValueForKeyPath:@"" ofObject:nil change:nil context:NULL];
	}

	return self;
}

- (void) dealloc
{
	[locationManager stopUpdatingLocation];

	[locationManager release];

	[super dealloc];
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

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSDate * now = [NSDate date];
	
	if ([now timeIntervalSinceDate:lastSend] < 10)
		return;

	NSString * command = [NSString stringWithFormat:@"shion:updateLatitude_longitude_forDevice(%f, %f, \"%@\")", newLocation.coordinate.latitude, 
						  newLocation.coordinate.longitude, [UIDevice currentDevice].uniqueIdentifier, nil];
	
	NSDate * toRelease = lastSend;
	
	lastSend = [now retain];
	
	[toRelease release];
	
	[[XMPPManager sharedManager] broadcastCommand:command];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSString * errorString = @"Unknown Location";
	
	if ([error code] == kCLErrorDenied)
		errorString = @"Permission Denied";
	
	NSString * command = [NSString stringWithFormat:@"shion:updateLocationError_forDevice(\"%@\", \"%@\")", errorString, 
						  [UIDevice currentDevice].uniqueIdentifier, nil];
	
	[[XMPPManager sharedManager] broadcastCommand:command];
}

@end
