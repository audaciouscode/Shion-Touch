//
//  TivoShowViewController.h
//  Shion Touch
//
//  Created by Chris Karr on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TivoShowViewController : UIViewController 
{
	NSDictionary * show;

	IBOutlet UILabel * showTitle;
	IBOutlet UILabel * episode;
	IBOutlet UILabel * recorded;
	IBOutlet UILabel * synopsis;
}

@property(retain) NSDictionary * show;

@end


/* [dict setValue:[[element attributeForName:@"station"] stringValue] forKey:@"station"];
[dict setValue:[[element attributeForName:@"title"] stringValue] forKey:@"title"];
[dict setValue:[[element attributeForName:@"episode"] stringValue] forKey:@"episode"];
[dict setValue:[[element attributeForName:@"episode_number"] stringValue] forKey:@"episode_number"];
[dict setValue:[[element attributeForName:@"high_definition"] stringValue] forKey:@"high_definition"];
[dict setValue:[[element attributeForName:@"synopsis"] stringValue] forKey:@"synopsis"];
[dict setValue:[[element attributeForName:@"rating"] stringValue] forKey:@"rating"];
[dict setValue:[[element attributeForName:@"duration"] stringValue] forKey:@"duration"];
[dict setValue:[[element attributeForName:@"recorded"] stringValue] forKey:@"recorded"];
 
 */
