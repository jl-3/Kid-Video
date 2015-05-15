//
//  DBManager.m
//  Funny Clip
//
//  Created by nhannlt on 27/04/2015.
//  Copyright (c) Năm 2015 NhanNLT. All rights reserved.
//

#import "DBManager.h"
static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"KidVideo.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt ="create table if not exists FavoriteVideos (videoId text primary key , videoName text , videoDescription text , videoDuration text , thumnailUrl text , position integer , deleted boolean )";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

-(BOOL)saveVideo:(FavoriteVideoDetail *) mVideoItem{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into FavoriteVideos (videoId , videoName , videoDescription , videoDuration , thumnailUrl , position , deleted ) values  (\"%@\",\"%@\",\"%@\",\"%@\", \"%@\", \"%d\", \"%@\" )",mVideoItem.videoId , mVideoItem.videoName ,   mVideoItem.videoDescription,mVideoItem.videoDuration,mVideoItem.thumnailUrl, [mVideoItem.position intValue], mVideoItem.deleted ];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
                        if (sqlite3_step(statement) == SQLITE_DONE)
                                {
                                    sqlite3_reset(statement);

                                    return YES;
                                }
                        else {
                                    NSLog(@"%d",sqlite3_step(statement));
                                    if (sqlite3_step(statement) == SQLITE_MISUSE) {
                                        NSArray *mItemVideo = [self findByVideoId:mVideoItem.videoId];
                                        if (mItemVideo) {
                                        int  videoPosition = [[mItemVideo objectAtIndex:4] intValue];
                                            [mVideoItem setValue:@(videoPosition) forKey:@"position"];
                                            
                                            if ( [self updateVideo:mVideoItem]) {
                                                return YES;
                                            };
                                        }
                                    }
                            }
       sqlite3_reset(statement);
     }
return NO;
}

-(BOOL)removeVideos:(int ) position{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        //int tmp= [mVideoItem.position intValue] +1;
        //[mVideoItem setValue:@(tmp) forKey:@"position"];
      //  NSString *updateSQL = [NSString stringWithFormat:@"delete from FavoriteVideos where videoId = \"%@\" ", mVideoItem.videoId ];
        NSString *updateSQL = [NSString stringWithFormat:@"delete from FavoriteVideos where position < \"%d\" ",position];
        
        const char *delete_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(database, delete_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            return YES;
            
        }
        NSLog(@"%d",sqlite3_step(statement));
        sqlite3_reset(statement);
    }
    return NO;
}
-(BOOL)removeVideo:(NSString * ) videoId{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        //int tmp= [mVideoItem.position intValue] +1;
        //[mVideoItem setValue:@(tmp) forKey:@"position"];
        //  NSString *updateSQL = [NSString stringWithFormat:@"delete from FavoriteVideos where videoId = \"%@\" ", mVideoItem.videoId ];
        NSString *updateSQL = [NSString stringWithFormat:@"delete from FavoriteVideos where videoId = \"%@\" ",videoId];
        
        const char *delete_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(database, delete_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            return YES;
            
        }
        NSLog(@"%d",sqlite3_step(statement));
        sqlite3_reset(statement);
    }
    return NO;
}

-(BOOL)updateVideo:(FavoriteVideoDetail *) mVideoItem{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
            //int tmp= [mVideoItem.position intValue] +1;
            //[mVideoItem setValue:@(tmp) forKey:@"position"];
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE FavoriteVideos SET position = \"%d\" where videoId = \"%@\" ",[mVideoItem.position intValue]+1, mVideoItem.videoId ];
//        sqlite3_bind_int(stmt, 1, [txt UTF8String], -1, SQLITE_TRANSIENT);
//        sqlite3_bind_text(stmt, 2, [utxt UTF8String], -1, SQLITE_TRANSIENT);
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(database, update_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                return YES;
            
            }
        NSLog(@"%d",sqlite3_step(statement));
      sqlite3_reset(statement);
    }
    return NO;
}
- (NSArray*) findByVideoId:(NSString*)videoId  {
            const char *dbpath = [databasePath UTF8String];
            if (sqlite3_open(dbpath, &database) == SQLITE_OK)
            {
                NSString *querySQL = [NSString stringWithFormat:
                                      @"select videoName , videoDescription , videoDuration , thumnailUrl , position , deleted from FavoriteVideos where videoId=\"%@\"",videoId];
                const char *query_stmt = [querySQL UTF8String];
                NSMutableArray *resultArray = [[NSMutableArray alloc]init];
                if (sqlite3_prepare_v2(database,
                                       query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        NSString *videoname = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 0)];
                        [resultArray addObject:videoname];
                        NSString *videoDescription = [[NSString alloc] initWithUTF8String:
                                               (const char *) sqlite3_column_text(statement, 1)];
                        [resultArray addObject:videoDescription];
                        NSString *duration = [[NSString alloc] initWithUTF8String:
                                               (const char *) sqlite3_column_text(statement, 2)];
                        [resultArray addObject:duration];
                        NSString *thumnailUrl = [[NSString alloc]initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 3)];
                        [resultArray addObject:thumnailUrl];
                        
                        int position = [[[NSString alloc] initWithUTF8String:
                                               (const char *) sqlite3_column_text(statement, 4)] intValue];
                        [resultArray addObject:@(position)];
                        NSString *deleted = [[NSString alloc]initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 5)];
                        [resultArray addObject:deleted];

                       

                       sqlite3_reset(statement);
                        return resultArray;
                    }
                    else{
                        NSLog(@"Not found");
                       sqlite3_reset(statement);
                        return nil;
                    }
                    sqlite3_reset(statement);
                }
            }
            return nil;
        }
- (NSArray *)getAllVideos{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select * from FavoriteVideos ORDER BY position DESC"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *videoId = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 0)];
                NSString *name = [[NSString alloc]initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 1)];
                NSString *description = [[NSString alloc]initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 2)];
                NSString *duration = [[NSString alloc]initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 3)];
                NSString *thumnailUrl = [[NSString alloc]initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 4)];
                
                //[resultArray addObject:deleted];
                int position = [[[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 5)] intValue];
                //[resultArray addObject:position];
                NSString *deleted = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 6)];
                
                //[resultArray addObject:time];
                //return resultArray;
                NSDictionary *mDic = @{@"videoId":videoId,
                                       @"videoName":name,
                                       @"videoDescription":description,
                                       @"videoDuration":duration,
                                       @"thumnailUrl":thumnailUrl,
                                       @"position":@(position),
                                       @"deleted":deleted,};
                
                FavoriteVideoDetail *mItem = [[FavoriteVideoDetail alloc]initWithDictionary:mDic];
                 NSLog(@"%d",[mItem.position intValue]);
                [resultArray addObject:mItem];
               
            }
//            else{
//                NSLog(@"Not found");
//                return nil;
//            }
           
            sqlite3_reset(statement);
            return resultArray;
        }
    }
    return nil;

}

@end