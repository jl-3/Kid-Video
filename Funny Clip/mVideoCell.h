//
//  mVideoCell.h
//  Funny Clip
//
//  Created by nhannlt on 19/04/2015.
//  Copyright (c) Năm 2015 NhanNLT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoInfoModel.h"
@interface mVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
//- (void) initCellWithData: ();
+ (id) initViewOwner;
- (void) initDataWithVideoInfo: (VideoInfoModel *) model;

@end
