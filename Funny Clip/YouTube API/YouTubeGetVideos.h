//
//  YouTubeGetVideos.h
//  YouTube Direct Lite for iOS
//
//  Created by Ibrahim Ulukaya on 10/29/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTLYouTube.h"
#import "BaseUtils.h"
@protocol YouTubeGetVideosDelegate;

@interface YouTubeGetVideos : NSObject

@property(nonatomic, weak) id<YouTubeGetVideosDelegate> delegate;

// Performs a G+ image search with the given query, will return
// by calling googlePlusImageSearch:didFinishWithResults: when completed.
- (void)getYouTubeVideosWithService:(GTLServiceYouTube *)service : (NSString *)playListId :  (NSString *)nextPageToken : (NSString *)prvPageToken : (int) type;
- (void)getYouTubeFavoriteVideosWithService:(GTLServiceYouTube *)service : (NSString *)playListId ;
// search

- (void)searchYouTubeVideosWithService:(GTLServiceYouTube *)service : (NSString *)searchKey :  (NSString *)nextPageToken : (NSString *)prvPageToken : (int) type;
@end


// Delegate protocol for returning results from the Image Search API.
@protocol YouTubeGetVideosDelegate<NSObject>

// Called when an image search completes. |results| will contain
// an array of NSDictionary containing keys for @"fullImage", @"thumbnail",
// @"author" and @"title".

//typeOFResult:
// 1: loadmore,
// 0: Non-loadmore
- (void)getYouTubeVideos:(YouTubeGetVideos *)getVideos
    didFinishWithResults:(NSArray *)results : (NSString *)nextPageToken : (NSString *)prvPageToken : (int) typeOfResult;
- (void)getYouTubeFavoriteVideos:(YouTubeGetVideos *)getVideos didFinishWithResults:(NSArray *)results;
@end
