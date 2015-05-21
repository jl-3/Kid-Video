//
//  FunBaseViewController.h
//  Funny Clip
//
//  Created by nhannlt on 15/04/2015.
//  Copyright (c) Năm 2015 NhanNLT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YTPlayerView.h>
#import "DBManager.h"
#import <MMDrawerBarButtonItem.h>
#import <MBProgressHUD.h>
#import "iAd/ADBannerView.h"
@protocol FunBaseViewControllerDelegate <NSObject>;
@end
@interface FunBaseViewController : UIViewController<YTPlayerViewDelegate, ADBannerViewDelegate> {


    
}


@property (retain) id <FunBaseViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *testbtn;
@property (nonatomic,strong) NSMutableArray  *mFavoriteVideos;
- (void) setTitleNavigationBar;
- (void) setLeftBtnNavigationBar;
- (BOOL) saveToFavorite: (FavoriteVideoDetail *) mFavoriteItem ;
- (BOOL) loadAllFavoriteVideosFromDB ;


@end
