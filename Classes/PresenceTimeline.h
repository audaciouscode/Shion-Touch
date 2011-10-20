//
//  PresenceTimeline.h
//  Shion
//
//  Created by Chris Karr on 4/11/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PresenceTimeline : NSObject 
{
	NSTimeInterval start;
	NSTimeInterval end;
	
	NSTimeInterval first;

	unsigned int index;
	unsigned int length;
	
	NSMutableArray * dates;
	NSMutableArray * presences;
	
	float * values;
}

- (id) initWithStart:(NSTimeInterval) startInterval end:(NSTimeInterval) endInterval initialValue:(float) value;
- (void) setValue:(float) value atInterval:(NSTimeInterval) interval;
- (void) setValue:(float) value atInterval:(NSTimeInterval) interval nextInterval:(NSTimeInterval) nextInterval;
- (double) averageForStart:(NSTimeInterval) startInterval end:(NSTimeInterval) endInterval;

@end
