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
// Thumbnail image size.

@implementation PlaylistViewController
@synthesize youtubeService;

- (id)init
{
    self = [super init];
    if (self) {
        _getVideos = [[YouTubeGetVideos alloc] init];
        _getVideos.delegate = self;
        _videos = [[NSArray alloc] init];
    }
    return self;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self.playerView setBackgroundColor:[UIColor blackColor]];
   // [self.playerView setHidden:NO];
      [self.getVideos getYouTubeVideosWithService:self.youtubeService];
    [self.listViewColectionView setAlpha:0.9f];

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
    self.videos = results;
  //  [self.tableView reloadData];
    [self.listViewColectionView reloadData];
      [self.mListVideo reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeLeft] forKey:@"orientation"];
     // [self.playerView setHidden:YES];
  
    [self init];
    self.youtubeService = [[GTLServiceYouTube alloc] init];
    self.youtubeService.authorizer =
    [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                          clientID:kClientID
                                                      clientSecret:kClientSecret];
    if (![self isAuthorized]) {
        // Not yet authorized, request authorization and push the login UI onto the navigation stack.
        [[self navigationController] pushViewController:[self createAuthController] animated:YES];
    }

  
    self.listViewColectionView.bounces =NO ;
    [self.navigationController setNavigationBarHidden:YES];
    NSString* videoID = @"9IHb4PBrxYQ";
    [self.playButton setImage:[UIImage imageNamed:@"stop_on.png"] forState:UIControlStateSelected];
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

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(receivedPlaybackStartedNotification:)
                                               name:@"Playback started"
                                             object:nil];
    

      
    
  }

- (void) showVideos {
    
    [self.listViewColectionView reloadData];
    
}
#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
 [view registerNib:[UINib nibWithNibName:@"VideoItemCollectCell" bundle:nil] forCellWithReuseIdentifier:@"collectCell"];
    return [self.videos count];

}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.listViewColectionView.frame.size.width/3-8, (self.listViewColectionView.frame.size.width/3-10));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    VideoItemCollectCell *cellScroll = [cv dequeueReusableCellWithReuseIdentifier:@"collectCell" forIndexPath:indexPath];
    if (!cellScroll)
    {
        [cv registerNib:[UINib nibWithNibName:@"VideoItemCollectCell" bundle:nil] forCellWithReuseIdentifier:@"collectCell"];
        cellScroll= [cv dequeueReusableCellWithReuseIdentifier:@"collectCell" forIndexPath:indexPath];
    }

    VideoData *vData = [self.videos objectAtIndex:indexPath.row];
   // cellScroll.thumnailImg.image = vidData.thumbnail;
   cellScroll.titleLbl.text = [vData getTitle];
    
      NSURL *url = [NSURL URLWithString:vData.getThumbUri];
 
       NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"play_on.png"];
    
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


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
   VideoData *vidData = [self.videos objectAtIndex:indexPath.row];
    NSString *videoID= [vidData getYouTubeId];
    if (vidData) {
         [self.playerView loadWithVideoId:videoID playerVars:playerVars];
         //[self.playerView playVideo];
         [self buttonPressed:self.playButton];
        [self buttonPressed:self.ViewUpDownbtn];
    }
   

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    mVideoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"mVideoCell" bundle:nil] forCellReuseIdentifier:@"videoCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
     
    }

    //VideoData *vidData = [self.videos objectAtIndex:indexPath.row];
    //cell.backgroundImage.image = vidData.thumbnail;
    
    VideoData *vData = [self.videos objectAtIndex:indexPath.row];
    cell.titleLabel.text = [vData getTitle];
