//
//  ThermostatCoolPointViewController.h
//  Shion Touch
//
//  Created by Chris Karr on 3/1/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Thermostat.h"

@interface ThermostatCoolPointViewController : UIViewController 
{
	IBOutlet UIPickerView * picker;
	IBOutlet UILabel * currentPoint;
	
	Thermostat * thermostat;
}

@property(assign) Thermostat * thermostat;

@end
