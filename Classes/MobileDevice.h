//
//  MobileDevice.h
//  Shion Touch
//
//  Created by Chris Karr on 8/17/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Device.h"

@interface MobileDevice : Device 
{
	NSString * version;
}

- (NSString *) version;
- (NSString *) status;
- (NSNumber *) latitude;
- (NSNumber *) longitude;

- (NSString *) lastCaller;

- (void) beacon;

@end
