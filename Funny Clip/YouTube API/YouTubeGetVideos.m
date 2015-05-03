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

- (void)searchYouTubeVideosWithService:(GTLServiceYouTube *)service : (NSString *)searchKey {
        GTLQueryYouTube *playlistItemsListQuery = [GTLQueryYouTube queryForSearchListWithPart:@"snippet"];
    playlistItemsListQuery.maxResults = 50l;
    playlistItemsListQuery.q=searchKey;
    
    // This callback uses the block syntax
    
    [service executeQuery:playlistItemsListQuery
     
        completionHandler:^(GTLServiceTicket *ticket, GTLCollectionObject
                            
                            *response, NSError *error) {
            
            if (error) {
                [self.delegate getYouTubeVideos:self didFinishWithResults:nil];
                return;
            }
            response = (GTLYouTubeSearchListResponse *) response;
            NSLog(@"Finished API call");
            
                    NSMutableArray *videos = [NSMutableArray arrayWithCapacity:response.items.count];
                    VideoData *vData;
                    
                    for (GTLYouTubeSearchResult *video in response.items){
                        
                            vData = [VideoData alloc];
                            vData.videoSearch = video;
                            [videos addObject:vData];
                    }
                    [self.delegate getYouTubeVideos:self didFinishWithResults:videos];
            
                }];
      //  }];
    
}
- (void)searchYouTubeVideosWithService2:(GTLServiceYouTube *)service : (NSString *)searchKey {
    GTLQueryYouTube *playlistItemsListQuery = [GTLQueryYouTube queryForSearchListWithPart:@"snippet"];
    playlistItemsListQuery.maxResults = 50l;
    playlistItemsListQuery.q=searchKey;
    
    // This callback uses the block syntax
    
    [service executeQuery:playlistItemsListQuery
     
        completionHandler:^(GTLServiceTicket *ticket, GTLCollectionObject
                            
                            *response, NSError *error) {
            
            if (error) {
                [self.delegate getYouTubeVideos:self didFinishWithResults:nil];
                return;
            }
            response = (GTLYouTubeSearchListResponse *) response;
            NSLog(@"Finished API call");
            
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
                        [self.delegate getYouTubeVideos:self didFinishWithResults:nil];
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
                    [self.delegate getYouTubeVideos:self didFinishWithResults:videos];
                    
                }];
        }];
    
}
- (void)getYouTubeVideosWithService:(GTLServiceYouTube *)service : (NSString *)playListIdParam {
    // Construct query
//    GTLQueryYouTube *channelsListQuery = [GTLQueryYouTube
//
//                                          queryForChannelsListWithPart:@"contentDetails"];
//
//    //channelsListQuery.mine =YES;
//    channelsListQuery.forUsername=@"trongnhan68";
//    // channelsListQuery.channelId=@"UCfF4l8coMQddgehpwdl4lqA";
//
//    //@"UCfF4l8coMQddgehpwdl4lqA";
//   //  channelsListQuery.forContentOwner
//    // This callback uses the block syntax
//    
//    [service executeQuery:channelsListQuery
//     
//        completionHandler:^(GTLServiceTicket *ticket, GTLYouTubeChannelListResponse
//                            
//                            *response, NSError *error) {
//            
//            if (error) {
//                [self.delegate getYouTubeVideos:self didFinishWithResults:nil];
//                return;
//            }
//            
//            NSLog(@"Finished API call");
//            
//            if ([[response items] count] > 0) {
//                
//                GTLYouTubeChannel *channel = response[0];
    
//                NSString *videosPlaylistId =
//                
//                channel.contentDetails.relatedPlaylists.likes;
    
                GTLQueryYouTube *playlistItemsListQuery = [GTLQueryYouTube queryForPlaylistItemsListWithPart:@"contentDetails"];
                playlistItemsListQuery.maxResults = 50l;
                playlistItemsListQuery.playlistId =  playListIdParam;
                
                // This callback uses the block syntax
                
                [service executeQuery:playlistItemsListQuery
                 
                    completionHandler:^(GTLServiceTicket *ticket, GTLYouTubePlaylistItemListResponse
                                        
                                        *response, NSError *error) {
                        
                        if (error) {
                            [self.delegate getYouTubeVideos:self didFinishWithResults:nil];
                            return;
                        }
                        
                        NSLog(@"Finished API call");
                        
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
                                    [self.delegate getYouTubeVideos:self didFinishWithResults:nil];
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
                                [self.delegate getYouTubeVideos:self didFinishWithResults:videos];
                                
                            }];
                    }];

}

@end
