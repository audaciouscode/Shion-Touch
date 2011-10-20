//
//  SoundManager.m
//  Shion Touch
//
//  Created by Chris Karr on 8/16/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

static SoundManager * sharedManager = nil;

+ (SoundManager *) sharedManager
{
    @synchronized(self) 
	{
        if (sharedManager == nil) 
		{
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedManager;
}

+ (id) allocWithZone:(NSZone *) zone
{
    @synchronized(self) 
	{
        if (sharedManager == nil) 
		{
            sharedManager = [super allocWithZone:zone];
            return sharedManager;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil
}

- (id) copyWithZone:(NSZone *) zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (unsigned) retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void) release
{
    //do nothing
}

- (id) autorelease
{
    return self;
}

- (void) play:(NSString *) file
{
	NSURL * url = [[NSBundle mainBundle] URLForResource:file withExtension:@"mp3"];
	
	AVAudioPlayer * player = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfURL:url] error:NULL];
	player.delegate = self;
	
	[player play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	[player release];
}

@end
