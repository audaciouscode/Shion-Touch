//
//  FavoritesManager.h
//  Shion Touch
//
//  Created by Chris Karr on 4/22/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FavoritesManager : NSObject 
{
	NSMutableSet * favorites;
}

+ (FavoritesManager *) sharedManager;

- (BOOL) isFavorite:(NSString *) identifier;
- (void) setFavorite:(BOOL) favorite identifier:(NSString *) identifier;

@end
