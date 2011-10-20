//
//  MobileDeviceLocationViewController.h
//  Shion Touch
//
//  Created by Chris Karr on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "MobileDevice.h"

@interface MobileDeviceLocationViewController : UIViewController <MKAnnotation, MKMapViewDelegate>
{
	IBOutlet MKMapView * mapView;
	MobileDevice * device;
	
	NSMutableDictionary * otherDevices;
}

@property(retain) MobileDevice * device;

@end
