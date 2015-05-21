//
//  PlaylistViewController.h
//  Funny Clip
//
//  Created by NhanNLT on 4/15/15.
//  Copyright (c) 2015 NhanNLT. All rights reserved.

#import "YTPlayerView.h"
#import "FunBaseViewController.h"
#import <DNDDragAndDropController.h>
#import <DNDDragAndDrop/DNDDragAndDrop.h>
#import "NMBottomTabBarController.h"
#import "mVideoCell.h"
#import "VideoItemCollectCell.h"
#import "GTLYouTube.h"
#import "VideoData.h"
#import "YouTubeGetVideos.h"
#import <MobileCoreServices/MobileCoreServices.h>
//
#import <AFNetworkReachabilityManager.h>
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "BaseUtils.h"
#import "tbvCellMenu.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
//
//#import "VideoItemCollectCell.m"
@protocol PlaylistViewControllerDelegate <NSObject>;
@end;

@interface PlaylistViewController : FunBaseViewController<YTPlayerViewDelegate, YouTubeGetVideosDelegate, UICollectionViewDataSource,UICollectionViewDelegate, UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UIScrollViewDelegate , GADBannerViewDelegate>
{
   
    
    ADBannerView *adBannerView;
    BOOL adBannerViewIsVisible;
    GADBannerView *mGADBannerView;
    BOOL mGADBannerViewIsVisible;
   
    
    BOOL isTheFirstTime;
    
    NSMutableArray *mVideos;
    NSMutableArray *mPlayLists;
    NSMutableArray *mFavoriteVideos;
    NSDictionary *playerVars ;
    NSTimer *timerSeekingView;
    int IS_OPEN_IN_TAB;
                //flag =1 : am nhac
              //flag =2 : ke chuyen
              //flag =3 : hoat hinh
    // flag=4: search
    NSTimer *timer;
    NSTimer *timerCheckNetwork;
    // tmp variable
    float tmpValueOfSlider;
    float durationOfCurrentVideoPlaying;
    NSString *CurrentVideoIdPlaying;
    float theSecondBefore;
    NSArray *mMenuItems;
    UIViewController *mVCAbout;
    NSString *nextPageToken;
    NSString *prevPageToken;
    BOOL isLoadFinish;
    NSMutableArray *VIDEOS_AMNHAC;
    NSMutableArray *VIDEOS_SEARCH_RESULTS;
    NSMutableArray *VIDEOS_KECHUYEN;
    NSMutableArray *VIDEOS_HOATHINH;
    UIAlertView *alertViewNetwork;
    BOOL isLoadedJson;
}
@property (weak, nonatomic) NSString *currentTextInSearchBar;

@property (strong, nonatomic) UITapGestureRecognizer *tap;
//@property(nonatomic, strong) NSMutableArray *VIDEOS_SEARCH_RESULTS;
//@property(nonatomic, strong) NSMutableArray *VIDEOS_AMNHAC;
//@property(nonatomic, strong) NSMutableArray *VIDEOS_KECHUYEN;
//@property(nonatomic, strong) NSMutableArray *VIDEOS_HOATHINH;
@property(nonatomic, strong) YouTubeGetVideos *getVideos;
@property(nonatomic, retain) GTLServiceYouTube *youtubeService;


@property (weak, nonatomic) IBOutlet UIView *viewAds;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heighOfAds;
@property (weak, nonatomic) IBOutlet UIImageView *televisionImage;
@property (weak, nonatomic) IBOutlet UITableView *mListVideo;
@property (weak, nonatomic) IBOutlet UITableView *tbvMenu;
@property (weak, nonatomic) IBOutlet UITabBar *mTabbar;
@property (weak, nonatomic) IBOutlet UISlider *sliderVideo;

@property (weak, nonatomic) IBOutlet UIView *SourcePlayerView;
@property (weak, nonatomic) IBOutlet UICollectionView *listViewColectionView;
@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomOfSeekingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingOfMenuView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceListVideo;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceListVideo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heighButtonTheLoai;
//constraigt for butotn
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingHoatHinh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthHoatHinh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHoatHInh;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingAmNhac;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthAmNhac;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomAmNhac;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *withOfKeChuyen;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottonKeChuyen;

@property (weak, nonatomic) IBOutlet MarqueeLabel *titleVideoPlaying;
@property (weak, nonatomic) IBOutlet UIView *MenuView;

@property (weak, nonatomic) IBOutlet UIView *ViewListCollection;
@property (weak, nonatomic) IBOutlet UIView *viewButonSeeking;
@property (strong, nonatomic) IBOutlet UIView *viewButtonTheLoai;


@property(nonatomic, weak) IBOutlet UIButton *playButton;
@property(nonatomic, weak) IBOutlet UIButton *nextVideoButton;
@property(nonatomic, weak) IBOutlet UIButton *previousVideoButton;
@property (weak, nonatomic) IBOutlet UIButton *btnAmNhac;
@property (weak, nonatomic) IBOutlet UIButton *btnKeChuyen;
@property (weak, nonatomic) IBOutlet UIButton *btnHoatHinh;
@property (strong, nonatomic) IBOutlet UIButton *ViewUpDownbtn;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnRecent;

@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIView *ViewListTable;

- (IBAction)setProgress:(UISlider *)sender;
- (IBAction)buttonPressed:(id)sender;

- (void) saveToDBWhenClick : (VideoData*) vData;

@property (retain) id<PlaylistViewControllerDelegate> delegate;
@end