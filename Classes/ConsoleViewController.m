//
//  ConsoleViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 4/30/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "ConsoleViewController.h"
#import "XMPPManager.h"
#import "LocationManager.h"

#import "ApplicationModel.h"
#import "FullSiteViewController.h"
#import "WebViewController.h"
#import "OnlineViewController.h"
#import "SettingsViewController.h"

#import "DDXML.h"

@implementation ConsoleViewController

@synthesize newsItems;

#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated 
{
	if (self.newsItems == nil)
		self.newsItems = [NSMutableArray array];
		
	self.navigationItem.title = @"Shion Touch";
	self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cloth.png"]]; // [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0];
	self.view.backgroundColor = [UIColor clearColor];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"model_updated" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"xmpp_updated" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchCredentials:) name:@"fetch_credentials" object:nil];

	if ([self.newsItems count] == 0)
	{
		updateData = [[NSMutableData alloc] init];
		
		NSURLConnection * connection = [[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://feeds.feedburner.com/ShionOnline"]] delegate:self] retain];
		[connection start];

		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}
	else
	{
		UITableView * tv = (UITableView *) self.view;
		
		NSUInteger indexes[2];
		indexes[0] = 0;
		indexes[1] = 0;
		
		[tv scrollToRowAtIndexPath:[NSIndexPath indexPathWithIndexes:indexes length:2] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}

	[LocationManager sharedManager];
	
	[super viewWillAppear:animated];
}

- (void) connection:(NSURLConnection *) connection didFailWithError:(NSError *) error
{
	NSMutableDictionary * newsDict = [NSMutableDictionary dictionary];
	
	[newsDict setValue:@"Unable to fetch updates" forKey:@"title"];
	[newsDict setValue:@"Please check your network connection." forKey:@"error"];
	
	[self.newsItems addObject:newsDict];

	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) connection:(NSURLConnection *) connection didReceiveData:(NSData *) data
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	[updateData appendData:data];
}

- (NSURLRequest *) connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *) request redirectResponse:(NSURLResponse *) redirectResponse
{
	return request;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZ"];

	NSError * error = nil;
		
	DDXMLDocument * document = [[DDXMLDocument alloc] initWithData:updateData options:0 error:&error];
		
	if (error == nil)
	{
		DDXMLElement * root = [document rootElement];
			
		NSArray * news = [root nodesForXPath:@"/rss/channel/item" error:&error];
			
		if (error == nil)
		{
			int i = 0;
			
			for (DDXMLElement * item in news)
			{
				if (i < 3)
				{
					NSMutableDictionary * newsDict = [NSMutableDictionary dictionary];
					
					NSArray * titles = [item elementsForName:@"title"]; 
					[newsDict setValue:[[titles lastObject] stringValue] forKey:@"title"];
					
					NSArray * dates = [item elementsForName:@"pubDate"]; 

					if ([dates count] > 0)
					{
						NSDate * date = [formatter dateFromString:[[dates lastObject] stringValue]];
						
						if (date)
							[newsDict setValue:date forKey:@"date"];
					}

					NSArray * links = [item elementsForName:@"link"]; 
					[newsDict setValue:[[links lastObject] stringValue] forKey:@"link"];

					[newsItems addObject:newsDict];
					
					i += 1;
				}
			}
		}
	}
		
	[document release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[formatter release];

	[self.tableView reloadData];
	
	[connection release];
}

#pragma mark Table view methods

- (void) reload:(NSNotification *) theNote
{
	[self.tableView reloadData];
}

- (void) fetchCredentials:(NSNotification *) theNote
{
	if (![[self.navigationController topViewController] isKindOfClass:[OnlineViewController class]])
	{
		OnlineViewController * onlineView = [[OnlineViewController alloc] initWithNibName:@"OnlineViewController" bundle:nil];
	
		[self.navigationController pushViewController:onlineView animated:YES];
	
		[onlineView release];
	}
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (section == 0)
		return 1;
	else if (section == 1)
	{
		NSArray * sites = [[ApplicationModel sharedModel] connectedSites];

		if ([sites count] < 1)
			return 2;
		else
			return [sites count] + 1;
	}
	else if (section == 2) // News
	{
		if ([newsItems count] < 1)
			return 2;
		else
			return [newsItems count] + 1;
	}
	else
		return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger index = [indexPath indexAtPosition:0];

	if (index > 0 && index < 3)
	{
		NSUInteger subIndex = [indexPath indexAtPosition:1];
		
		if (subIndex == 0)
			return tableView.rowHeight / 2; // 36;
	}
	
	return tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	XMPPManager * xmppManager = [XMPPManager sharedManager];
	
	NSUInteger index = [indexPath indexAtPosition:0];

    UITableViewCell * cell = nil;
	
	if (index == 0) 
	{
		cell = [tableView dequeueReusableCellWithIdentifier:@"ConsoleCellStatus"];
		
		if (cell == nil) 
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ConsoleCellStatus"] autorelease];
			cell.textLabel.backgroundColor = [UIColor clearColor];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
	}
	else if (index == 1)
	{
		NSUInteger subIndex = [indexPath indexAtPosition:1];

		if (subIndex == 0)
		{			
			cell = [tableView dequeueReusableCellWithIdentifier:@"ConsoleCellSitesTitle"];
			
			if (cell == nil) 
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ConsoleCellSitesTitle"] autorelease];
				cell.textLabel.backgroundColor = [UIColor clearColor];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
		}
		else
		{			
			cell = [tableView dequeueReusableCellWithIdentifier:@"ConsoleCellSitesSubtitle"];
			
			if (cell == nil) 
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ConsoleCellSitesSubtitle"] autorelease];
				cell.textLabel.backgroundColor = [UIColor clearColor];
			}
		}
	}
	else if (index == 2) 
	{
		NSUInteger subIndex = [indexPath indexAtPosition:1];

		if (subIndex == 0)
		{			
			cell = [tableView dequeueReusableCellWithIdentifier:@"ConsoleCellServiceTitle"];
			
			if (cell == nil) 
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ConsoleCellServiceTitle"] autorelease];
				cell.textLabel.backgroundColor = [UIColor clearColor];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
		}
		else
		{			
			cell = [tableView dequeueReusableCellWithIdentifier:@"ConsoleCellServiceSubtitle"];
			
			if (cell == nil) 
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ConsoleCellSitesSubtitle"] autorelease];
				cell.textLabel.backgroundColor = [UIColor clearColor];
			}
		}
	}
	else if (index == 3) 
	{
		cell = [tableView dequeueReusableCellWithIdentifier:@"ConsoleCellSettings"];
		
		if (cell == nil) 
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ConsoleCellSettings"] autorelease];
			cell.textLabel.backgroundColor = [UIColor clearColor];
		}
	}
	
	if (index == 0)
	{
		cell.textLabel.text = xmppManager.connectionStatus;
		cell.textLabel.textColor = [UIColor whiteColor];
		
		if (xmppManager.connected)
			cell.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
		else
			cell.backgroundColor = [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];

		cell.imageView.image = nil;
	}
	else if (index == 1)
	{
		NSUInteger subIndex = [indexPath indexAtPosition:1];

		cell.accessoryType = UITableViewCellAccessoryNone;

		if (subIndex == 0)
		{
			cell.textLabel.text = @"Connected Sites";
			cell.backgroundColor = [UIColor lightGrayColor];
		}
		else
		{
			NSArray * sites = [[ApplicationModel sharedModel] connectedSites];

			if ([sites count] == 0)
			{
				cell.textLabel.text = @"None";
				cell.detailTextLabel.text = @"No sites connected.";
				cell.imageView.image = [UIImage imageNamed:@"console_no_sites.png"];
			}
			else
			{
				Site * site = [sites objectAtIndex:([indexPath indexAtPosition:1] - 1)];
				cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", [site name], [site deviceCountDescription]];
				cell.detailTextLabel.text = [site networkDescription];
			
				cell.imageView.image = [site siteImage];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
		}
	}
	else if (index == 2)
	{
		cell.accessoryType = UITableViewCellAccessoryNone;

		NSUInteger subIndex = [indexPath indexAtPosition:1];
		
		if (subIndex == 0)
		{
			cell.textLabel.text = @"Shion Online";
			cell.backgroundColor = [UIColor lightGrayColor];
			cell.imageView.image = nil;
		}
		else
		{
			if ([newsItems count] < 1)
			{
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.textLabel.text = @"Connecting to Shion Online";
				cell.detailTextLabel.text = @"Fetching the latest service updates...";
				cell.backgroundColor = [UIColor whiteColor];
				cell.imageView.image = [UIImage imageNamed:@"fetching_news.png"];
			}
			else
			{
				NSDictionary * newsDict = [newsItems objectAtIndex:(subIndex - 1)];
				
				cell.textLabel.text = [newsDict valueForKey:@"title"];

				if ([newsDict valueForKey:@"link"] != nil)
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				else
				{
					cell.accessoryType = UITableViewCellAccessoryNone;
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
				}

				if ([newsDict valueForKey:@"date"] != nil)
				{
					NSCalendar * calendar = [NSCalendar currentCalendar];
					
					NSDate * date = [newsDict valueForKey:@"date"];
					NSDate * now = [NSDate date];
					
					NSDateComponents * dateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
					NSDateComponents * nowComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:now];

					if ([dateComponents isEqual:nowComponents])
					{
						NSTimeInterval interval = [now timeIntervalSince1970] - [date timeIntervalSince1970];
						
						int hours = (int) interval / (60 * 60);
						int minutes = (int) (interval - (hours * 60 * 60)) / 60;
						
						if (hours > 0)
							cell.detailTextLabel.text = [NSString stringWithFormat:@"%d hours, %d minutes ago", hours, minutes];
						else
							cell.detailTextLabel.text = [NSString stringWithFormat:@"%d minutes ago", minutes];
					}
					else
					{
						NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
						[formatter setDateFormat:@"MMMM d, yyyy"];

						cell.detailTextLabel.text = [formatter stringFromDate:date];
						
						[formatter release];
					}
				}
				else if ([newsDict valueForKey:@"error"] != nil)
					cell.detailTextLabel.text = [newsDict valueForKey:@"error"];

				cell.backgroundColor = [UIColor whiteColor];
				cell.imageView.image = [UIImage imageNamed:@"news_item.png"];
			}
		}
	}
	else if (index == 3)
	{
		cell.textLabel.text = @"Preferences & Settings";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.backgroundColor = [UIColor whiteColor];
		cell.imageView.image = [UIImage imageNamed:@"settings.png"];
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSUInteger index = [indexPath indexAtPosition:0];

	if (index == 0)
	{
		NSLog(@"TODO: Show Connection Options");
	}
	else if (index == 1)
	{
		NSUInteger subIndex = [indexPath indexAtPosition:1];
		
		if (subIndex > 0)
		{
			NSArray * sites = [[ApplicationModel sharedModel] connectedSites];
			
			if ([sites count] > 0)
			{
				FullSiteViewController * siteView = [[FullSiteViewController alloc] initWithNibName:@"FullSiteViewController" bundle:nil];
				
				siteView.site = [[sites objectAtIndex:(subIndex - 1)] name];
				
				[self.navigationController pushViewController:siteView animated:YES];
				
				[siteView release];
			}
		}
	}		
	else if (index == 2)
	{
		NSUInteger subIndex = [indexPath indexAtPosition:1];
		
		if (subIndex > 0 && [newsItems count] > 0)
		{
			NSDictionary * newsItem = [newsItems objectAtIndex:(subIndex - 1)];

			if ([newsItem valueForKey:@"link"])
			{
				WebViewController * webView = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
				webView.navigationItem.title = [newsItem valueForKey:@"title"];
				webView.urlString = [newsItem valueForKey:@"link"];
				
				[self.navigationController pushViewController:webView animated:YES];
				
				[webView release];
			}
		}
	}		
	else if (index == 3)
	{
		SettingsViewController * settingsView = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
		
		[self.navigationController pushViewController:settingsView animated:YES];
		
		[settingsView release];
	}
}


@end

