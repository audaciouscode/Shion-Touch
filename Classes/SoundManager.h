//
//  SoundManager.h
//  Shion Touch
//
//  Created by Chris Karr on 8/16/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundManager : NSObject <AVAudioPlayerDelegate>
{

}

+ (SoundManager *) sharedManager;

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
- (void) play:(NSString *) file;

@end
