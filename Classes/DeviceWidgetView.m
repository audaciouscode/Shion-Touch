//
//  DeviceWidgetView.m
//  Shion Touch
//
//  Created by Chris Karr on 3/3/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "DeviceWidgetView.h"


@implementation DeviceWidgetView

@synthesize device;

- (void) refresh
{
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect 
{
	rect = self.bounds;
	
	[[UIColor blackColor] set];
	UIRectFill(rect);
}

- (void)dealloc 
{
    [super dealloc];
}


@end
