//
//  ThermostatViewController.h
//  Shion Touch
//
//  Created by Chris Karr on 3/1/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceViewController.h"

@interface ThermostatViewController : DeviceViewController
{

}

- (IBAction) promptForMode:(id) sender;
- (IBAction) toggleFan:(id) sender;
- (IBAction) promptForCoolPoint:(id) sender;
- (IBAction) promptForHeatPoint:(id) sender;

@end
