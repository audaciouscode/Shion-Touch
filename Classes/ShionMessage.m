//
//  ShionMessage.m
//  Shion Touch
//
//  Created by Chris Karr on 3/4/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "ShionMessage.h"
#import "DDXML.h"

@implementation ShionMessage

+ (XMPPIQ *) iq
{
	DDXMLElement * message = [[DDXMLElement alloc] initWithXMLString:@"<iq type=\"get\"><query xmlns=\"shion:script\" /></iq>" error:nil];
	
	XMPPIQ * iq = [XMPPIQ iqFromElement:message];

	[message autorelease];
	
	return iq;
}


@end
