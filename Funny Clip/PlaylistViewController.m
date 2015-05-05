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

#import "PlaylistViewController.h"
#import "JSONHTTPClient.h"
#import "NSURLParameters.h"
#import "VideoModel.h"
#import <UIImageView+AFNetworking.h>
#import <AFNetworking/AFHTTPRequestOperation.h>

#import "GTMOAuth2ViewControllerTouch.h"
#import "VideoData.h"
#import "UploadController.h"
#import "VideoListViewController.h"
#import "Utils.h"
#import "JSONModel.h"
#include "PlayListModel.h"
#import "tblCellMenu.h"
#import "VCAbout.h"
// Thumbnail image size.

@implementation PlaylistViewController
@synthesize youtubeService;
static NSString * const BaseURLString =@"https://www.dropbox.com/s/msp70rmarezsjyw/VideoJson.txt?dl=1";
//static NSString * const BaseURLString =@"http://download1829.mediafire.com/l65sl01adg5g/i3vkjn90ylc6d48/sampleAPIData.txt";

- (id)init
{
    self = [super init];
    if (self) {
        _getVideos = [[YouTubeGetVideos alloc] init];
        _getVideos.delegate = self;
        _VIDEOS_AMNHAC = [[NSArray alloc] init];
         _VIDEOS_KECHUYEN = [[NSArray alloc] init];
         _VIDEOS_HOATHINH = [[NSArray alloc] init];
        _VIDEOS_SEARCH_RESULTS = [[NSArray alloc] init];
        
        flag=1;
      mVCAbout = [[VCAbout alloc]initWithNibName:@"VCAbout" bundle:nil];
    }
    return self;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
  
}

- (void)showList {
   // VideoListViewController *listUI = [[VideoListViewController alloc] init];
   // listUI.youtubeService = self.youtubeService;
   // [[self navigationController] pushViewController:listUI animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startOAuthFlow:(id)sender {
    GTMOAuth2ViewControllerTouch *viewController;
    
    viewController = [[GTMOAuth2ViewControllerTouch alloc]
                      initWithScope:kGTLAuthScopeYouTube
                      clientID:kClientID
                      clientSecret:kClientSecret
                      keychainItemName:kKeychainItemName
                      delegate:self
                      finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
    [[self navigationController] pushViewController:viewController animated:YES];
}
#pragma mark - YouTubeGetUploadsDelegate methods

- (void)getYouTubeVideos:(YouTubeGetVideos *)getVideos didFinishWithResults:(NSArray *)results {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    switch (flag) {
        case 1:
            self.VIDEOS_AMNHAC = results;
            break;
        case 2:
            self.VIDEOS_KECHUYEN = results;
            break;
        case 3:
            self.VIDEOS_HOATHINH = results;
            break;
        default:
            self.VIDEOS_SEARCH_RESULTS = results;
            break;
    }
    //[self.ViewListCollection setHidden:NO];
    [self.listViewColectionView reloadData];
    [self ShowViewScroll];
  
    //[self.mListVideo reloadData];
}


- (void) outlog {
    NSLog(@"xuat log");
}
- (void) initDataMenu {
    mMenuItems = [NSArray arrayWithObjects:@"Purchase",@"Help",@"About", nil];
   
}
- (void) initItemStatus {
    [self.playerViewFace setHidden:YES];
    [self.playButton setSelected:YES];
    [self.ViewListCollection setAlpha:0];
    [self.searchBarView setHidden:YES];
    [self.trailingOfMenuView setConstant:-140];
    self.listViewColectionView.bounces =NO ;
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.playButton setImage:[UIImage imageNamed:@"icon_pause_black.png"] forState:UIControlStateSelected];
    //setup title video playing
    self.titleVideoPlaying.textAlignment= NSTextAlignmentLeft;
    self.titleVideoPlaying.marqueeType = MLContinuous;
    self.titleVideoPlaying.scrollDuration = 20.0f;
    self.titleVideoPlaying.fadeLength = 20.0f;
    self.titleVideoPlaying.trailingBuffer = self.titleVideoPlaying.frame.size.width;
    self.titleVideoPlaying.animationDelay=0.f;
    
    [self.viewButonSeeking setAlpha:0];
    self.currentTextInSearchBar = @"";
    
    // table
    [self.mListVideo setSectionFooterHeight:1];
    [self.tbvMenu setBounces:NO];
   // [self.tbvMenu vi];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeLeft] forKey:@"orientation"];
   
   // [self.listViewColectionView setHidden:YES];
    [self init];
    [self initItemStatus];
    [self initDataMenu];
    mFavoriteVideos = [NSMutableArray array];
    self.youtubeService = [[GTLServiceYouTube alloc] init];
    self.youtubeService.authorizer =
    [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                          clientID:kClientID
                                                      clientSecret:kClientSecret];
    if (![self isAuthorized]) {
        // Not yet authorized, request authorization and push the login UI onto the navigation stack.
        [[self navigationController] pushViewController:[self createAuthController] animated:YES];
    }

  
    NSString* videoID = @"9IHb4PBrxYQ";
   // [self.playButton setImage:[UIImage imageNamed:@"stop_on.png"] forState:UIControlStateSelected];
  // For a full list of player parameters, see the documentation for the HTML5 player
  // at: https://developers.google.com/youtube/player_parameters?playerVersion=HTML5
 playerVars = @{
    @"controls" : @0,
    @"playsinline" : @1,
    @"autohide" : @1,
    @"showinfo" : @0,
    @"modestbranding" : @1
  };
  self.playerView.delegate = self;
 
  [self.playerView loadWithVideoId:videoID playerVars:playerVars];
   timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkDurationTime) userInfo:nil repeats:YES];
    //[self.playerView setFrame:CGRectMake(0, 0, 400, 400)];
