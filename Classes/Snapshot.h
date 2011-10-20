//
//  Snapshot.h
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXMLElement.h"
#import "OrderedDictionary.h"

#define SNAPSHOT_NAME @"snapshot_name"

@interface Snapshot : OrderedDictionary
{
	NSMutableArray * devices;
}

@property(retain) NSMutableArray * devices;

+ (Snapshot *) snapshotForXmlElement:(DDXMLElement *) element;
- (id) initWithXmlElement:(DDXMLElement *) element;

- (NSString *) name;
- (NSString *) description;
- (NSString *) site;
- (void) setSite:(NSString *) site;
- (NSString *) identifier;
- (NSString *) category;

- (BOOL) favorite;
- (void) setFavorite:(BOOL) favorite;

@end
