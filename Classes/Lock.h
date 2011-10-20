//
//  Lock.h
//  Shion Touch
//
//  Created by Chris Karr on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Device.h"

@interface Lock : Device
{
	NSNumber * locked;
}

@property(retain) NSNumber * locked;

@end
