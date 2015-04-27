//
//  FavoriteVideoDetail.m
//  Funny Clip
//
//  Created by nhannlt on 27/04/2015.
//  Copyright (c) Năm 2015 NhanNLT. All rights reserved.
//

#import "FavoriteVideoDetail.h"

@implementation FavoriteVideoDetail
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        
        self.videoId = dictionary[@"videoId"];
        self.deleted = dictionary[@"deleted"];
        self.position = dictionary[@"position"];
        self.time = dictionary[@"time"];
        
    }
    return self;
}
+ (instancetype)FavoriteVideoInfoWithDictionary:(NSDictionary *)dictionary{
    return [[FavoriteVideoDetail alloc] initWithDictionary:dictionary];
}
@end
