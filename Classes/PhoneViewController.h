//
//  PhoneViewController.h
//  Shion Touch
//
//  Created by Chris Karr on 4/26/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "Device.h"

@interface PhoneViewController : UITableViewController <ABPersonViewControllerDelegate, UIActionSheetDelegate>
{
	Device * device;
}

@property(retain) Device * device;

@end
