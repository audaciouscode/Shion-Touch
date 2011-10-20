//
//  TivoFolderViewController.h
//  Shion Touch
//
//  Created by Chris Karr on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Tivo.h"

@interface TivoFolderViewController : UITableViewController 
{
	NSDictionary * folder;
	Tivo * device;
}

@property(retain) NSDictionary * folder;
@property(retain) Tivo * device;

@end
