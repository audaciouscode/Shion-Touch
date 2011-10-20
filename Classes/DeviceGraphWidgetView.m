//
//  DeviceGraphWidgetView.m
//  Shion Touch
//
//  Created by Chris Karr on 3/3/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "DeviceGraphWidgetView.h"
#import "PresenceTimeline.h"

#import "Lamp.h"
#import "Appliance.h"
#import "Thermostat.h"
#import "PowerMeterSensor.h"
#import "WeatherSensor.h"

@implementation DeviceGraphWidgetView

- (UIColor *) primaryColorForObject:(id) object
{
	return [UIColor grayColor];
}

- (void) setStrokeColor
{
	[[self.device color] setStroke];
}

- (void) setFillColorWithAlpha:(CGFloat) alpha
{
	[[[self.device color] colorWithAlphaComponent:alpha] setFill];
}

- (void) setFillColor
{
	[[self.device color] setFill];
}

- (void) setTextColor
{
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
}

- (NSRange) rangeForDevice:(Device *) drawingDevice
{
	if ([drawingDevice isKindOfClass:[Thermostat class]])
	{
		Thermostat * t = (Thermostat *) drawingDevice;
		
		float min = t.minTemp;
		float max = t.maxTemp;
		
		return NSMakeRange(min, max - min);
	}
	if ([drawingDevice isKindOfClass:[WeatherSensor class]])
	{
		WeatherSensor * t = (WeatherSensor *) drawingDevice;
		
		float min = t.minTemp;
		float max = t.maxTemp;
		
		return NSMakeRange(min, max - min);
	}
	else if ([drawingDevice isKindOfClass:[PowerMeterSensor class]])
	{
		PowerMeterSensor * t = (PowerMeterSensor *) drawingDevice;
		
		float min = t.minPower;
		float max = t.maxPower;
		
		return NSMakeRange(min, max - min);
	}
	
	return NSMakeRange(0, 255);
}

- (void) drawTimeline:(PresenceTimeline *) timeline start:(NSTimeInterval) start end:(NSTimeInterval) end inRect:(CGRect) rect object:(id) object
{
	CGContextRef context = UIGraphicsGetCurrentContext();

	float height = rect.size.height - 10;
	
	[self setFillColor];

	float daySeconds = 24 * 60 * 60;
	float secondsPerPixel = daySeconds / rect.size.width;
	
	NSRange range = [self rangeForDevice:object];
	
	int rectWidth = 0;
	int leftOffset = 0;
	int lastHeight = 0;
	
	NSMutableArray * rects = [NSMutableArray array];
	
	for (unsigned int i = 0; i < rect.size.width; i++)
	{
		float value = [timeline averageForStart:(start + (secondsPerPixel * i)) end:(start + (secondsPerPixel * (i + 1)))];
		
		float normalizedValue = (value - range.location) / range.length;

		if (normalizedValue > 1)
			normalizedValue = 1;
		else if (normalizedValue < 0)
			normalizedValue = 0;
		
		int currentHeight = (int) ceil(height * normalizedValue);

		if (i == (int) (rect.size.width - 1))
			currentHeight = 0;

		if (currentHeight != lastHeight)
		{
			[rects addObject:[NSValue valueWithCGRect:CGRectMake(leftOffset, 0, rectWidth, lastHeight)]];
				
			leftOffset += rectWidth;
			rectWidth = 0;

			lastHeight = currentHeight;
		}

		if (currentHeight == 0)
			leftOffset += 1;
		else
			rectWidth += 1;

		/* 
		
		if (normalizedValue > 0)
		{
			CGPoint line[2];
			line[0] = CGPointMake(rect.origin.x + i - 0.5, rect.origin.y + rect.size.height - 0.5);
			line[1] = CGPointMake(rect.origin.x + i - 0.5, rect.origin.y + rect.size.height - ceil(height * normalizedValue - 0.5));
			
			CGContextStrokeLineSegments(context, line, 2);
		} */
	}
	
	for (NSValue * value in rects)
	{
		CGRect r = [value CGRectValue];
		
		r.origin.x += rect.origin.x;
		r.origin.y = rect.origin.y + 10 + floor(height - r.size.height);

		CGContextFillRect(context, r);
	}

	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);

	CGPoint axes[4];
	axes[0] = CGPointMake(rect.origin.x - 0.5, rect.origin.y + 10);
	axes[1] = CGPointMake(rect.origin.x - 0.5, rect.origin.y + rect.size.height - 0.5);
	axes[2] = CGPointMake(rect.origin.x - 0.5, rect.origin.y + rect.size.height - 0.5);
	axes[3] = CGPointMake(rect.origin.x + rect.size.width - 1, rect.origin.y + rect.size.height - 0.5);

	CGContextStrokeLineSegments(context, axes, 4);
	
	float hourWidth = rect.size.width / 24;
	
	for (int i = 1; i < 24; i++)
	{
		CGPoint tick = CGPointMake(rect.origin.x - 0.5 + ceil(i * hourWidth), rect.origin.y  + rect.size.height - 0.5);
		
		float tickLength = 2;
		
		if (i % 6 == 0)
			tickLength = 6;
		else if (i % 3 == 0)
			tickLength = 4;

		CGPoint line[2];
		line[0] = CGPointMake(tick.x, tick.y);
		line[1] = CGPointMake(tick.x, tick.y + tickLength + 0.5);
		
		CGContextStrokeLineSegments(context, line, 2);
	}
}

