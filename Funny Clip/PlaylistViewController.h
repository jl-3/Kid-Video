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
//#import "VideoItemCollectCell.m"
@protocol PlaylistViewControllerDelegate <NSObject>;
@end;

@interface PlaylistViewController : FunBaseViewController<YouTubeGetVideosDelegate,UICollectionViewDataSource,UICollectionViewDelegate, UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *mVideos;
    NSDictionary *playerVars ;
    
}
@property(nonatomic, strong) NSArray *videos;
@property(nonatomic, strong) YouTubeGetVideos *getVideos;
@property(nonatomic, retain) GTLServiceYouTube *youtubeService;


@property (weak, nonatomic) IBOutlet UIImageView *televisionImage;
@property (weak, nonatomic) IBOutlet UITableView *mListVideo;
@property (weak, nonatomic) IBOutlet UITabBar *mTabbar;
@property (strong, nonatomic) IBOutlet UIButton *ViewUpDownbtn;

@property (weak, nonatomic) IBOutlet UICollectionView *listViewColectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceListVideo;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceListVideo;

@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;
@property(nonatomic, weak) IBOutlet UIButton *playButton;
@property(nonatomic, weak) IBOutlet UIButton *nextVideoButton;
@property(nonatomic, weak) IBOutlet UIButton *previousVideoButton;

- (IBAction)buttonPressed:(id)sender;

//@property (nonatomic, weak) IBOutlet UIView *dragSourceView;
//@property (nonatomic, weak) IBOutlet UIView  *dropTargetView;
//@property (nonatomic, strong) IBOutlet DNDDragAndDropController *dragAndDropController;
@property (retain) id<PlaylistViewControllerDelegate> delegate;
@end