//
//  PresenceTimeline.m
//  Shion
//
//  Created by Chris Karr on 4/11/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "PresenceTimeline.h"

@implementation PresenceTimeline

- (id) initWithStart:(NSTimeInterval) startInterval end:(NSTimeInterval) endInterval initialValue:(float) value
{
	if (self = [super init])
	{
		dates = [[NSMutableArray alloc] init];
		presences = [[NSMutableArray alloc] init];
		
		start = floor(startInterval);
		end = floor(endInterval);

		length = (int) (end - start);

		if (length < 1)
			length = 1;
		
		values = malloc(sizeof(float) * length);

		for (unsigned int i = 0; i < length; i++)
			values[i] = value;
		
		index = 0;
		values[index] = value;
		
		first = [[NSDate distantFuture] timeIntervalSince1970];
	}
	
	return self;
}

- (void) dealloc
{
	[dates release];
	[presences release];
	
	free(values);
	
	[super dealloc];
}

- (void) setValue:(float) value atInterval:(NSTimeInterval) interval nextInterval:(NSTimeInterval) nextInterval
{
	if (interval < first)
		first = interval;
	
	unsigned int dateIndex = (unsigned int) (interval - start);
	unsigned int endIndex = (unsigned int) (nextInterval - start);
	
	if (endIndex > length)
		endIndex = length;
	
	for (unsigned int i = dateIndex; i < endIndex; i++)
		values[i] = value;
}

- (void) setValue:(float) value atInterval:(NSTimeInterval) interval
{
	if (interval < first)
		first = interval;

	unsigned int dateIndex = (unsigned int) (interval - start);
	
	for (unsigned int i = dateIndex; i < length; i++)
		values[i] = value;
}


- (double) averageForStart:(NSTimeInterval) startInterval end:(NSTimeInterval) endInterval
{
	if (endInterval < first)
		return 0;
	
	unsigned int begin = (unsigned int) (startInterval - start);
	unsigned int finish = (unsigned int) (endInterval - start);
	
	double sum = 0;
	
	for (unsigned int i = begin; i < finish && i < length; i++)
		sum += values[i];
	
	return sum / (finish - begin);
}

@end
