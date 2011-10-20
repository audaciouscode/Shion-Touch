//
//  TivoViewController.h
//  Shion Touch
//
//  Created by Chris Karr on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tivo.h"

@interface TivoViewController : UITableViewController 
{
	Tivo * device;
}

@property(retain) Tivo * device;

@end
