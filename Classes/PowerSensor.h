//
//  PowerSensor.h
//  Shion Touch
//
//  Created by Chris Karr on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Device.h"

@interface PowerSensor : Device 
{
	NSNumber * level;
}

@property(retain) NSNumber * level;

@end

