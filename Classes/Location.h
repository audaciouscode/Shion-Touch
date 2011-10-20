//
//  Location.h
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderedDictionary.h"

#define LOCATION_NAME @"name"

@interface Location : OrderedDictionary
{

}

- (id) initWithName:(NSString *) name;
- (NSString *) name;
- (NSString *) details;

- (void) setDevices:(NSArray *) devices;
- (NSArray *) devices;

- (void) setSnapshots:(NSArray *) snapshots;
- (NSArray *) snapshots;

@end
