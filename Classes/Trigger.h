//
//  Trigger.h
//  Shion Touch
//
//  Created by Chris Karr on 7/4/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderedDictionary.h"
#import "DDXML.h"

#define TRIGGER_NAME @"trigger_name"

@interface Trigger : OrderedDictionary 
{

}

+ (Trigger *) triggerForXmlElement:(DDXMLElement *) element;
- (id) initWithXmlElement:(DDXMLElement *) element;

- (NSString *) name;
- (NSString *) conditions;
- (NSString *) site;
- (NSDate *) fired;
- (NSString *) type;
- (void) setSite:(NSString *) site;
- (NSString *) identifier;
- (NSString *) action;

- (BOOL) favorite;
- (void) setFavorite:(BOOL) favorite;

@end
