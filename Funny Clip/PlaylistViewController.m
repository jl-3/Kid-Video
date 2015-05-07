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
        VIDEOS_AMNHAC = [[NSArray alloc] init];
        VIDEOS_KECHUYEN = [[NSArray alloc] init];
        VIDEOS_HOATHINH = [[NSArray alloc] init];
        VIDEOS_SEARCH_RESULTS = [[NSArray alloc] init];
        
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

- (void)getYouTubeVideos:(YouTubeGetVideos *)getVideos didFinishWithResults:(NSArray *)results : (NSString*) nextPageTokenThis : (NSString *) prvPageTokenThis : (int ) typeOfResultThis {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    switch (flag) {
        case 1:
            if (typeOfResultThis == 0)
                VIDEOS_AMNHAC = [results mutableCopy];
            else [VIDEOS_AMNHAC addObjectsFromArray:results];
            break;
        case 2:
            if (typeOfResultThis == 0)
                VIDEOS_KECHUYEN = [results mutableCopy];
            else [VIDEOS_KECHUYEN addObjectsFromArray:results];
            break;
        case 3:
            if (typeOfResultThis == 0)
              VIDEOS_HOATHINH = [results mutableCopy];
            else [VIDEOS_HOATHINH addObjectsFromArray:results];
            break;
        default:
            if (typeOfResultThis == 0)
            VIDEOS_SEARCH_RESULTS = [results mutableCopy];
            else [VIDEOS_SEARCH_RESULTS addObjectsFromArray:results];
            break;
    }
    //[self.ViewListCollection setHidden:NO];
    [self resetStatusLoadPage];
    if (nextPageTokenThis) nextPageToken = nextPageTokenThis;
    if (prvPageTokenThis) prvPageTokenThis = prvPageTokenThis;
   isLoadFinish=YES;
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
    // self.listViewColectionView.bounces =NO ;
    [self.navigationController setNavigationBarHidden:YES];
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"icon_play_black.png"] forState:UIControlStateNormal];
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"icon_pause_black.png"] forState:UIControlStateSelected];
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
            tmpObject= [self objectAtIndex:tmpArray:i];
            // NSLog([tmpObject valueForKey:@"playListId"]);
            if (tmpObject) {
            PlayListModel *mPlayListModel = [PlayListModel PlayListWithDictionary:
                                             @{ @"playListId":[tmpObject valueForKey:@"playListId"],
                                                @"playListName":[tmpObject valueForKey:@"playListName"],
                                                
                                                
                                                }];
            [mPlayLists  addObject:mPlayListModel];
            }
        }
        NSString *playListIdTmp=( (PlayListModel*)[self objectAtIndex:mPlayLists :0]).playListId;
        [self.getVideos getYouTubeVideosWithService:self.youtubeService:playListIdTmp: nextPageToken : prevPageToken : 0];
        
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
        [self resetStatusLoadPage];
        [self.getVideos searchYouTubeVideosWithService:self.youtubeService:searchBar.text : nextPageToken : prevPageToken : 0];
    }
}
- (void) resetStatusLoadPage {
    nextPageToken = nil;
    prevPageToken = nil;
}
#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    [view registerNib:[UINib nibWithNibName:@"VideoItemCollectCell" bundle:nil] forCellWithReuseIdentifier:@"collectCell"];
    NSInteger numberOf=0;
    switch (flag) {
        case 1:
            numberOf= [VIDEOS_AMNHAC count];
            break;
        case 2:
            numberOf= [VIDEOS_KECHUYEN count];
            break;
        case 3:
            numberOf= [VIDEOS_HOATHINH count];
            break;
        default:
            numberOf= [VIDEOS_SEARCH_RESULTS count];
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
            vData = [ self objectAtIndex: VIDEOS_AMNHAC :indexPath.row];
            break;
        case 2:
            vData = [ self objectAtIndex: VIDEOS_KECHUYEN :indexPath.row];
            break;
        case 3:
            vData = [ self objectAtIndex: VIDEOS_HOATHINH :indexPath.row];
            break;
        default:
            vData = [ self objectAtIndex: VIDEOS_SEARCH_RESULTS :indexPath.row];
            break;
    }
    if (!vData) return
        cellScroll;
    cellScroll.titleLbl.trailingBuffer = cellScroll.frame.size.width;
    cellScroll.titleLbl.text = [vData getTitle];
    cellScroll.descriptionLb.text = [Utils humanReadableFromYouTubeTime:vData.getDuration];
    if ([cellScroll.descriptionLb.text isEqualToString:@"(Unknown)"])
        [cellScroll.descriptionLb setHidden:YES];
    else [cellScroll.descriptionLb setHidden:NO];
    NSURL *url = [NSURL URLWithString:vData.getThumbUri];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"bg_loading.png"];
    
    // __weak UITableViewCell *weakCell = cell;
    
    [cellScroll.thumnailImg setImageWithURLRequest:request
                                  placeholderImage:placeholderImage
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               
                                             //  NSLog(@"image download: %f %f",image.size.width,image.size.height);
                                             //  NSLog(@"cell sizde: %f %f",cellScroll.thumnailImg.frame.size.width,cellScroll.thumnailImg.frame.size.height);
                                               
//                                               UIGraphicsBeginImageContext(CGSizeMake(cellScroll.thumnailImg.frame.size.width,cellScroll.thumnailImg.frame.size.height
//                                                                                      ));
                                               vData.fullImage = image;
//                                               [ image drawInRect:
//                                                CGRectMake(0, 0, cellScroll.thumnailImg.frame.size.width,cellScroll.thumnailImg.frame.size.height)];
//                                               vData.thumbnail = UIGraphicsGetImageFromCurrentImageContext();
//                                               UIGraphicsEndImageContext();
                                               
                                               [cellScroll.thumnailImg setImage:vData.fullImage];
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
           vidData = [ self objectAtIndex: VIDEOS_AMNHAC :indexPath.row];
            
            break;
        case 2:
    
            vidData = [ self objectAtIndex: VIDEOS_KECHUYEN :indexPath.row];
            
            break;
        case 3:
           
            vidData = [ self objectAtIndex: VIDEOS_HOATHINH :indexPath.row];
            
            break;
        default:
           
            vidData = [ self objectAtIndex: VIDEOS_SEARCH_RESULTS :indexPath.row];
            
            break;
    }
    if (!vidData) return ;
    if ([vidData getYouTubeId]) {
    NSString *videoID= [vidData getYouTubeId];
    if (videoID) {
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
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSString *playListId;
    if (flag <4) {
      playListId=( (PlayListModel*)[self objectAtIndex:mPlayLists :flag-1]).playListId;
      
    }
    if ((int)scrollView.contentOffset.y >= (int )scrollView.contentSize.height - (int)self.listViewColectionView.frame.size.height)
    {
        //[scrollView setScrollEnabled:NO];
       
        if (isLoadFinish)
        switch (flag) {
            case 4:
                if (VIDEOS_SEARCH_RESULTS.count<200) {
                [self.getVideos searchYouTubeVideosWithService:self.youtubeService:nil : nextPageToken : nil : 1];
                 isLoadFinish=NO;
                }
                break;
            
            default:
                switch (flag) {
                    case 1:
                        if (VIDEOS_AMNHAC.count>200) break;
                        else [self.getVideos getYouTubeVideosWithService:self.youtubeService:playListId: nextPageToken : prevPageToken : 1];
                        break;
                    case 2:
                        if (VIDEOS_KECHUYEN.count>200) break;
                        else [self.getVideos getYouTubeVideosWithService:self.youtubeService:playListId: nextPageToken : prevPageToken : 1];
                        break;
                    case 3:
                        if (VIDEOS_HOATHINH.count>200) break;
                        else
                            [self.getVideos getYouTubeVideosWithService:self.youtubeService:playListId: nextPageToken : prevPageToken : 1];
                        break;
                    default:
                        break;
                }

                 //[self.getVideos getYouTubeVideosWithService:self.youtubeService:playListId: nextPageToken : prevPageToken : 0];
                 isLoadFinish=NO;
                
                break;
        }
        
        
        //LOAD MORE
        // you can also add a isLoading bool value for better dealing :D
    }
    else {
        NSLog(@"%f",scrollView.contentOffset.y);
        NSLog(@"%f",scrollView.contentSize.height);
        NSLog(@"%f",self.listViewColectionView.frame.size.height);
    }
}



#pragma mark - UITableView Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==self.mListVideo) {
        mVideoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"mVideoCell" bundle:nil] forCellReuseIdentifier:@"videoCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
