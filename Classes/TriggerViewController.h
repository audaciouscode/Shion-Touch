//
//  TriggerViewController.h
//  Shion Touch
//
//  Created by Chris Karr on 7/4/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Trigger.h"

@interface TriggerViewController : UITableViewController 
{
	Trigger * trigger;
}

@property(retain) Trigger * trigger;

@end
