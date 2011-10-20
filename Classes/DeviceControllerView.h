//
//  DeviceControllerView.h
//  Shion Touch
//
//  Created by Chris Karr on 4/26/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"

@interface DeviceControllerView : UIView 
{
	IBOutlet UIViewController * parentController;
	Device * device;
}

@property(assign) Device * device;

- (CGSize) fullSize;
- (CGRect) mutableArea;

- (void) show:(BOOL) animate;
- (void) hide:(BOOL) animate;

@end
