//
//  SnapshotViewController.h
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Snapshot.h"

@interface SnapshotViewController : UIViewController 
{
	Snapshot * snapshot;
}

@property(retain) Snapshot * snapshot;

@end
