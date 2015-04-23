//
//  VideoInfoModel.m
//  Funny Clip
//
//  Created by nhannlt on 20/04/2015.
//  Copyright (c) Năm 2015 NhanNLT. All rights reserved.
//

#import "VideoInfoModel.h"

@implementation VideoInfoModel
- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        
        self.title = dictionary[@"title"];
        self.description = dictionary[@"description"];
        self.backgroundLink = dictionary[@"backgroundLink"];
        self.priority = dictionary[@"priority"];
    }
    return self;
}
+ (instancetype)VideoInfoWithDictionary:(NSDictionary *)dictionary{
    return [[VideoInfoModel alloc] initWithDictionary:dictionary];
}
- (void)dummyData{
    self.title = @"hello";
 //
}
@end
