//
//  AppDelegate.h
//  Funny Clip
//
//  Created by NhanNLT on 4/15/15.
//  Copyright (c) 2015 NhanNLT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "NMBottomTabBarController.h"
@class BaseNavigationController;
@class BaseTabBarController;
@interface AppDelegate : UIResponder <UIApplicationDelegate, NMBottomTabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property BaseNavigationController *navigationController;
//@property BaseTabBarController *tabBarController;

@end

