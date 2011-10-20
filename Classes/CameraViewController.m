//
//  CameraViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 9/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"
#import "CameraPhotoSource.h"
#import "CameraThumbsViewController.h"

@implementation CameraViewController

@synthesize device;

- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = [self.device name];
	
	NSString * imageName = @"star-small.png";
	
	if ([device favorite])
		imageName = @"star-small-yellow.png";
	
	UIBarButtonItem * favoriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
																		style:UIBarButtonItemStyleBordered 
																	   target:self
																	   action:@selector(favorite:)];
	self.navigationItem.rightBarButtonItem = favoriteButton;
	
	[favoriteButton release];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"view_refresh" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"model_updated" object:nil];

	[super viewWillAppear:animated];
}

- (void) refresh:(NSNotification *) theNote
{
	[self invalidateModel];
	[self invalidateView];
}

- (void) favorite:(id) sender
{
	NSString * imageName = @"star-small-yellow.png";
	
	if ([device favorite])
		imageName = @"star-small.png";
	
	
	UIBarButtonItem * favoriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
																		style:UIBarButtonItemStyleBordered 
																	   target:self
																	   action:@selector(favorite:)];
	
	self.navigationItem.rightBarButtonItem = favoriteButton;
	
	[favoriteButton release];
	
	[device setFavorite:([device favorite] == NO)];
}

- (void) viewWillDisappear:(BOOL)animated
{
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;

	[[TTURLCache sharedCache] invalidateAll];

	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"view_refresh" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"model_updated" object:nil];
	
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad 
{
	self.view.backgroundColor = [UIColor blackColor];

	CameraPhotoSource * source = [[CameraPhotoSource alloc] initWithCamera:self.device];

	[source addObserver:self forKeyPath:@"photos" options:0 context:NULL];
	
	self.photoSource = source;
	self.photoSource.title = [self.device name];
	
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	[self reload];
	[self invalidateView];
}

- (TTThumbsViewController*) createThumbsViewController 
{
	return [[[CameraThumbsViewController alloc] initWithDelegate:self] autorelease];
}

- (IBAction) captureImage:(id) sender
{
	[device captureImage];
}

- (void)loadView 
{
	[super loadView];

	CGRect screenFrame = [UIScreen mainScreen].bounds;

	[_toolbar removeFromSuperview];
	
	UIBarItem * space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
						  UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	
	_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, screenFrame.size.height - TT_ROW_HEIGHT, screenFrame.size.width, TT_ROW_HEIGHT)];
	
	
	if (self.navigationBarStyle == UIBarStyleDefault) 
		_toolbar.tintColor = TTSTYLEVAR(toolbarTintColor);
	
	captureButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toolbar_camera.png"] style:UIBarButtonItemStylePlain target:self action:@selector(captureImage:)];
	allButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"all_photos_toolbar.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showThumbnails)];
	
	_toolbar.barStyle = self.navigationBarStyle;
	_toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
	_toolbar.items = [NSArray arrayWithObjects: space, _previousButton, space, captureButton, space, allButton, space, _nextButton, space, nil];
	[_innerView addSubview:_toolbar];
}

- (void)updateChrome 
{
	if (_photoSource.numberOfPhotos < 2) 
		self.title = _photoSource.title;
	else
		self.title = [NSString stringWithFormat:TTLocalizedString(@"%d of %d", @"Current page in photo browser (1 of 10)"),
					  _centerPhotoIndex+1, _photoSource.numberOfPhotos];
	
/*	if (![self.ttPreviousViewController isKindOfClass:[TTThumbsViewController class]]) 
	{
		if (_photoSource.numberOfPhotos > 1) 
		{
			self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
													  initWithTitle:TTLocalizedString(@"See All", @"See all photo thumbnails")
													  style:UIBarButtonItemStyleBordered target:self action:@selector(showThumbnails)];
		} 
		else 
		{
			self.navigationItem.rightBarButtonItem = nil;
		}
	} 
	else 
	{
		self.navigationItem.rightBarButtonItem = nil;
	} */
}

- (void)showEmpty:(BOOL)show 
{
	if (show) 
	{
		[_scrollView reloadData];
//		[self showStatus:NSLocalizedString(@"Loading photos... ", nil)];
	} 
	else 
	{
//		[self showStatus:nil];
	}
}


@end
