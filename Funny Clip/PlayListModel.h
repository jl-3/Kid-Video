//
//  PlayListModel.h
//  Funny Clip
//
//  Created by nhannlt on 28/04/2015.
//  Copyright (c) Năm 2015 NhanNLT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayListModel : NSObject
@property (nonatomic, copy) NSString* playListId;
@property (nonatomic, copy) NSString* playListName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)PlayListWithDictionary:(NSDictionary *)dictionary;
@end
