//
//  FirstScreenView.h
//  Funny Clip
//
//  Created by nhannlt on 15/04/2015.
//  Copyright (c) Năm 2015 NhanNLT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunBaseViewController.h"
#import <YTPlayerView.h>
@protocol FirstScreenDelegate <NSObject>;
@end;
@interface FirstScreenView : FunBaseViewController


@property (retain) id<FirstScreenDelegate> delegate;


@end