//     [self.playButton setImage:[UIImage imageNamed:@"youtube_pause.png"] forState:UIControlStateSelected];
    
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(receivedPlaybackStartedNotification:)
                                               name:@"Playback started"
                                             object:nil];
   
    
    [self loadDataJson];
    if ([self loadAllFavoriteVideosFromDB]) {
        [self.mListVideo reloadData];
    }
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDisAppearOrShow)];
    _tap.enabled = NO;
    [self.view addGestureRecognizer:_tap];
  }
- (void) checkDurationTime {
    if ([self.playerView currentTime ]> 0) {
        [self.playerViewFace setHidden:NO];
       
        NSLog(@"%f",[self.playerView currentTime ]);
        NSLog(@"%i",[self.playerView duration ]);
        NSLog(@"%f",[self.playerView currentTime]/(float)[self.playerView duration]);
        [self.sliderVideo setValue:([self.playerView currentTime]/(float)[self.playerView duration ]) animated:YES];
    }
}
- (void)  keyboardDisAppearOrShow {
    [self.searchBarView resignFirstResponder];
    _tap.enabled = NO;
}
- (void) loadDataJson {
    NSURL *url = [NSURL URLWithString:BaseURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    mPlayLists = [NSMutableArray array];

    //[mPlayLists init];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
   // operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        

        NSDictionary *dict = (NSDictionary*)responseObject;
        NSMutableArray *tmpArray= dict[@"MyPlayLists"];
        for (int i=0;i<tmpArray.count;i++)
        {
            NSObject *tmpObject;
            tmpObject= [tmpArray objectAtIndex:i];
           // NSLog([tmpObject valueForKey:@"playListId"]);
            PlayListModel *mPlayListModel = [PlayListModel PlayListWithDictionary:
                                   @{ @"playListId":[tmpObject valueForKey:@"playListId"],
                                      @"playListName":[tmpObject valueForKey:@"playListName"],
                                         
                                         
                                         }];
            [mPlayLists  addObject:mPlayListModel];
        }
          NSString *playListIdTmp=( (PlayListModel*)[mPlayLists objectAtIndex:0]).playListId;
          [self.getVideos getYouTubeVideosWithService:self.youtubeService:playListIdTmp];
        
       // [self.SimpleTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
    
}
- (void) showVideos {
    
    [self.listViewColectionView reloadData];
    


}
#pragma mark - UISEARCHBAR Datasource
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
  //  NSString * tmpStr =[self.currentTextInSearchBar  stringByAppendingString:searchText];

   // self.currentTextInSearchBar = tmpStr;
   // [tmpStr retain];
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    //searchBar.text = self.currentTextInSearchBar;
    _tap.enabled = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    flag=4;
    
    if (![searchBar.text isEqualToString:@""]) {
     //   self.currentTextInSearchBar = searchBar.text;
    [self.getVideos searchYouTubeVideosWithService2:self.youtubeService:searchBar.text];
    }
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
 [view registerNib:[UINib nibWithNibName:@"VideoItemCollectCell" bundle:nil] forCellWithReuseIdentifier:@"collectCell"];
    NSInteger numberOf=0;
    switch (flag) {
        case 1:
            numberOf= [_VIDEOS_AMNHAC count];
            break;
        case 2:
            numberOf= [_VIDEOS_KECHUYEN count];
            break;
        case 3:
            numberOf= [_VIDEOS_HOATHINH count];
            break;
        default:
            numberOf= [_VIDEOS_SEARCH_RESULTS count];
            break;
    }
    return numberOf;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.listViewColectionView.frame.size.width/3-1, (self.listViewColectionView.frame.size.width/3-10)*80/100);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    VideoItemCollectCell *cellScroll = [cv dequeueReusableCellWithReuseIdentifier:@"collectCell" forIndexPath:indexPath];
    if (!cellScroll)
    {
        [cv registerNib:[UINib nibWithNibName:@"VideoItemCollectCell" bundle:nil] forCellWithReuseIdentifier:@"collectCell"];
        cellScroll= [cv dequeueReusableCellWithReuseIdentifier:@"collectCell" forIndexPath:indexPath];
    }
    VideoData *vData;
    switch (flag) {
        case 1:
            vData = [_VIDEOS_AMNHAC objectAtIndex:indexPath.row];
            break;
        case 2:
            vData = [_VIDEOS_KECHUYEN objectAtIndex:indexPath.row];
            break;
        case 3:
            vData = [_VIDEOS_HOATHINH objectAtIndex:indexPath.row];
            break;
        default:
            vData = [_VIDEOS_SEARCH_RESULTS objectAtIndex:indexPath.row];

            break;
    }
    cellScroll.titleLbl.trailingBuffer = cellScroll.frame.size.width;
   cellScroll.titleLbl.text = [vData getTitle];
    cellScroll.descriptionLb.text = [Utils humanReadableFromYouTubeTime:vData.getDuration];
    if ([cellScroll.descriptionLb.text isEqualToString:@"(Unknown)"]) [cellScroll.descriptionLb setHidden:YES];
    else [cellScroll.descriptionLb setHidden:NO];
    NSURL *url = [NSURL URLWithString:vData.getThumbUri];
 
       NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"bg_loading.png"];
    
   // __weak UITableViewCell *weakCell = cell;
    
    [cellScroll.thumnailImg setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       NSLog(@"image download: %f %f",image.size.width,image.size.height);
                                       NSLog(@"cell sizde: %f %f",cellScroll.thumnailImg.frame.size.width,cellScroll.thumnailImg.frame.size.height);

                                               UIGraphicsBeginImageContext(CGSizeMake(cellScroll.thumnailImg.frame.size.width,cellScroll.thumnailImg.frame.size.height
                                                                                      ));
                                               vData.fullImage = image;
                                               [ image drawInRect:
                                               CGRectMake(0, 0, cellScroll.thumnailImg.frame.size.width,cellScroll.thumnailImg.frame.size.height)];
                                               vData.thumbnail = UIGraphicsGetImageFromCurrentImageContext();
                                               UIGraphicsEndImageContext();
                                       
                                               [cellScroll.thumnailImg setImage:vData.thumbnail];
                                       //cellScroll.thumnailImg.image = image;
                                       [cellScroll setNeedsLayout];
                                       
                                   } failure:nil];
    
        return cellScroll;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 1.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1.0;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoData *vidData;
    switch (flag) {
        case 1:
            if ([_VIDEOS_AMNHAC objectAtIndex:indexPath.row]) {
            vidData = [_VIDEOS_AMNHAC objectAtIndex:indexPath.row];
            }
            break;
        case 2:
            if ([_VIDEOS_KECHUYEN objectAtIndex:indexPath.row]) {
            vidData = [_VIDEOS_KECHUYEN objectAtIndex:indexPath.row];
            }
            break;
        case 3:
            if ([_VIDEOS_HOATHINH objectAtIndex:indexPath.row]) {
            vidData = [_VIDEOS_HOATHINH objectAtIndex:indexPath.row];
            }
            break;
        default:
            if ([_VIDEOS_SEARCH_RESULTS objectAtIndex:indexPath.row]) {
             vidData = [_VIDEOS_SEARCH_RESULTS objectAtIndex:indexPath.row];
            }
            break;
    }

    NSString *videoID= [vidData getYouTubeId];
    if ((videoID)&&(vidData)) {
         [self.playerView loadWithVideoId:videoID playerVars:playerVars];
        
        [self.titleVideoPlaying setText:vidData.getTitle];
        // durationOfCurrentVideoPlaying = vidData.getDuration;
        
        [self buttonPressed:self.playButton];
        // status button when click play
        [self.playButton setSelected:YES ];
        
        
        [self buttonPressed:self.ViewUpDownbtn];
        [self saveToDBWhenClick:vidData];

    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView==self.mListVideo) {
    mVideoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"mVideoCell" bundle:nil] forCellReuseIdentifier:@"videoCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
     
    }
    
    FavoriteVideoDetail *vData = [[super mFavoriteVideos] objectAtIndex:indexPath.row];
        cell.titleLabel.trailingBuffer = cell.titleLabel.frame.size.width;
        cell.titleLabel.text = vData.videoName;
        NSLog([NSString stringWithFormat:@" %f ", cell.frame.size.width]);
        NSLog([NSString stringWithFormat:@" %f ", cell.titleLabel.frame.size.width]);
        if (![[Utils humanReadableFromYouTubeTime:vData.videoDuration] isEqualToString:@"(Unknown)"]) {
            [cell.descriptionLabel setHidden:NO];
            cell.descriptionLabel.text =[Utils humanReadableFromYouTubeTime:vData.videoDuration];
        } else {
             [cell.descriptionLabel setHidden:YES];
        }

    NSURL *url = [NSURL URLWithString:vData.thumnailUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"play_on.png"];

    [cell.backgroundImage setImageWithURLRequest:request
                                  placeholderImage:placeholderImage
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               
                                               NSLog(@"image download: %f %f",image.size.width,image.size.height);
                                               NSLog(@"cell sizde: %f %f",cell.backgroundImage.frame.size.width,cell.backgroundImage.frame.size.height);
                                               
                                               UIGraphicsBeginImageContext(CGSizeMake(cell.backgroundImage.frame.size.width,cell.backgroundImage.frame.size.height
                                                                                      ));
                                               //vData.fullImage = image;
                                               [ image drawInRect:
                                                CGRectMake(0, 0, cell.backgroundImage.frame.size.width,cell.backgroundImage.frame.size.height)];
                                               UIImage *tmpImage = [[UIImage alloc]init];
                                               tmpImage = UIGraphicsGetImageFromCurrentImageContext();
                                               UIGraphicsEndImageContext();
                                               
                                               [cell.backgroundImage setImage:tmpImage];
                                               //cellScroll.thumnailImg.image = image;
                                               [cell.backgroundImage setNeedsLayout];
                                               
                                           } failure:nil];
       return cell;
    } else {
        tblCellMenu * cell = [tableView dequeueReusableCellWithIdentifier:@"tblCellMenuID"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"tblCellMenu" bundle:nil] forCellReuseIdentifier:@"tblCellMenuID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"tblCellMenuID"];
            
        }
        [cell.titleItemOfMenu setTextColor:[UIColor blackColor]];
        cell.titleItemOfMenu.text = [mMenuItems objectAtIndex:indexPath.row];
        NSLog( [mMenuItems objectAtIndex:indexPath.row]);
        return cell;
    }

}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==self.tbvMenu)
    {
        return self.MenuView.frame.size.height/10;
    } else {
        return 1;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView==self.tbvMenu)
    {
    UILabel *lbl = [[UILabel alloc] init];
    //[lbl setFrame:CGRectMake(0, 0, self.MenuView.frame.size.width, self.MenuView.frame.size.height/10)];
    lbl.textAlignment = UITextAlignmentCenter;
    //lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    lbl.text = @"MENU";
    lbl.textColor = [UIColor blackColor];
    lbl.shadowColor = [UIColor grayColor];
    lbl.shadowOffset = CGSizeMake(0,1);
  //  lbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"my_head_bg"]];
    lbl.alpha =1;
    return lbl;
    }
    else {
        UIView *headerView = [[UIView alloc]init];
        [ headerView setFrame:CGRectMake(0, 0, 0, 0)];
        return headerView;
    };
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    return view;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==self.mListVideo) {
        return [[super mFavoriteVideos] count];
    } else {
        return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==self.mListVideo) {
        return self.mListVideo.frame.size.width*85/100;
    } else {
        return self.view.frame.size.height/10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (tableView == self.mListVideo) {
         FavoriteVideoDetail *vidData = [[super mFavoriteVideos] objectAtIndex:indexPath.row];
        NSString *videoID= vidData.videoId;
        if ((videoID)&&(vidData)) {
            [self.playerView loadWithVideoId:videoID playerVars:playerVars];
            
            [self.titleVideoPlaying setText:vidData.videoName];
            [self buttonPressed:self.playButton];
            // status button when click play
            [self.playButton setSelected:YES ];
            [self buttonPressed:self.ViewUpDownbtn];
           
            
        }
    } else {
        switch (indexPath.row) {
            case 0:
                //
                
                break;
            case 1:
                break;
            case 2:
                
                 [[self navigationController] pushViewController:mVCAbout animated:YES];
                break;
            default:
                break;
        }
    
    }
    
}
- (void) saveToDBWhenClick : (VideoData*) vData{
    NSDictionary *mDic= @{@"videoId": vData.getYouTubeId,
                          @"videoName": vData.getTitle,
                          @"videoDesription": @"",
                          @"videoDuration": vData.getDuration,
                          @"thumnailUrl":vData.getThumbUri,
                          @"position":@(0),
                          @"deleted":@"FALSE",
                          };
    
    FavoriteVideoDetail *mFavoriteItem = [[FavoriteVideoDetail alloc]initWithDictionary:mDic];
    if ([self saveToFavorite:mFavoriteItem]) {
        if ([self loadAllFavoriteVideosFromDB]) {
            [self.mListVideo reloadData];
        }
    }

}
- (void) hideSeekingView {
    [self.viewButonSeeking setAlpha:1];
    [UIView animateWithDuration:1.f animations:^{
        //[self.view layoutIfNeeded];
        [self.viewButonSeeking setAlpha:0];
    }];
}
- (IBAction)buttonPlayerViewFace:(id)sender{
    if (sender == self.playerViewFace)
    {
        [self.viewButonSeeking setAlpha:0];
        [UIView animateWithDuration:1.f animations:^{
        [self.viewButonSeeking setAlpha:1];
        }];
        NSTimer *timerSeekingView =  [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(hideSeekingView) userInfo:nil repeats:NO];

    } else if (sender == self.playButton) {
        if (self.playButton.isSelected) {
            [self.playerView pauseVideo];
            [self.playButton setSelected:NO];
            
        } else {
            [self.playButton setSelected:YES];
            //  [[NSNotificationCenter defaultCenter] postNotificationName:@"Playback started" object:self];
            [self.playerView playVideo];
        }
  }
}
- (IBAction)setProgress:(UISlider *)sender {
   // self.progressBar.progress = [sender value];
    NSLog(@"%f",[sender value]);
    if ([self.playerView currentTime]>0)
    [self.playerView seekToSeconds:([sender value]*[self.playerView duration]) allowSeekAhead:YES];
}
- (void) HideMenuView {
    self.trailingOfMenuView.constant =  -(self.MenuView.frame.size.width);
    NSLog(@"%f," ,self.ViewListTable.frame.size.width);
     [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:1.f animations:^{
        [self.view layoutIfNeeded];
        
    }];
}
- (void) ShowMenuView {
    self.trailingOfMenuView.constant = 0;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:1.f animations:^{
        [self.view layoutIfNeeded];
        
    }];
}

