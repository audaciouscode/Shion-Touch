//
//  XMPPManager.h
//  Shion Touch
//
//  Created by Chris Karr on 3/4/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XMPP.h"
#import "Device.h"
#import "Snapshot.h"
#import "Trigger.h"

@interface XMPPManager : NSObject 
{
	XMPPClient * xmppClient;
	NSMutableDictionary * siteJidMap;
	
	NSMutableArray * endpoints;
	NSMutableSet * sent;
	
	NSMutableArray * pendingIqs;
	NSTimer * iqTimer;
	
	NSString * connectionStatus;
	NSString * statusDetails;
	BOOL connected;
	
	NSTimer * statusTimer;
}

@property(retain) NSString * connectionStatus;
@property(retain) NSString * statusDetails;

@property(assign) BOOL connected;

+ (XMPPManager *) sharedManager;

- (void) go;

- (XMPPJID *) myJid;

- (void) sendCommand:(NSString *) command forDevice:(Device *) device;
- (void) sendCommand:(NSString *) command forSnapshot:(Snapshot *) snapshot;
- (void) sendCommand:(NSString *) command forTrigger:(Trigger *) trigger;

- (void) broadcastCommand:(NSString *) command;

- (void) fetchEventsForDevice:(Device *) device;
- (void) sendStatus:(NSTimer *) theTimer;
	
@end
