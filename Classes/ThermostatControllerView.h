//
//  ThermostatControllerView.h
//  Shion Touch
//
//  Created by Chris Karr on 4/26/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DeviceControllerView.h"
#import "Thermostat.h"

@interface ThermostatControllerView : DeviceControllerView
{
	UIButton * heatButton;
	UIButton * coolButton;
	UIButton * modeButton;
	UIButton * fanButton;
}

@end