- (void) drawTimeline:(PresenceTimeline *) timeline start:(NSTimeInterval) start end:(NSTimeInterval) end inRect:(CGRect) rect
{
	[self drawTimeline:timeline start:start end:end inRect:rect object:self.device];
}

- (void) drawChartForEvents:(NSArray *) events days:(int) days
{
	if (timelineCache == nil)
		timelineCache = [[NSMutableDictionary dictionary] retain];

	NSMutableArray * chartEvents = [NSMutableArray array]; // [NSMutableArray arrayWithArray:events];

	for (NSDictionary * event in events)
	{
		if ([[event valueForKey:@"t"] isEqual:@"device"])
			[chartEvents addObject:event];
	}

	NSDictionary * e = [NSDictionary dictionaryWithObjectsAndKeys:@"device", @"t", [NSNumber numberWithFloat:0], @"v", [NSDate date], @"date", nil];
	[chartEvents addObject:e];

		CGRect bounds = [self bounds];
		
		bounds.size.width -= 20;
		bounds.size.height -= 65;
		bounds.origin.x += 10;
		bounds.origin.y += 55;
		
		if (days == 0)
			days = (int) (bounds.size.height / 30);
		
		float daySeconds = 24 * 60 * 60;

		NSDateFormatter * timeFormatter = [[NSDateFormatter alloc] init];
		[timeFormatter setDateFormat:@"yyyy-MM-dd kk:mm.ss"];
		
		NSDate * today = [NSDate date];
		
		NSMutableString * todayString = [NSMutableString stringWithString:[timeFormatter stringFromDate:today]];
		[todayString setString:[todayString substringToIndex:[todayString rangeOfString:@" "].location]];
		[todayString appendString:@" 00:00.00"];
		
		today = [timeFormatter dateFromString:todayString];
		
		[timeFormatter release];
		
		NSTimeInterval latestInterval = floor([today timeIntervalSince1970]) + (daySeconds - 1);
		
		NSTimeInterval startInterval = latestInterval - (days * daySeconds) + 1;
		
		NSString * cacheKey = [NSString stringWithFormat:@"%@-%f-%f", [[events lastObject] valueForKey:@"s"], startInterval, latestInterval];
		
		PresenceTimeline * timeline = [timelineCache valueForKey:cacheKey];
		
		if (timeline == nil)
		{
			timeline = [[PresenceTimeline alloc] initWithStart:startInterval
														   end:latestInterval
												  initialValue:0];
			
			NSUInteger eventsCount = [chartEvents count];
			
			for (NSUInteger i = 0; i < eventsCount; i++)
			{
				NSDictionary * event = [chartEvents objectAtIndex:i];
				
				if ([[event valueForKey:@"date"] timeIntervalSince1970] > startInterval)
				{
					NSDictionary * nextEvent = nil;
					
					if (i < (eventsCount - 1))
						nextEvent = [chartEvents objectAtIndex:(i + 1)];
					
					if (nextEvent != nil)
					{
						[timeline setValue:[[event valueForKey:@"v"] floatValue]
								atInterval:[[event valueForKey:@"date"] timeIntervalSince1970]
							  nextInterval:[[nextEvent valueForKey:@"date"] timeIntervalSince1970]];
					}
					else
						[timeline setValue:[[event valueForKey:@"v"] floatValue] atInterval:[[event valueForKey:@"date"] timeIntervalSince1970]];
				}
			}
			
			[timelineCache setValue:timeline forKey:cacheKey];
			[timeline release];

		}
		
		NSMutableArray * labels = [NSMutableArray array];
		
		NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"MMM d"];
		
		for (int day = 0; day < days; day++)
		// for (int day = days - 1; day >= 0; day--)
		{
			NSTimeInterval startInterval = latestInterval - (daySeconds * day);
			
			NSDate * date = [NSDate dateWithTimeIntervalSince1970:startInterval];
			
			[labels addObject:[formatter stringFromDate:date]];
		}
		
		[formatter release];

		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);

		UIFont * labelFont = [UIFont fontWithName:@"Helvetica-Bold" size:10];
		
		float labelWidth = 0;
		NSEnumerator * labelIter = [labels objectEnumerator];
		NSString * label = nil;
		while (label = [labelIter nextObject])
		{
			CGSize labelSize = [label sizeWithFont:labelFont];
			
			if (labelSize.width > labelWidth)
				labelWidth = labelSize.width;
		}			
		
		for (int day = 0; day < days; day++)
		// for (int day = days - 1; day >= 0; day--)
		{
			NSString * label = [labels objectAtIndex:day];
			
			CGSize labelSize = [label sizeWithFont:labelFont];
			
			float offset = labelWidth - labelSize.width;
			
			[label drawAtPoint:CGPointMake(bounds.origin.x + offset, bounds.origin.y + (30 * day) + 18) withFont:labelFont];
		}
		
		labelWidth += 5;
		
		for (int day = 0; day < days; day++)
		// for (int day = days - 1; day >= 0; day--)
		{
			NSTimeInterval startInterval = latestInterval - daySeconds;
			
			CGRect timeRect = CGRectMake(bounds.origin.x, bounds.origin.y + (30 * day), bounds.size.width, 30);
			timeRect.origin.x += ceil(labelWidth);
			timeRect.size.width -= ceil(labelWidth);
			
			[self drawTimeline:timeline start:startInterval end:latestInterval inRect:timeRect];
			
			latestInterval -= daySeconds;
		}
}

