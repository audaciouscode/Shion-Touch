//
//  Appliance.h
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Device.h"

#define APPLIANCE_LEVEL @"level"

@interface Appliance : Device 
{
	NSNumber * level;
}

@property(assign) NSNumber * level;

@end
