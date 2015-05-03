//
//  PlayListModel.m
//  Funny Clip
//
//  Created by nhannlt on 28/04/2015.
//  Copyright (c) Năm 2015 NhanNLT. All rights reserved.
//

#import "PlayListModel.h"

@implementation PlayListModel
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.playListId = dictionary[@"playListId"];
        self.playListName = dictionary[@"playListName"];
        }
    return self;
}
+ (instancetype)PlayListWithDictionary:(NSDictionary *)dictionary{
    return [[PlayListModel alloc] initWithDictionary:dictionary];
}
@end
