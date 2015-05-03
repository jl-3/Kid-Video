//
//  FavoriteVideoDetail.h
//  Funny Clip
//
//  Created by nhannlt on 27/04/2015.
//  Copyright (c) Năm 2015 NhanNLT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteVideoDetail : NSObject
@property (nonatomic, copy) NSString* videoId;
@property (nonatomic, copy) NSString* deleted;
@property (nonatomic, strong) id position;
@property (nonatomic, copy) NSString* videoDuration;
@property (nonatomic, copy) NSString* thumnailUrl;
@property (nonatomic, copy) NSString* videoName;
@property (nonatomic, copy) NSString* videoDescription;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)FavoriteVideoInfoWithDictionary:(NSDictionary *)dictionary;
@end
