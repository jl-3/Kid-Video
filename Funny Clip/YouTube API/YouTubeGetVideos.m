//
//  YouTubeGetVideos.m
//  YouTube Direct Lite for iOS
//
//  Created by Ibrahim Ulukaya on 10/29/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import "YouTubeGetVideos.h"
#import "VideoData.h"
//#import "MainViewController.h"

// Thumbnail image size.


@implementation YouTubeGetVideos

// type 0: seaerch, 1: nextpage , 2 prvpage
- (void)searchYouTubeVideosWithService:(GTLServiceYouTube *)service : (NSString *)searchKey :  (NSString *)nextPageToken :(NSString *)prvPageToken : (int) type {
    if ((!searchKey)&&(!nextPageToken)&&(!prvPageToken))  {
        [self.delegate getYouTubeVideos:self didFinishWithResults:nil:nil:nil:TYPE_OF_RESULT_NORMAL];
        return;
    }
    GTLQueryYouTube *playlistItemsListQuery = [GTLQueryYouTube queryForSearchListWithPart:@"snippet"];
    playlistItemsListQuery.maxResults = 20l;
    if (searchKey)
    playlistItemsListQuery.q=searchKey;
    switch (type) {
        case IS_SEARCH_NEXT_PAGE:
            playlistItemsListQuery.pageToken= nextPageToken;
            
            break;
        case IS_SEARCH_PRV_PAGE:
            playlistItemsListQuery.pageToken= prvPageToken;
            break;
        default:
            break;
    }
    // This callback uses the block syntax
    
    [service executeQuery:playlistItemsListQuery
     
        completionHandler:^(GTLServiceTicket *ticket, GTLCollectionObject
                            
                            *response, NSError *error) {
            
            if (error) {
                [self.delegate getYouTubeVideos:self didFinishWithResults:nil:nil:nil:TYPE_OF_RESULT_NORMAL];
                return;
            }
            NSString * nextPage ;
            NSString * prvPage ;
            response = (GTLYouTubeSearchListResponse *) response;
            NSLog(@"Finished API call");
            nextPage = [response JSONValueForKey:@"nextPageToken"];
            prvPage = [response JSONValueForKey:@"prevPageToken"];
            NSMutableArray *videoIds = [NSMutableArray arrayWithCapacity:response.items.count];
            
            for (GTLYouTubeSearchResult *videoItem in response.items) {
                
                GTLYouTubeVideo *tmpId= (GTLYouTubeVideo*) videoItem.identifier;
                // return tmpId.;
                //  NSDictionary *mDic = [NSDictionary dictionaryWithObject:tmpId forKey:@"videoId"];
                if ([tmpId  JSONValueForKey:@"videoId"]) {
                NSLog([ tmpId  JSONValueForKey:@"videoId"] );
                //return [ tmpId  JSONValueForKey:@"videoId"] ;
                
                [videoIds addObject:[tmpId  JSONValueForKey:@"videoId"]];
                }
            }
            
            GTLQueryYouTube *videosListQuery = [GTLQueryYouTube queryForVideosListWithPart:@"id,contentDetails,snippet,status,statistics"];
            videosListQuery.identifier = [videoIds componentsJoinedByString: @","];
            
            
            [service executeQuery:videosListQuery
             
                completionHandler:^(GTLServiceTicket *ticket, GTLYouTubeVideoListResponse
                                    
                                    *response, NSError *error) {
                    if (error) {
                        [self.delegate getYouTubeVideos:self didFinishWithResults:nil:nil:nil:TYPE_OF_RESULT_NORMAL];
                        return;
                    }
                    
                    NSLog(@"Finished API call");
                    NSMutableArray *videos = [NSMutableArray arrayWithCapacity:response.items.count];
                    VideoData *vData;
                    
                    for (GTLYouTubeVideo *video in response.items){
                        if ([@"public" isEqualToString:video.status.privacyStatus]){
                            vData = [VideoData alloc];
                            vData.video = video;
                            [videos addObject:vData];
                        }
                    }
                    if (playlistItemsListQuery.pageToken) {
                        // Please check is case: get prv page
                        [self.delegate getYouTubeVideos:self didFinishWithResults:videos:nextPage:prvPage:TYPE_OF_RESULT_NEXT_PAGE];
                    } else {
                        [self.delegate getYouTubeVideos:self didFinishWithResults:videos:nextPage:prvPage:TYPE_OF_RESULT_NORMAL];
                    }
                    
                }];
        }];
    
}

