//
//  MobileDeviceViewController.h
//  Shion Touch
//
//  Created by Chris Karr on 8/17/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MobileDevice.h"

@interface MobileDeviceViewController : UITableViewController<UIActionSheetDelegate>
{
	MobileDevice * device;
}

@property(retain) MobileDevice * device;

@end