- (IBAction)buttonPressed:(id)sender {

 if (sender == self.ViewUpDownbtn) {
      //[self appendStatusText:@"Loading previous video in playlist\n"];
      if (!self.ViewUpDownbtn.isSelected) {
          [self.ViewUpDownbtn setSelected:YES];
          [self hideViewScroll];
          
      } else {
          [self.ViewUpDownbtn setSelected:NO];
          [self ShowViewScroll];

      }
      
       }
  else  if (sender == self.btnSearch) {
      if ([self.searchBarView isHidden]) {
          [self.searchBarView setHidden:NO];
          _tap.enabled = YES;
      } else {
          if ([self.currentTextInSearchBar isEqualToString:@""]) {
          [self searchBarSearchButtonClicked:self.searchBarView];
          [self keyboardDisAppearOrShow];
          [self.searchBarView setHidden:YES];
          //_tap.enabled = NO;
          }
      }
  } else  if (sender == self.btnMenu) {
      if (self.btnMenu.isSelected) {
          [self.btnMenu setSelected:NO];
          [self HideMenuView];
         
          
      } else {
          [self.btnMenu setSelected:YES];
          //[self.tbvMenu reloadData];
           [self ShowMenuView];
          
      }

  }
      else
      if ([mPlayLists count]>0) {
         if (sender==self.btnAmNhac) {
                  flag=1;
                  if ([_VIDEOS_AMNHAC count]< 1) {
                       NSString *playListIdTmp=( (PlayListModel*)[mPlayLists objectAtIndex:0]).playListId;
                      [self.getVideos getYouTubeVideosWithService:self.youtubeService:playListIdTmp];
                  } else {
                      [self.listViewColectionView  reloadData];
                  }
            [self setSizeBtnTheLoaiWhenClick:sender];
      } else if (sender==self.btnKeChuyen) {
                  flag=2;
                  if ([_VIDEOS_KECHUYEN count]< 1) {
                      NSString *playListIdTmp=( (PlayListModel*)[mPlayLists objectAtIndex:1]).playListId;
                      [self.getVideos getYouTubeVideosWithService:self.youtubeService:playListIdTmp];
                  }else {
                      [self.listViewColectionView  reloadData];
                  }
              [self setSizeBtnTheLoaiWhenClick:sender];
      } else if (sender==self.btnHoatHinh) {
                  flag=3;
                  if ([_VIDEOS_HOATHINH count]< 1) {
                      NSString *playListIdTmp=( (PlayListModel*)[mPlayLists objectAtIndex:2]).playListId;
                      [self.getVideos getYouTubeVideosWithService:self.youtubeService:playListIdTmp];
                  }else {
                      [self.listViewColectionView  reloadData];
                  }
               [self setSizeBtnTheLoaiWhenClick:sender];
      }
   } // chheck mPlayList
  
    
}
- (void) setSizeBtnTheLoaiWhenClick : (id)sender {

    if (sender==self.btnAmNhac) {
        self.widthAmNhac.constant=50;
        self.bottomAmNhac.constant=0;
        self.withOfKeChuyen.constant=40;
        self.bottonKeChuyen.constant=10;
        self.widthHoatHinh.constant=40;
        self.bottomHoatHInh.constant=10;
        self.leadingAmNhac.constant=0;
        self.trailingHoatHinh.constant=5;
    } else if (sender==self.btnKeChuyen) {
        self.widthAmNhac.constant=40;
        self.bottomAmNhac.constant=10;
        self.withOfKeChuyen.constant=50;
        self.bottonKeChuyen.constant=0;
        self.widthHoatHinh.constant=40;
        self.bottomHoatHInh.constant=10;
    } else {
        self.widthAmNhac.constant=40;
        self.bottomAmNhac.constant=10;
        self.withOfKeChuyen.constant=40;
        self.bottonKeChuyen.constant=10;
        self.widthHoatHinh.constant=50;
        self.bottomHoatHInh.constant=0;
        self.trailingHoatHinh.constant=0;
        self.leadingAmNhac.constant=5;
    }
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:1.f animations:^{
        [self.view layoutIfNeeded];
        
    }];
}
- (void) hideViewScroll {
    self.bottomSpaceListVideo.constant = self.view.frame.size.height;
   
    self.heighButtonTheLoai.constant = 0;
    [self.ViewListCollection setAlpha:1];
    //self.bottomSpaceListVideo.constant -= self.view.frame.size.height;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:1.f animations:^{
        [self.view layoutIfNeeded];
        [self.ViewListCollection setAlpha:0];
    }];

}
- (void) ShowViewScroll {
   // self.topSpaceListVideo.constant = 50;
    self.bottomSpaceListVideo.constant = self.btnMenu.frame.size.height+5;
     self.heighButtonTheLoai.constant = 60;
    //[self.ViewListCollection setAlpha:0];
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:1.f animations:^{
        [self.ViewListCollection setAlpha:1];
        [self.view layoutIfNeeded];
        
    }];
}
// Helper to check if user is authorized
- (BOOL)isAuthorized {
    return [((GTMOAuth2Authentication *)self.youtubeService.authorizer) canAuthorize];
}

// Creates the auth controller for authorizing access to YouTube.
- (GTMOAuth2ViewControllerTouch *)createAuthController
{
    GTMOAuth2ViewControllerTouch *authController;
    
    authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeYouTube
                                                                clientID:kClientID
                                                            clientSecret:kClientSecret
                                                        keychainItemName:kKeychainItemName
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

// Handle completion of the authorization process, and updates the YouTube service
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    if (error != nil) {
        [Utils showAlert:@"Authentication Error" message:error.localizedDescription];
        self.youtubeService.authorizer = nil;
    } else {
        self.youtubeService.authorizer = authResult;
        //[self isAuthorized];
        [self viewDidLoad];
       // [self.getVideos getYouTubeVideosWithService:self.youtubeService];

    }
}

- (void)receivedPlaybackStartedNotification:(NSNotification *) notification {
//  if([notification.name isEqual:@"Playback started"] && notification.object != self) {
//      [self.playerViewFace setHidden:NO];
//      [self.playButton setSelected:YES];
//      [self.playerView playVideo];
      //[self.playerView setHidden:NO];
  
}


@end