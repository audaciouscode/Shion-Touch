//
//  MotionSensor.h
//  Shion Touch
//
//  Created by Chris Karr on 4/23/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Device.h"

@interface MotionSensor : Device
{
	NSNumber * level;
}

@property(retain) NSNumber * level;

@end
