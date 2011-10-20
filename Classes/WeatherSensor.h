//
//  WeatherSensor.h
//  Shion Touch
//
//  Created by Chris Karr on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Device.h"

@interface WeatherSensor : Device 
{
	NSNumber * level;
	
	NSInteger minTemp;
	NSInteger maxTemp;
	
}

@property(retain) NSNumber * level;

@property(assign) NSInteger minTemp;
@property(assign) NSInteger maxTemp;

@end
