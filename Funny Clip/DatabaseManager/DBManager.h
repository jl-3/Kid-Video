//
//  DBManager.h
//  Funny Clip
//
//  Created by nhannlt on 27/04/2015.
//  Copyright (c) Năm 2015 NhanNLT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FavoriteVideoDetail.h"
@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;
-(BOOL)saveVideo:(FavoriteVideoDetail *) mVideoItem;
-(BOOL)removeVideos:(int ) position;
-(BOOL)removeVideo:(NSString * ) videoId;
-(BOOL)updateVideo:(FavoriteVideoDetail *) mVideoItem;
-(NSArray*) findByVideoId:(NSString*)videoId;
-(NSArray*) getAllVideos;
@end