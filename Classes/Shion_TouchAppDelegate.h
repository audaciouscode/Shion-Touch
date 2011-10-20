//
//  Shion_TouchAppDelegate.h
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright CASIS 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Shion_TouchAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
