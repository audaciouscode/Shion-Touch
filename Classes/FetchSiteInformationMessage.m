//
//  FetchSiteInformationMessage.m
//  Shion Touch
//
//  Created by Chris Karr on 3/4/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "FetchSiteInformationMessage.h"
#import "DDXML.h"
#import "DDXMLNode.h"
#import "XMPPJID.h"

#import "XMPPManager.h"

@implementation FetchSiteInformationMessage

+ (XMPPIQ *) iq
{
	XMPPIQ * iq = [super iq];
	
	XMPPJID * jid = [[XMPPManager sharedManager] myJid];

	NSString * luaCommand = [NSString stringWithFormat:@"shion:sendEnvironmentToJid(\"%@\")", [jid description]];
	
	[[iq elementForName:@"query"] setStringValue:luaCommand];
	[[iq elementForName:@"query"] addAttributeWithName:@"language" stringValue:@"lua"];
	
	return iq;
}

@end
