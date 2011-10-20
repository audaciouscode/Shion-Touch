//
//  ScriptMessage.m
//  Shion Touch
//
//  Created by Chris Karr on 4/22/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "ScriptMessage.h"
#import "DDXML.h"
#import "DDXMLElement.h"
#import "DDXMLNode.h"
#import "XMPPJID.h"

@implementation ScriptMessage

+ (XMPPIQ *) iq
{
	XMPPIQ * iq = [super iq];
	
	[[[iq elementsForName:@"query"] lastObject] addAttribute:[DDXMLNode attributeWithName:@"language" stringValue:@"lua"]];
	
	return iq;
}

+ (XMPPIQ *) iqForDevice:(Device *) device script:(NSString *) script
{
	XMPPIQ * iq = [ScriptMessage iq];
	
	[[[iq elementsForName:@"query"] lastObject] setStringValue:script];
	
	return iq;
}

+ (XMPPIQ *) iqForSnapshot:(Snapshot *) snapshot script:(NSString *) script
{
	XMPPIQ * iq = [ScriptMessage iq];
	
	[[[iq elementsForName:@"query"] lastObject] setStringValue:script];
	
	return iq;
}

+ (XMPPIQ *) iqForTrigger:(Trigger *) trigger script:(NSString *) script
{
	XMPPIQ * iq = [ScriptMessage iq];
	
	[[[iq elementsForName:@"query"] lastObject] setStringValue:script];
	
	return iq;
}

@end