//                   [cell.leftImgTableVideo setConstant: cell.frame.size.width*41/395];
//                   [cell.topImgTableVideo setConstant: cell.frame.size.height*82/325];
            //[cell setNeedsUpdateConstraints];
        }
//        [cell.leftImgTableVideo setConstant: cell.frame.size.width*41/395];
//        [cell.topImgTableVideo setConstant: cell.frame.size.height*82/325];
//        [self.view setNeedsUpdateConstraints];
//        [self.view setNeedsLayout];
        
        //[cell setNeedsUpdateConstraints];
        FavoriteVideoDetail *vData = [self objectAtIndex: [super mFavoriteVideos] :indexPath.row] ;
        if (!vData) return cell;
        cell.titleLabel.trailingBuffer = cell.titleLabel.frame.size.width;
        cell.titleLabel.text = vData.videoName;
        NSLog([NSString stringWithFormat:@" width of cell table : %f ", cell.frame.size.width]);
        NSLog([NSString stringWithFormat:@" heigh of cell table : %f ", cell.frame.size.height]);
       // NSLog([NSString stringWithFormat:@" %f ", cell.titleLabel.frame.size.width]);
        if (![[Utils humanReadableFromYouTubeTime:vData.videoDuration] isEqualToString:@"(Unknown)"]) {
            [cell.descriptionLabel setHidden:NO];
            cell.descriptionLabel.text =[Utils humanReadableFromYouTubeTime:vData.videoDuration];
        } else {
            [cell.descriptionLabel setHidden:YES];
        }
               
         [cell setNeedsLayout];
        NSURL *url = [NSURL URLWithString:vData.thumnailUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"bg_loading.png"];
        
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
                                                 
                                                 [cell.backgroundImage setImage:image];
                                                 //cellScroll.thumnailImg.image = image;
