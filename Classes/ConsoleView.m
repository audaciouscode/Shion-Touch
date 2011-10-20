//
//  ConsoleView.m
//  Shion Touch
//
//  Created by Chris Karr on 4/23/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "ConsoleView.h"

#import "ApplicationModel.h"
#import "XMPPManager.h"

@implementation ConsoleView

- (void) roundedRect:(CGRect) rect radius:(CGFloat) radius
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextBeginPath(context);
	
	CGContextMoveToPoint(context, rect.origin.x + radius, rect.origin.y);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, rect.origin.y);
	CGContextAddArcToPoint(context, rect.origin.x + rect.size.width, rect.origin.y, rect.origin.x + rect.size.width, rect.origin.y + radius, radius);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - radius);
	CGContextAddArcToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height, 
						   rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height, radius);
	CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y + rect.size.height);
	CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y + rect.size.height, 
						   rect.origin.x, rect.origin.y + rect.size.height  - radius, radius);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + radius);
	CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y, 
						   rect.origin.x + radius, rect.origin.y, radius);
	
	CGContextClosePath(context);
	
	CGContextDrawPath(context, kCGPathFillStroke);
}

- (void) didMoveToWindow
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"model_updated" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"xmpp_updated" object:nil];
	
	[super didMoveToWindow];
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"model_updated" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"xmpp_updated" object:nil];

	[super dealloc];
}

- (CGRect) drawVisibleNodes:(CGRect) rect
{
	NSArray * sites = [[ApplicationModel sharedModel] connectedSites];
	
	if ([sites count] > 0)
	{
		CGFloat top = rect.origin.y + 5;
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		UIFont * labelFont = [UIFont fontWithName:@"Helvetica" size:13];
		
		for (Site * site in sites)
		{
			CGSize labelSize = [[site name] sizeWithFont:labelFont];
			
			UIFont * descFont = [UIFont fontWithName:@"Helvetica" size:12];
			
			CGSize descSize = [[site networkDescription] sizeWithFont:descFont];
			
			CGFloat labelHeight = labelSize.height + descSize.height;
			
			top += labelHeight + 10;
		}
		
		top -= 5;
		
		CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);
		CGContextSetLineWidth(context, 2);
		CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
		
		CGRect rounded = CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5, rect.size.width, top - rect.origin.y);
		
		[self roundedRect:rounded radius:5];
		
		CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
		
		top = rect.origin.y + 5;
		
		for (Site * site in sites)
		{
			UIImage * image = [site siteImage];
			CGSize imageSize = image.size;
			
			CGRect imageRect = CGRectMake(rect.origin.x + 7.5, top + 0.5, imageSize.width, imageSize.height);
			
			[[site name] drawAtPoint:CGPointMake(imageRect.origin.x + imageRect.size.width + 10, top) withFont:labelFont];
			
			CGSize labelSize = [[site deviceCountDescription] sizeWithFont:labelFont];
			[[site deviceCountDescription] drawAtPoint:CGPointMake(rect.origin.x + rect.size.width - 10 - labelSize.width, top) withFont:labelFont];
			
			UIFont * descFont = [UIFont fontWithName:@"Helvetica" size:12];
			
			CGSize descSize = [[site networkDescription] sizeWithFont:descFont];
			[[site networkDescription] drawAtPoint:CGPointMake(imageRect.origin.x + imageRect.size.width + 10, top + labelSize.height) withFont:descFont];
			
			CGFloat labelHeight = labelSize.height + descSize.height;
			
			imageRect.origin.y += 3;
			
			[image drawInRect:imageRect];
			
			top += labelHeight + 10;
		}
		
		return rounded;
	}
	
	return CGRectMake(rect.origin.x, rect.origin.y, 0, 0);
}

- (CGRect) drawConnectionStatus:(CGRect) rect
{
	CGFloat top = rect.origin.y + 5;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIFont * labelFont = [UIFont fontWithName:@"Helvetica" size:13];
	
	NSString * status = [XMPPManager sharedManager].connectionStatus;
	
	CGSize size = [status sizeWithFont:labelFont];
	
	top += size.height;
	
	top += 5;
	
	CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);
	CGContextSetLineWidth(context, 2);
	
	CGRect rounded = CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5, rect.size.width, top - rect.origin.y);
	
	if ([XMPPManager sharedManager].connected)
		CGContextSetRGBFillColor(context, 0.0, 0.50, 0.0, 1.0);
	else
		CGContextSetRGBFillColor(context, 0.50, 0.0, 0.0, 1.0);
	
	[self roundedRect:rounded radius:5];
	
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	
	[status drawAtPoint:CGPointMake(rect.origin.x + 8, rect.origin.y + 6) withFont:labelFont];
	
	return rounded;
}

- (void) reload:(NSNotification *) theNote
{
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect 
{
	rect = self.bounds;
	
	[[UIColor blackColor] set];
	UIRectFill(rect);
	
	rect.origin.x += 10.5;
	rect.origin.y += 10.5;
	
	rect.size.height -= 20;
	rect.size.width -= 20;
	
	CGRect drawn = [self drawConnectionStatus:rect];
	
	rect.origin.y = rect.origin.y + drawn.size.height + 10;
	rect.size.height = rect.size.height - drawn.size.height - 10;
	
	[self drawVisibleNodes:rect];
	
	// [self drawSitesStatus:rect];
}

@end
