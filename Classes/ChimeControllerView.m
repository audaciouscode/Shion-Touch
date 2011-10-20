//
//  ChimeControllerView.m
//  Shion Touch
//
//  Created by Chris Karr on 4/29/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "ChimeControllerView.h"
#import "Chime.h"

@implementation ChimeControllerView

- (void) willMoveToWindow:(UIWindow *) newWindow
{
	if ([device isKindOfClass:[Chime class]])
	{
		CGRect area = [self mutableArea];
		
		CGFloat bottom = area.origin.y + area.size.height;
		
		UIButton * ringButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[ringButton setFrame:CGRectMake(20, bottom - 37 - 20, 280, 37)];
		[ringButton setTitle:@"Ring Chime" forState:UIControlStateNormal];
		[self addSubview:ringButton];
		
		[ringButton addTarget:parentController action:@selector(ring:) forControlEvents:UIControlEventTouchUpInside];
	}
}

- (CGSize) fullSize
{
	CGSize size = self.frame.size;
	size.height = 20 + 37 + 20;
	
	return size;
}

@end
