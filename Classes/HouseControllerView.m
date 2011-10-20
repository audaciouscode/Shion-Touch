//
//  HouseControllerView.m
//  Shion Touch
//
//  Created by Chris Karr on 4/29/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "HouseControllerView.h"
#import "House.h"

@implementation HouseControllerView

- (void) willMoveToWindow:(UIWindow *) newWindow
{
	if ([device isKindOfClass:[House class]])
	{
		CGRect area = [self mutableArea];
		
		CGFloat bottom = area.origin.y + area.size.height;
		
		UIButton * allOnButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[allOnButton setFrame:CGRectMake(20, bottom - 37 - 20, 280, 37)];
		[allOnButton setTitle:@"All Units Off" forState:UIControlStateNormal];
		[self addSubview:allOnButton];

		UIButton * lightsOnButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[lightsOnButton setFrame:CGRectMake(20, bottom - 37 - 20 - 37 - 10, 280, 37)];
		[lightsOnButton setTitle:@"All Lights On" forState:UIControlStateNormal];
		[self addSubview:lightsOnButton];

		UIButton * lightsOffButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[lightsOffButton setFrame:CGRectMake(20, bottom - 37 - 20 - 37 - 10 - 37 - 10, 280, 37)];
		[lightsOffButton setTitle:@"All Lights Off" forState:UIControlStateNormal];
		[self addSubview:lightsOffButton];

		[allOnButton addTarget:parentController action:@selector(allOff:) forControlEvents:UIControlEventTouchUpInside];
		[lightsOnButton addTarget:parentController action:@selector(lightsOn:) forControlEvents:UIControlEventTouchUpInside];
		[lightsOffButton addTarget:parentController action:@selector(lightsOff:) forControlEvents:UIControlEventTouchUpInside];
	}
}

- (CGSize) fullSize
{
	CGSize size = self.frame.size;
	size.height = 20 + 37 + 10 + 23 + 10 + 37 + 20;
	
	return size;
}

@end
