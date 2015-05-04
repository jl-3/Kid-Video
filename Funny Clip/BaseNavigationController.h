//
//  BaseNavigationController.h
//  Funny Clip
//
//  Created by NhanNLT on 4/15/15.
//  Copyright (c) 2015 NhanNLT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunBaseViewController.h"
#import "FirstScreenView.h"
#import "PlaylistViewController.h"
#import <MMDrawerBarButtonItem.h>
@interface BaseNavigationController : UINavigationController

@property (retain) FunBaseViewController* baseViewController;
@property (retain) FirstScreenView* firstScreenViewController;
@property (retain) PlaylistViewController* PlayListViewController;
@property (retain) PlaylistViewController* IpadplayListViewController;
@property (weak, nonatomic) IBOutlet UIButton *leftbtn;

@end
