//
//  DictionaryAnnotation.h
//  Shion Touch
//
//  Created by Chris Karr on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "OrderedDictionary.h"

@interface DictionaryAnnotation : OrderedDictionary <MKAnnotation>
{

}

- (CLLocationCoordinate2D) coordinate;
- (NSString *) title;

@end
