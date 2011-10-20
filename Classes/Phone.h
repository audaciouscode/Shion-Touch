//
//  Phone.h
//  Shion Touch
//
//  Created by Chris Karr on 3/1/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Device.h"

#define PHONE_CALLER @"caller_name"
#define PHONE_NUMBER @"number"
#define PHONE_CALL_DATE @"date"

@interface Phone : Device 
{

}

- (NSArray *) calls;

@end
