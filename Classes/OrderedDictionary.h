//
//  OrderedDictionary.h
//  Shion Touch
//
//  Created by Chris Karr on 2/22/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderedDictionary : NSMutableDictionary
{
	NSMutableDictionary * store;
	NSMutableArray * sortedKeyArray;
}

- (NSUInteger) count;
- (id) objectForKey:(id) aKey;
- (NSEnumerator *) keyEnumerator;
- (void) setObject:(id) anObject forKey:(id) aKey;
- (void) removeObjectForKey:(id) aKey;
- (id) valueAtIndex:(NSUInteger) index;
@end
