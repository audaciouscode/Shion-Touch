//
//  Device.h
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderedDictionary.h"
#import "Location.h"
#import "DDXMLElement.h"

#define DEVICE_NAME @"device_name"
#define DEVICE_IDENTIFIER @"device_identifier"

@interface Device : OrderedDictionary 
{
	NSMutableArray * events;
	BOOL fetched;
	NSTimer * fetchTimer;
}

+ (Device *) deviceForXmlElement:(DDXMLElement *) element;

- (id) initWithXmlElement:(DDXMLElement *) element;

- (NSString *) name;
- (NSString *) address;
- (NSString *) identifier;
- (BOOL) unidirectional;
- (NSDate *) lastUpdate;
- (Location *) location;
- (NSString *) model;
- (NSString *) type;
- (NSString *) description;
- (NSString *) site;
- (NSString *) platform;

- (void) setSite:(NSString *) site;

- (BOOL) favorite;
- (void) setFavorite:(BOOL) favorite;

- (void) updateWithXmlElement:(DDXMLElement *) element;

- (NSArray *) events;
- (void) sortEvents;

- (void) addEvent:(NSDictionary *) event;

- (CGFloat) intensity;

- (NSString *) shortDescription;

- (UIImage *) statusImage;

- (UIColor *) color;

- (BOOL) editable;

@end