- (void)getYouTubeVideosWithService:(GTLServiceYouTube *)service : (NSString *)playListId :  (NSString *)nextPageToken : (NSString *)prvPageToken : (int) type {
    // Construct query

    if (!playListId)  {
        [self.delegate getYouTubeVideos:self didFinishWithResults:nil:nil:nil:TYPE_OF_RESULT_NORMAL];
        return;
    }
                GTLQueryYouTube *playlistItemsListQuery = [GTLQueryYouTube queryForPlaylistItemsListWithPart:@"contentDetails"];
                    switch (type) {
                        case IS_GET_NEXT_PAGE:
                            if (nextPageToken)
                            playlistItemsListQuery.pageToken= nextPageToken;
                            else {
                                    [self.delegate getYouTubeVideos:self didFinishWithResults:nil:nil:nil:TYPE_OF_RESULT_NORMAL];
                                    return;
                            }
                            break;
                        case IS_GET_PRV_PAGE:
                            playlistItemsListQuery.pageToken= prvPageToken;
                            break;
                        default:
                            break;
                    }
                playlistItemsListQuery.maxResults = 20l;
                playlistItemsListQuery.playlistId =  playListId;
                
                // This callback uses the block syntax
                
                [service executeQuery:playlistItemsListQuery
                 
                    completionHandler:^(GTLServiceTicket *ticket, GTLYouTubePlaylistItemListResponse
                                        
                                        *response, NSError *error) {
                        
                        if (error) {
                            [self.delegate getYouTubeVideos:self didFinishWithResults:nil:nil:nil:TYPE_OF_RESULT_NORMAL];
                            return;
                        }
                        
                        NSLog(@"Finished API call");
                      
                        NSString * nextPage ;
                        NSString * prvPage ;
                        nextPage = [response JSONValueForKey:@"nextPageToken"];
                        prvPage = [response JSONValueForKey:@"prevPageToken"];
                        NSMutableArray *videoIds = [NSMutableArray arrayWithCapacity:response.items.count];
                        
                        for (GTLYouTubePlaylistItem *playlistItem in response.items) {
                            
                            [videoIds addObject:playlistItem.contentDetails.videoId];
                            
                        }
                        
                        GTLQueryYouTube *videosListQuery = [GTLQueryYouTube queryForVideosListWithPart:@"id,contentDetails,snippet,status,statistics"];
                        videosListQuery.identifier = [videoIds componentsJoinedByString: @","];
                        
                        
                        [service executeQuery:videosListQuery
                         
                            completionHandler:^(GTLServiceTicket *ticket, GTLYouTubeVideoListResponse
                                                
                                                *response, NSError *error) {
                                if (error) {
                                    [self.delegate getYouTubeVideos:self didFinishWithResults:nil:nil:nil:TYPE_OF_RESULT_NORMAL];
                                    return;
                                }
                                
                                NSLog(@"Finished API call");
                                NSMutableArray *videos = [NSMutableArray arrayWithCapacity:response.items.count];
                                VideoData *vData;
                                
                                for (GTLYouTubeVideo *video in response.items){
                                    if ([@"public" isEqualToString:video.status.privacyStatus]){
                                        vData = [VideoData alloc];
                                        vData.video = video;
                                        [videos addObject:vData];
                                    }
                                }
                                
                                if (playlistItemsListQuery.pageToken) {
                                    [self.delegate getYouTubeVideos:self didFinishWithResults:videos:nextPage:prvPage:TYPE_OF_RESULT_NEXT_PAGE];
                                } else {
                                    [self.delegate getYouTubeVideos:self didFinishWithResults:videos:nextPage:prvPage:IS_GET_NORMAL_PAGE];
                                }
                                
                            }];
                    }];

}

@end
