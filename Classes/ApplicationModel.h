//
//  ApplicationModel.h
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "Snapshot.h"
#import "Device.h"
#import "Trigger.h"
#import "Site.h"

@interface ApplicationModel : NSObject 
{
	NSMutableArray * _locations;
	NSMutableArray * _devices;
	NSMutableArray * _snapshots;
	NSMutableArray * _triggers;
	NSMutableArray * _sites;
}

+ (ApplicationModel *) sharedModel;

- (NSArray *) favoriteDevices;
- (NSArray *) favoriteSnapshots;
- (NSArray *) favoriteTriggers;

- (NSArray *) locations;

- (Location *) locationForName:(NSString *) name create:(BOOL) createNew;
- (NSArray *) devicesForLocation:(Location *) location;

- (void) addDevice:(Device *) device;
- (void) addSnapshot:(Snapshot *) snapshot;
- (void) addTrigger:(Trigger *) trigger;

- (NSArray *) allDevices;

- (NSArray *) allTypes;
- (NSArray *) devicesWithType:(NSString *) type;

- (NSArray *) devicesForSite:(NSString *) site;

- (NSArray *) allPlatforms;
- (NSArray *) devicesWithPlatform:(NSString *) platform;

- (NSArray *) allSnapshots;

- (NSArray *) allSites;
- (NSArray *) snapshotsAtSite:(NSString *) site;

- (NSArray *) allCategories;
- (NSArray *) snapshotsWithCategory:(NSString *) category;

- (Device *) deviceForIdentifier:(NSString *) identifier;
- (NSArray *) devicesForIdentifier:(NSString *) identifier;

- (NSArray *) connectedSites;
- (void) addSite:(Site *) site;

- (void) removeObjectWithIdentifier:(NSString *) identifier;

- (NSArray *) triggersAtSite:(NSString *) site;
- (NSArray *) triggerTypes;
- (NSArray *) triggersForType:(NSString *) type;

@end
