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
   
    GTLQueryYouTube *playlistItemsListQuery = [GTLQueryYouTube queryForSearchListWithPart:@"snippet"];
    playlistItemsListQuery.maxResults = 20l;
    if (searchKey)
    playlistItemsListQuery.q=searchKey;
    switch (type) {
        case 1:
            playlistItemsListQuery.pageToken= nextPageToken;
            
            break;
        case 2:
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
                [self.delegate getYouTubeVideos:self didFinishWithResults:nil:nil:nil:0];
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
                        [self.delegate getYouTubeVideos:self didFinishWithResults:nil:nil:nil:0];
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
                        [self.delegate getYouTubeVideos:self didFinishWithResults:videos:nextPage:prvPage:1];
                    } else {
                        [self.delegate getYouTubeVideos:self didFinishWithResults:videos:nextPage:prvPage:0];
                    }
                    
                }];
        }];
    
}

- (void)getYouTubeVideosWithService:(GTLServiceYouTube *)service : (NSString *)playListId :  (NSString *)nextPageToken : (NSString *)prvPageToken : (int) type {
    // Construct query


                GTLQueryYouTube *playlistItemsListQuery = [GTLQueryYouTube queryForPlaylistItemsListWithPart:@"contentDetails"];
                    switch (type) {
                        case 1:
                            if (nextPageToken)
                            playlistItemsListQuery.pageToken= nextPageToken;
                            else {
                               // [self.delegate getYouTubeVideos:self didFinishWithResults:nil:nil:nil:0];
                                return ;
                            }
                            break;
                        case 2:
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
                            [self.delegate getYouTubeVideos:self didFinishWithResults:nil:nil:nil:0];
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
                                    [self.delegate getYouTubeVideos:self didFinishWithResults:nil:nil:nil:0];
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
                                    [self.delegate getYouTubeVideos:self didFinishWithResults:videos:nextPage:prvPage:1];
                                } else {
                                    [self.delegate getYouTubeVideos:self didFinishWithResults:videos:nextPage:prvPage:0];
                                }
                                
                            }];
                    }];

}

@end
