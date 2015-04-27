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
            const char *sql_stmt ="create table if not exists FavoriteVideos (videoId text primary key , deleted boolean , position integer , time text)";
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
        NSString *insertSQL = [NSString stringWithFormat:@"insert into FavoriteVideos (videoId,deleted, position, time) values  (\"%@\",\"%@\", \"%@\", \"%@\")",mVideoItem.videoId ,mVideoItem.deleted, mVideoItem.position, mVideoItem.time];
                                const char *insert_stmt = [insertSQL UTF8String];
                                sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
                                if (sqlite3_step(statement) == SQLITE_DONE)
                                {
                                    return YES;
                                }
                                else {
                                    return NO;
                                }
                                sqlite3_reset(statement);
                                }
                                return NO;
                                }
                                
- (NSArray*) findByRegisterNumber:(NSString*)registerNumber
        {
            const char *dbpath = [databasePath UTF8String];
            if (sqlite3_open(dbpath, &database) == SQLITE_OK)
            {
                NSString *querySQL = [NSString stringWithFormat:
                                      @"select deleted, position, time from FavoriteVideos where videoId=\"%@\"",registerNumber];
                const char *query_stmt = [querySQL UTF8String];
                NSMutableArray *resultArray = [[NSMutableArray alloc]init];
                if (sqlite3_prepare_v2(database,
                                       query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        NSString *deleted = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 0)];
                        [resultArray addObject:deleted];
                        NSString *position = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(statement, 1)];
                        [resultArray addObject:position];
                        NSString *time = [[NSString alloc]initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 2)];
                        [resultArray addObject:time];
                        return resultArray;
                    }
                    else{
                        NSLog(@"Not found");
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
                              @"select * from FavoriteVideos "];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *videoId = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 0)];
                //[resultArray addObject:videoId];

                NSString *deleted = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 1)];
                //[resultArray addObject:deleted];
                NSInteger position = [[[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)] integerValue];
                //[resultArray addObject:position];
                NSString *time = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 3)];
                //[resultArray addObject:time];
                //return resultArray;
                NSDictionary *mDic = @{@"videoId":videoId,@"deleted":deleted,@"position":@(position) ,@"time":time,  };
                FavoriteVideoDetail *mItem = [[FavoriteVideoDetail alloc]initWithDictionary:mDic];
                 NSLog(@"%@",mItem.position);
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