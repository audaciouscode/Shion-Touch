//
//  TivoShowViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TivoShowViewController.h"


@implementation TivoShowViewController

@synthesize show;

- (void)viewWillAppear:(BOOL)animated
{
	self.navigationItem.title = @"Details";

	[super viewWillAppear:animated];
	
	UIFont * font = showTitle.font;
	NSString * string = [show valueForKey:@"title"];
	
	CGRect frame = showTitle.frame;
	frame.origin.y = 10;
	frame.origin.x = 10;
	
	CGSize titleSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(frame.size.width, 90) lineBreakMode:UILineBreakModeWordWrap];
	
	CGSize lineSize = [@"Yep" sizeWithFont:font];
	NSUInteger lines = titleSize.height / lineSize.height;
	
	if (lines > 2)
		lines = 2;

	frame.size.height = lineSize.height * lines;
	
	showTitle.frame = frame;
	showTitle.numberOfLines = lines;
	showTitle.lineBreakMode = UILineBreakModeWordWrap;
	showTitle.text = string;
	
	CGFloat top = showTitle.frame.origin.y + showTitle.frame.size.height;

	NSDate * recordedDate = [show valueForKey:@"recorded"];
	
	if (recordedDate != nil)
	{
		NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"M/d/yyyy h:mm a"];
		
		NSString * recordedString = [NSString stringWithFormat:@"Recorded: %@", [formatter stringFromDate:recordedDate]];
		
		[formatter release];
		
		NSString * duration = [show valueForKey:@"duration"];
		
		if (duration != nil && ![duration isEqual:@""])
			recordedString = [NSString stringWithFormat:@"%@\nDuration: %@ min.", recordedString, duration]; 

		NSString * station = [show valueForKey:@"station"];
		
		if (station != nil && ![station isEqual:@""])
			recordedString = [NSString stringWithFormat:@"%@\nChannel: %@", recordedString, station]; 
		
		font = recorded.font;
		
		CGRect frame = recorded.frame;
		frame.origin.y = top + 8;
		frame.origin.x = 10;
		
		CGSize size = [recordedString sizeWithFont:font constrainedToSize:CGSizeMake(frame.size.width, 90) lineBreakMode:UILineBreakModeWordWrap];
		
		lineSize = [@"Yep" sizeWithFont:font];
		lines = size.height / lineSize.height;
		
		if (lines > 2)
			lines = 2;
		
		frame.size.height = lineSize.height * lines;
		
		recorded.frame = frame;
		recorded.numberOfLines = lines;
		recorded.lineBreakMode = UILineBreakModeWordWrap;
		recorded.text = recordedString;
		
		top = recorded.frame.origin.y + recorded.frame.size.height;
		
		recorded.hidden = NO;
	}
	else
		recorded.hidden = YES;
	
	NSString * episodeString = [show valueForKey:@"episode"];
	
	if (episodeString != nil && ![episodeString isEqual:@""])
	{
		font = episode.font;
		
		CGRect frame = episode.frame;
		frame.origin.y = top + 16;
		frame.origin.x = 10;
		
		CGSize size = [episodeString sizeWithFont:font constrainedToSize:CGSizeMake(frame.size.width, 90) lineBreakMode:UILineBreakModeWordWrap];
		
		lineSize = [@"Yep" sizeWithFont:font];
		lines = size.height / lineSize.height;
		
		if (lines > 2)
			lines = 2;
		
		frame.size.height = lineSize.height * lines;
		
		episode.frame = frame;
		episode.numberOfLines = lines;
		episode.lineBreakMode = UILineBreakModeWordWrap;
		episode.text = episodeString;
		
		top = episode.frame.origin.y + episode.frame.size.height;
		
		episode.hidden = NO;
	}
	else
		episode.hidden = YES;

	NSString * synopsisString = [show valueForKey:@"synopsis"];

	if (synopsisString == nil || [synopsisString isEqual:@""])
		synopsisString = @"(No synopsis available.)";
	
	synopsisString = [synopsisString stringByReplacingOccurrencesOfString:@". Copyright" withString:@".\nCopyright"];

	NSString * rating = [show valueForKey:@"rating"];
	
	if (rating != nil && ![rating isEqual:@""])
		synopsisString = [NSString stringWithFormat:@"%@\n\n%@", synopsisString, rating]; 

	font = synopsis.font;
		
	frame = synopsis.frame;
	frame.origin.y = top + 8;
	frame.origin.x = 10;
		
	CGSize size = [synopsisString sizeWithFont:font constrainedToSize:CGSizeMake(frame.size.width, 180) lineBreakMode:UILineBreakModeWordWrap];
		
	lineSize = [@"Yep" sizeWithFont:font];
	lines = size.height / lineSize.height;
		
	frame.size.height = lineSize.height * lines;
		
	synopsis.frame = frame;
	synopsis.numberOfLines = lines;
	synopsis.lineBreakMode = UILineBreakModeWordWrap;
	synopsis.text = synopsisString;
		
	top = synopsis.frame.origin.y + synopsis.frame.size.height;
}

@end
