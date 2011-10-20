//
//  PowerMeterSensor.h
//  Shion Touch
//
//  Created by Chris Karr on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Device.h"

@interface PowerMeterSensor : Device 
{
	NSNumber * level;
	
	NSInteger minPower;
	NSInteger maxPower;

}

@property(retain) NSNumber * level;

@property(assign) NSInteger minPower;
@property(assign) NSInteger maxPower;

@end
