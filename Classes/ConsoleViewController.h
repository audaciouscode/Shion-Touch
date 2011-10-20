//
//  ConsoleViewController.h
//  Shion Touch
//
//  Created by Chris Karr on 4/30/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ConsoleViewController : UITableViewController 
{
	NSMutableArray * newsItems;
	NSMutableData * updateData;
}

@property(retain) NSMutableArray * newsItems;

@end
