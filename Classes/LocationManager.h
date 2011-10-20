//
//  LocationManager.h
//  Shion Touch
//
//  Created by Chris Karr on 8/16/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>
{
	CLLocationManager * locationManager;
	
	NSDate * lastSend;
}

+ (LocationManager *) sharedManager;
- (BOOL) reportsLocation;

@end
