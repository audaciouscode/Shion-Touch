//
//  ApertureSensor.h
//  Shion Touch
//
//  Created by Chris Karr on 5/25/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Device.h"

@interface ApertureSensor : Device
{
	NSNumber * level;
}

@property(retain) NSNumber * level;

@end
