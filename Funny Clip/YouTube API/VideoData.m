//
//  VideoData.m
//  YouTube Direct Lite for iOS
//
//  Created by Ibrahim Ulukaya on 10/21/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import "VideoData.h"

@implementation VideoData
-(NSString *)getYouTubeId {
    if (self.video)
    return self.video.identifier;
    else {
       GTLYouTubeVideo *tmpId= (GTLYouTubeVideo*) self.videoSearch.identifier;
       // return tmpId.;
      //  NSDictionary *mDic = [NSDictionary dictionaryWithObject:tmpId forKey:@"videoId"];
        NSLog([ tmpId  JSONValueForKey:@"videoId"] );
        return [ tmpId  JSONValueForKey:@"videoId"] ;
    }
}

-(NSString *)getTitle {
     if (self.video)
    return self.video.snippet.title;
    else    return self.videoSearch.snippet.title;
}

-(NSString *)getThumbUri {
    if (self.video)

    return self.video.snippet.thumbnails.high.url;
    else return self.videoSearch.snippet.thumbnails.high.url;
}

-(NSString *)getWatchUri {
   
    return [@"http://www.youtube.com/watch?v=" stringByAppendingString:self.getYouTubeId];
    
}

-(NSString *)getDuration {
  if (self.video)
    return self.video.contentDetails.duration;
    else return @"";
}

- (NSString *)getViews {
  return [self.video.statistics.viewCount stringValue];
}

-(GTLYouTubeVideoSnippet *)addTags:(NSArray *)newTags {
    GTLYouTubeVideoSnippet *snippet = self.video.snippet;
    NSArray *tags = snippet.tags;
    if (tags == nil){
        snippet.tags = newTags;
    }
    else {
        NSMutableArray *updateTags = [tags mutableCopy];
        [updateTags addObjectsFromArray:newTags];
        snippet.tags = updateTags;
    }
    return snippet;
}

@end
