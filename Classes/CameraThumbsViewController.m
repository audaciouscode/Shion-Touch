//
//  CameraThumbsViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CameraThumbsViewController.h"


@implementation CameraThumbsViewController

- (void) viewWillAppear:(BOOL) animated
{
	[super viewWillAppear:animated];

	NSString * title = @"1 Photo";
	
	if (self.photoSource.numberOfPhotos != 1)
		title = [NSString stringWithFormat:@"%d Photos", self.photoSource.numberOfPhotos];
	
	self.navigationItem.title = title;

	self.tableView.backgroundColor = [UIColor clearColor];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cloth.png"]];
}

@end
