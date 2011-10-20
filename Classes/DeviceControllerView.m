//
//  DeviceControllerView.m
//  Shion Touch
//
//  Created by Chris Karr on 4/26/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "DeviceControllerView.h"
#import "DeviceViewController.h"

#define BIG_RADIUS 10
#define SMALL_RADIUS 5

#define TAB_HEIGHT 55
#define TAB_WIDTH 260

@implementation DeviceControllerView

@synthesize device;

- (void) refresh
{
	[self setNeedsDisplay];
}

- (CGSize) fullSize
{
	CGSize size = self.frame.size;
	size.height = size.height / 2;
	
	return size;
}

- (CGRect) mutableArea
{
	CGRect area = self.bounds;
	
	area.size.height -= TAB_HEIGHT;
	
	return area;
}

/* - (void) didMoveToWindow
{
	CGRect frame = self.frame;
	
	frame.origin.y = TAB_HEIGHT - frame.size.height;
	
	if ([parentController isKindOfClass:[DeviceViewController class]])
	{
		DeviceViewController * deviceController = (DeviceViewController *) parentController;
		
		if (deviceController.controlsVisible)
			frame.origin.y = ([self fullSize].height + TAB_HEIGHT) - frame.size.height;
	}
	
	[self setFrame:frame];
} */

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
	UITouch * touch = [touches anyObject];
	
	if ([touch view] == self) 
	{
		CGPoint location = [touch locationInView:self];
		
		if (location.y > self.bounds.origin.y + self.bounds.size.height - TAB_HEIGHT)
		{
			CGPoint superPoint = [self convertPoint:location toView:self.superview];
			
			CGRect selfFrame = self.frame;
			
			if (superPoint.y > TAB_HEIGHT && superPoint.y < self.superview.bounds.origin.y + [self fullSize].height + TAB_HEIGHT)
			{
				selfFrame.origin.y = superPoint.y - self.frame.size.height;
				
				self.frame = selfFrame;
			}
		}
	}
}

- (void) show:(BOOL) animate
{
	if (animate)
		[UIView beginAnimations:[[self class] description] context:NULL];

	CGRect frame = self.frame;
	frame.origin.y = ([self fullSize].height + TAB_HEIGHT) - frame.size.height;
	self.frame = frame;
	
	if (animate)
		[UIView commitAnimations];
	
	if ([parentController isKindOfClass:[DeviceViewController class]])
	{
		DeviceViewController * deviceController = (DeviceViewController *) parentController;
		
		deviceController.controlsVisible = YES;
	}		
}

- (void) hide:(BOOL) animate
{
	if (animate)
		[UIView beginAnimations:[[self class] description] context:NULL];

	CGRect frame = self.frame;
	frame.origin.y = TAB_HEIGHT - frame.size.height;
	self.frame = frame;

	if (animate)
		[UIView commitAnimations];
	
	if ([parentController isKindOfClass:[DeviceViewController class]])
	{
		DeviceViewController * deviceController = (DeviceViewController *) parentController;

		deviceController.controlsVisible = NO;
	}		
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	UITouch *touch = [touches anyObject];
	
	if ([touch view] == self) 
	{
		CGPoint location = [touch locationInView:self];

		if (location.y > self.bounds.origin.y + self.bounds.size.height - TAB_HEIGHT)
		{
			CGPoint superPoint = [self convertPoint:location toView:self.superview];
			
			if (superPoint.y > TAB_HEIGHT && superPoint.y < self.superview.bounds.origin.y + [self fullSize].height + TAB_HEIGHT)
			{
				if (superPoint.y < TAB_HEIGHT * 2)
					[self hide:YES];
				else
					[self show:YES];
			}
		}
		else
			[self hide:YES];
	}
}

- (void)drawRect:(CGRect)rect 
{
	rect = [self bounds];
	
	rect.size.width -= 4;
	rect.origin.x += 2;
	
	rect.origin.y -= 2;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetRGBStrokeColor(context, 0.25, 0.25, 0.25, 1.0);
	CGContextSetLineWidth(context, 2);
	CGContextSetRGBFillColor(context, 0.10, 0.10, 0.10, 0.90);
	
	CGContextBeginPath(context);
	
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y - BIG_RADIUS);
	
	CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y + rect.size.height, rect.origin.x + BIG_RADIUS, rect.origin.y + rect.size.height, BIG_RADIUS);
	CGContextAddLineToPoint(context, rect.origin.x + TAB_WIDTH - BIG_RADIUS, rect.origin.y + rect.size.height);
	
	CGContextAddArcToPoint(context, rect.origin.x + TAB_WIDTH, rect.origin.y+ rect.size.height, rect.origin.x + TAB_WIDTH, rect.origin.y + rect.size.height - BIG_RADIUS, BIG_RADIUS);
	CGContextAddLineToPoint(context, rect.origin.x + TAB_WIDTH, rect.origin.y + rect.size.height - TAB_HEIGHT + SMALL_RADIUS);
	
	CGContextAddArcToPoint(context, rect.origin.x + TAB_WIDTH, rect.origin.y + rect.size.height - TAB_HEIGHT, rect.origin.x + TAB_WIDTH + SMALL_RADIUS, rect.origin.y + rect.size.height - TAB_HEIGHT, SMALL_RADIUS);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - SMALL_RADIUS, rect.origin.y + rect.size.height - TAB_HEIGHT);
	CGContextAddArcToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - TAB_HEIGHT, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - TAB_HEIGHT - SMALL_RADIUS, SMALL_RADIUS);
	
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
	
	CGContextClosePath(context);
	
	CGContextDrawPath(context, kCGPathFillStroke);
	
	NSString * desc = [self.device shortDescription];
	
	UIFont * font = [UIFont fontWithName:@"Helvetica-Bold" size:32];
	
	CGSize size = [desc sizeWithFont:font];
	
	CGPoint point = CGPointMake(16, rect.origin.y + rect.size.height - 8 - size.height);
	
	[[UIColor whiteColor] setFill];
	
	[desc drawAtPoint:point withFont:font];
}

@end
