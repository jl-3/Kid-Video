// Copyright 2014 Google Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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

#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"

//
//#import "VideoItemCollectCell.m"
@protocol PlaylistViewControllerDelegate <NSObject>;
@end;

@interface PlaylistViewController : FunBaseViewController<YouTubeGetVideosDelegate,UICollectionViewDataSource,UICollectionViewDelegate, UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate>
{
    NSMutableArray *mVideos;
    NSMutableArray *mPlayLists;
    NSMutableArray *mFavoriteVideos;
    NSDictionary *playerVars ;
    int flag; //flag =1 : am nhac
              //flag =2 : ke chuyen
              //flag =3 : hoat hinh
    NSTimer *timer;
    float durationOfCurrentVideoPlaying;
    NSArray *mMenuItems;
  
    UIViewController *mVCAbout;
}
@property (weak, nonatomic) NSString *currentTextInSearchBar;

@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property(nonatomic, strong) NSArray *VIDEOS_SEARCH_RESULTS;
@property(nonatomic, strong) NSArray *VIDEOS_AMNHAC;
@property(nonatomic, strong) NSArray *VIDEOS_KECHUYEN;
@property(nonatomic, strong) NSArray *VIDEOS_HOATHINH;
@property(nonatomic, strong) YouTubeGetVideos *getVideos;
@property(nonatomic, retain) GTLServiceYouTube *youtubeService;


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


@property(nonatomic, weak) IBOutlet UIButton *playButton;
@property(nonatomic, weak) IBOutlet UIButton *nextVideoButton;
@property(nonatomic, weak) IBOutlet UIButton *previousVideoButton;
@property (weak, nonatomic) IBOutlet UIButton *btnAmNhac;
@property (weak, nonatomic) IBOutlet UIButton *btnKeChuyen;
@property (weak, nonatomic) IBOutlet UIButton *btnHoatHinh;
@property (strong, nonatomic) IBOutlet UIButton *ViewUpDownbtn;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *playerViewFace;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIView *ViewListTable;

- (IBAction)setProgress:(UISlider *)sender;
- (IBAction)buttonPressed:(id)sender;
- (IBAction)buttonPlayerViewFace:(id)sender;
- (void) saveToDBWhenClick : (VideoData*) vData;

@property (retain) id<PlaylistViewControllerDelegate> delegate;
@end