- (void) refresh
{
	if (timelineCache != nil)
	{
		[timelineCache removeAllObjects];
	}
	
	[super refresh];
}

- (void) drawChartForEvents:(NSArray *) events
{
	[self drawChartForEvents:events days:0];
}

- (void)drawRect:(CGRect)rect 
{
	CGRect bounds = [self bounds];

	[super drawRect:bounds];
		
	NSArray * events = [self.device events];
		
	[self drawChartForEvents:events];
		
	if (![device editable])
	{
		NSString * desc = [self.device shortDescription];
	
		UIFont * font = [UIFont fontWithName:@"Helvetica-Bold" size:32];
		
		CGPoint point = CGPointMake(10, 8);

		[self setTextColor];
	
		[desc drawAtPoint:point withFont:font];
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGFloat alpha = [self.device intensity];
	UIColor * color = [self.device color];
	[[color colorWithAlphaComponent:alpha] setFill];

	CGContextSetRGBStrokeColor(context, 0.33, 0.33, 0.33, 1.0);

	CGRect circleBounds = CGRectMake(bounds.size.width - 45, 10, 33, 33);
	
	CGContextSetLineWidth (context, 4.0);
	CGContextFillEllipseInRect(context, circleBounds);
	CGContextStrokeEllipseInRect(context, circleBounds);
}


@end
