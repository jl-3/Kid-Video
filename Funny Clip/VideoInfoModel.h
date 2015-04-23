//
//  VideoInfoModel.h
//  Funny Clip
//
//  Created by nhannlt on 20/04/2015.
//  Copyright (c) Năm 2015 NhanNLT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoInfoModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *backgroundLink;
@property (nonatomic, copy) NSString *priority;

- (void) dummyData;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)VideoInfoWithDictionary:(NSDictionary *)dictionary;
@end
