//
//  Thermostat.h
//  Shion Touch
//
//  Created by Chris Karr on 3/1/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Device.h"

@interface Thermostat : Device
{
	NSInteger minTemp;
	NSInteger maxTemp;
}

@property(assign) NSInteger minTemp;
@property(assign) NSInteger maxTemp;

- (NSString *) mode;
- (BOOL) fanActive;
- (NSNumber *) temperature;
- (NSNumber *) coolPoint;
- (NSNumber *) heatPoint;

@end