//                                                 [self.view setNeedsUpdateConstraints];
//                                                 [self.view setNeedsLayout];
                                                //[cell.backgroundImage setNeedsLayout];
//                                                      [cell.superview setNeedsLayout];
                                                 
                                             } failure:nil];
//      [cell.superview setNeedsUpdateConstraints];
//        [cell.superview setNeedsLayout];
        return cell;
    } else {
        tblCellMenu * cell = [tableView dequeueReusableCellWithIdentifier:@"tblCellMenuID"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"tblCellMenu" bundle:nil] forCellReuseIdentifier:@"tblCellMenuID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"tblCellMenuID"];
            
        }
        
        
        [cell.titleItemOfMenu setTextColor:[UIColor blackColor]];
        cell.titleItemOfMenu.text = [self objectAtIndex:[mMenuItems mutableCopy] : indexPath.row];
        //NSLog( [mMenuItems objectAtIndex:indexPath.row]);
        return cell;
    }
    
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==self.tbvMenu)
    {
        return self.MenuView.frame.size.height/10;
    } else {
        return 5;
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
        NSLog(@"heightForRowAtIndexPath table video %f", tableView.frame.size.width);
       
        return tableView.frame.size.width-10;
       // return 100;
    } else {
        return self.view.frame.size.height/10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.mListVideo) {
        FavoriteVideoDetail *vidData = (FavoriteVideoDetail *)[ self objectAtIndex:[super mFavoriteVideos]:indexPath.row];
        if (!vidData) return ;
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
            [self.playButton setSelected:NO];
            [self.playerView pauseVideo];
            
            
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
                [self resetStatusLoadPage];
                if ([VIDEOS_AMNHAC count]< 1) {
                    NSString *playListIdTmp=( (PlayListModel*)[self objectAtIndex:mPlayLists :0]).playListId;
                    [self.getVideos getYouTubeVideosWithService:self.youtubeService:playListIdTmp: nextPageToken : prevPageToken : 0];
                } else {
                    [self.listViewColectionView  reloadData];
                }
                [self setSizeBtnTheLoaiWhenClick:sender];
            } else if (sender==self.btnKeChuyen) {
                flag=2;
                [self resetStatusLoadPage];
                if ([VIDEOS_KECHUYEN count]< 1) {
                    NSString *playListIdTmp=( (PlayListModel*)[self objectAtIndex:mPlayLists :1]).playListId;                   [self.getVideos getYouTubeVideosWithService:self.youtubeService:playListIdTmp: nextPageToken : prevPageToken : 0];
                }else {
                    [self.listViewColectionView  reloadData];
                }
                [self setSizeBtnTheLoaiWhenClick:sender];
            } else if (sender==self.btnHoatHinh) {
                flag=3;
                [self resetStatusLoadPage];
                if ([VIDEOS_HOATHINH count]< 1) {
                   NSString *playListIdTmp=( (PlayListModel*)[self objectAtIndex:mPlayLists :2]).playListId;
                    [self.getVideos getYouTubeVideosWithService:self.youtubeService:playListIdTmp: nextPageToken : prevPageToken : 0];
                }else {
                    [self.listViewColectionView  reloadData];
                }
                [self setSizeBtnTheLoaiWhenClick:sender];
            }
        } // chheck mPlayList
    
    
}
- (void) setSizeBtnTheLoaiWhenClick : (id)sender {
   
    float widthNomarl= 50;
    float widthSeleted= 60;
    float bottomNomarl= 10;
    float bottomSeleted= 0;
    float leading = 5;
    float trailing = 5;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        widthNomarl= 75;
        widthSeleted= 85;
//        bottomNomarl = 
//        bottomSeleted
        leading = 10;
        trailing = 10;
    }
    if (sender==self.btnAmNhac) {
        self.widthAmNhac.constant=widthSeleted;
        self.bottomAmNhac.constant=bottomSeleted;
        self.withOfKeChuyen.constant=widthNomarl;
        self.bottonKeChuyen.constant=bottomNomarl;
        self.widthHoatHinh.constant=widthNomarl;
        self.bottomHoatHInh.constant=bottomNomarl;
        self.leadingAmNhac.constant=bottomSeleted;
        self.trailingHoatHinh.constant=trailing;
    } else if (sender==self.btnKeChuyen) {
        self.widthAmNhac.constant=widthNomarl;
        self.bottomAmNhac.constant=bottomNomarl;
        self.withOfKeChuyen.constant=widthSeleted;
        self.bottonKeChuyen.constant=bottomSeleted;
        self.widthHoatHinh.constant=widthNomarl;
        self.bottomHoatHInh.constant=bottomNomarl;
    } else {
        self.widthAmNhac.constant=widthNomarl;
        self.bottomAmNhac.constant=bottomNomarl;
        self.withOfKeChuyen.constant=widthNomarl;
        self.bottonKeChuyen.constant=bottomNomarl;
        self.widthHoatHinh.constant=widthSeleted;
        self.bottomHoatHInh.constant=bottomSeleted;
        self.trailingHoatHinh.constant=bottomSeleted;
        self.leadingAmNhac.constant=leading;
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