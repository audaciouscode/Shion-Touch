//
//  Site.h
//  Shion Touch
//
//  Created by Chris Karr on 4/23/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderedDictionary.h"


@interface Site : OrderedDictionary 
{

}

- (NSString *) name;
- (void) setName:(NSString *) name;

- (UIImage *) siteImage;

- (NSString *) networkDescription;
- (NSString *) deviceCountDescription;

@end
