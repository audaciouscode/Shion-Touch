//
//  MobileDeviceLocationViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MobileDeviceLocationViewController.h"

#import "ApplicationModel.h"

#import "DictionaryAnnotation.h"

@implementation MobileDeviceLocationViewController

@synthesize device;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		otherDevices = [[NSMutableDictionary dictionary] retain];
	}
	
	return self;
}

- (void) dealloc
{
	[otherDevices release];
	
	[super dealloc];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	mapView.delegate = self;
	
	double min_lat = 90;
	double max_lat = -90;
	double min_lon = 180;
	double max_lon = -180;
	
	for (Device * d in [[ApplicationModel sharedModel] allDevices])
	{
		if ([d isKindOfClass:[MobileDevice class]])
		{
			MobileDevice * m = (MobileDevice *) d;
			
			double lat = [[m latitude] doubleValue];
			double lon = [[m longitude] doubleValue];
			
			if (fabs(lat) > 0.0001 && fabs(lon) > 0.0001)
			{
				if (lat < min_lat)
					min_lat = lat;
				
				if (lat > max_lat)
					max_lat = lat;
				
				if (lon < min_lon)
					min_lon = lon;
				
				if (lon > max_lon)
					max_lon = lon;
			
				DictionaryAnnotation * annotation = [DictionaryAnnotation dictionary];
				[annotation setValue:d forKey:@"device"];
					
				[otherDevices setValue:annotation forKey:[d identifier]];
			}
		}
	}
	
	CLLocationCoordinate2D user;
	user.latitude = min_lat + ((max_lat - min_lat) / 2);
	user.longitude = min_lon + ((max_lon - min_lon) / 2);
	
	for (DictionaryAnnotation * note in [otherDevices allValues])
	{
		if ([[[note valueForKey:@"device"] identifier] isEqual:[device identifier]])
			user = note.coordinate;

		[mapView addAnnotation:note];
	}

	mapView.showsUserLocation = YES;
	
	NSNumber * lat = [device latitude];
	NSNumber * lon = [device longitude];

	if (fabs(user.latitude) > 0.0001 && fabs(user.longitude) > 0.0001)
		user = mapView.userLocation.location.coordinate;
	
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	
	region.center = user;
	
	span.latitudeDelta = fabs((max_lat - min_lat) * 1.25);
	span.longitudeDelta = fabs((max_lon - min_lon) * 1.25);
	
	region.span = span;
	
	if (fabs([lat doubleValue]) > 0.0001 && fabs([lon doubleValue]) > 0.0001)
	{
		CLLocation * location = [[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lon doubleValue]];
		
		region.center = location.coordinate;

		[mapView setCenterCoordinate:location.coordinate animated:NO];
		
		[location release];
	}
	else
		[mapView setCenterCoordinate:user animated:NO];
	
	[mapView setRegion:region animated:NO];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:@"location_updated" object:device];
	
	self.navigationItem.title = @"Device Map";
}

- (void) selectDeviceAnnotation
{
	for (DictionaryAnnotation * note in [otherDevices allValues])
	{
		if ([[[note valueForKey:@"device"] identifier] isEqual:[device identifier]])
			[mapView selectAnnotation:note animated:YES];
	}
}

- (void) mapView:(MKMapView *) mv didAddAnnotationViews:(NSArray *) views
{
	[self performSelector:@selector(selectDeviceAnnotation) withObject:nil afterDelay:0.5];
}

- (void) locationUpdated:(NSNotification *) theNote
{
	for (DictionaryAnnotation * note in [otherDevices allValues])
	{
		[note willChangeValueForKey:@"coordinate"];
		[note didChangeValueForKey:@"coordinate"];
	}
	
	[mapView setCenterCoordinate:[self coordinate] animated:YES];
}

- (CLLocationCoordinate2D) coordinate
{
	NSNumber * lat = [device latitude];
	NSNumber * lon = [device longitude];

	CLLocationCoordinate2D coord = mapView.userLocation.location.coordinate;
	
	if (lat != nil && lon != nil)
	{
		coord.latitude = [lat doubleValue];
		coord.longitude = [lon doubleValue];
	}
	
	return coord;
}

- (NSString *) title
{
	return [device name];
}

- (NSString *) subtitle
{
	return [device model];
}

@end
