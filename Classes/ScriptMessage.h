//
//  ScriptMessage.h
//  Shion Touch
//
//  Created by Chris Karr on 4/22/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShionMessage.h"
#import "Device.h"
#import "Snapshot.h"

#import "Trigger.h"

@interface ScriptMessage : ShionMessage 
{

}

+ (XMPPIQ *) iqForDevice:(Device *) device script:(NSString *) script;
+ (XMPPIQ *) iqForSnapshot:(Snapshot *) snapshot script:(NSString *) script;
+ (XMPPIQ *) iqForTrigger:(Trigger *) trigger script:(NSString *) script;

@end