//    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@ -- %@ views",
//                                  [Utils humanReadableFromYouTubeTime:vData.getDuration],
//                                  vData.getViews];
    cell.descriptionLabel.text =[Utils humanReadableFromYouTubeTime:vData.getDuration];
    // cellScroll.thumnailImg.image = vidData.thumbnail;
    //cellScroll.titleLbl.text = [vData getTitle];
    
    NSURL *url = [NSURL URLWithString:vData.getThumbUri];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"play_on.png"];
    
    // __weak UITableViewCell *weakCell = cell;
    
    [cell.backgroundImage setImageWithURLRequest:request
                                  placeholderImage:placeholderImage
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               
                                               NSLog(@"image download: %f %f",image.size.width,image.size.height);
                                               NSLog(@"cell sizde: %f %f",cell.backgroundImage.frame.size.width,cell.backgroundImage.frame.size.height);
                                               
                                               UIGraphicsBeginImageContext(CGSizeMake(cell.backgroundImage.frame.size.width,cell.backgroundImage.frame.size.height
                                                                                      ));
                                               vData.fullImage = image;
                                               [ image drawInRect:
                                                CGRectMake(0, 0, cell.backgroundImage.frame.size.width,cell.backgroundImage.frame.size.height)];
                                               vData.thumbnail = UIGraphicsGetImageFromCurrentImageContext();
                                               UIGraphicsEndImageContext();
                                               
                                               [cell.backgroundImage setImage:vData.thumbnail];
                                               //cellScroll.thumnailImg.image = image;
                                               [cell.backgroundImage setNeedsLayout];
                                               
                                           } failure:nil];

    
    return cell;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return self.mListVideo.frame.size.width;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoData *vData = [self.videos objectAtIndex:indexPath.row];
    NSDictionary *mDic= @{@"videoId": vData.getYouTubeId};
    FavoriteVideoDetail *mFavoriteItem = [[FavoriteVideoDetail alloc]initWithDictionary:mDic];
    [self saveToFavorite:mFavoriteItem];
    
}
- (IBAction)buttonPressed:(id)sender {
  //  [self.playerView setHidden:NO];

    if (sender == self.playButton) {
      if (self.playButton.isSelected) {
          [self.playerView pauseVideo];
          [self.playButton setSelected:NO];

      } else {
          [self.playButton setSelected:YES];
      //  [[NSNotificationCenter defaultCenter] postNotificationName:@"Playback started" object:self];
          [self.playerView playVideo];
      }
  } else if (sender == self.nextVideoButton) {
    //[self appendStatusText:@"Loading next video in playlist\n"];
    [self.playerView nextVideo];
  } else if (sender == self.previousVideoButton) {
    //[self appendStatusText:@"Loading previous video in playlist\n"];
    [self.playerView previousVideo];
  }else if (sender == self.ViewUpDownbtn) {
      //[self appendStatusText:@"Loading previous video in playlist\n"];
      if (!self.ViewUpDownbtn.isSelected) {
          [self.ViewUpDownbtn setSelected:YES];
          [self hideViewScroll];
          //self.moveBannerOffScreen;
          
      } else {
          [self.ViewUpDownbtn setSelected:NO];
          [self ShowViewScroll];

      }
      
       }
}

- (void) hideViewScroll {
    self.bottomSpaceListVideo.constant = self.view.frame.size.height;
   //  self.topSpaceListVideo.constant = self.view.frame.size.height;
    
    //self.bottomSpaceListVideo.constant -= self.view.frame.size.height;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:1.f animations:^{
        [self.view layoutIfNeeded];
    }];

}
- (void) ShowViewScroll {
   // self.topSpaceListVideo.constant = 50;
    self.bottomSpaceListVideo.constant = 60;;
   // self.bottomSpaceListVideo.constant=0;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:1.f animations:^{
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
        [self.getVideos getYouTubeVideosWithService:self.youtubeService];

    }
}

- (void)receivedPlaybackStartedNotification:(NSNotification *) notification {
  if([notification.name isEqual:@"Playback started"] && notification.object != self) {
    //[self.playerView pauseVideo];
      //[self.playerView setHidden:NO];
  }
}


@end