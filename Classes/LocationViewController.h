//
//  LocationViewController.h
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface LocationViewController : UITableViewController 
{
	Location * location;
}

@property(retain) Location * location;

@end
