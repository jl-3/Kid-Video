//
//  BaseUtils.h
//  Tivi Cho Bé 
//
//  Created by nhannlt on 10/05/2015.
//  Copyright (c) Năm 2015 NhanNLT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
static NSString *const DEFAULT_KEYWORD = @"ytdl";
static NSString *const PLAYLIST_MOVIE = @"LLfF4l8coMQddgehpwdl4lqA";
static NSString *const PLAYLIST_SONG = @"LLfF4l8coMQddgehpwdl4lqA";
static NSString *const PLAYLIST_STORY = @"LLfF4l8coMQddgehpwdl4lqA";

static NSString *const kClientID = @"352228618510-m24qqg1v3r7f96926or523b03kri1362.apps.googleusercontent.com";
static NSString *const kClientSecret = @"Jd1PVRLfDZtv2FSYmFUDi6Kb";

static NSString *const kKeychainItemName = @"YouTube Direct Lite";

static NSString *const BTN_NAME_MENU = @"menu.png";
static NSString *const BTN_NAME_FAVORITE = @"YEUTHICH.png";
static NSString *const BTN_NAME_LIBRARY = @"thuvien.png";
static NSString *const BTN_NAME_MUSIC = @"theloai_amnhac.png";
static NSString *const BTN_NAME_STORY = @"theloai_kechuyen.png";
static NSString *const BTN_NAME_CARTOON = @"theloai_hoathinh.png";
static NSString *const BTN_NAME_PLAY = @"icon_play_black.png";
static NSString *const BTN_NAME_PAUSE = @"menu.png";
static NSString *const BTN_NAME_ = @"icon_pause_black.png";

static NSInteger const MAX_ITEM_IN_LIST = 200;

static NSInteger const IS_MUSIC = 1;
static NSInteger const IS_STORY = 2;
static NSInteger const IS_CARTOON = 3;
static NSInteger const IS_SEARCH = 4;

static NSInteger const IS_SEARCH_NORMAL_PAGE = 0;
static NSInteger const IS_SEARCH_NEXT_PAGE = 1;
static NSInteger const IS_SEARCH_PRV_PAGE = 2;

static NSInteger const IS_GET_NORMAL_PAGE = 0;
static NSInteger const IS_GET_NEXT_PAGE = 1;
static NSInteger const IS_GET_PRV_PAGE = 2;


static NSInteger const TYPE_OF_RESULT_NORMAL = 0;
static NSInteger const TYPE_OF_RESULT_NEXT_PAGE = 1;
static NSInteger const TYPE_OF_RESULT_PRV_PAGE = 1;


#define POPUP_INFO_NETWORK_ERROR                    NSLocalizedString(@"POPUP_INFO_NETWORK_ERROR", nil)
#define POPUP_INFO_LOAD_DATA_ERROR                  NSLocalizedString(@"POPUP_INFO_LOAD_DATA_ERROR", nil)
#define ITEMS_MENU                                  NSLocalizedString(@"ITEMS_MENU", nil)
#define ABOUT_APP                                   NSLocalizedString(@"ABOUT_APP", nil)
#define POPUP_TITLE_NETWORK                         NSLocalizedString(@"POPUP_TITLE_NETWORK", nil)

@interface BaseUtils : NSObject

+ (UIAlertView*)showWaitIndicator:(NSString *)title;
+ (void)showAlert:(NSString *)title message:(NSString *)message;
+ (NSString *)humanReadableFromYouTubeTime:(NSString *)youTubeTimeFormat;

+ (id ) objectAtIndex: (NSMutableArray *) mArray : (int) index ;
@end
