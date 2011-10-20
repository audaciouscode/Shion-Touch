//
//  ThermostatFanModeViewController.h
//  Shion Touch
//
//  Created by Chris Karr on 3/3/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Thermostat.h"

@interface ThermostatFanModeViewController : UIViewController 
{
	Thermostat * thermostat;
	
	IBOutlet UITableView * table;
	NSArray * options;
}

@property(assign) Thermostat * thermostat;

@end
