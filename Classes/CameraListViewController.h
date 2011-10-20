//
//  CameraListViewController.h
//  Shion Touch
//
//  Created by Chris Karr on 12/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"

@interface CameraListViewController : UITableViewController 
{
	Device * device;
}

@property(retain) Device * device;

@end
