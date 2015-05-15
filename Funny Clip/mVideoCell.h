//
//  mVideoCell.h
//  Funny Clip
//
//  Created by nhannlt on 19/04/2015.
//  Copyright (c) Năm 2015 NhanNLT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoInfoModel.h"
#import "MarqueeLabel.h"
@interface mVideoCell : UITableViewCell {

   
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet MarqueeLabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (nonatomic) NSString * videoId;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topImgTableVideo;
- (IBAction)actionClick:(UIButton *)sender;

//- (void) initCellWithData: ();
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftImgTableVideo;
+ (id) initViewOwner;
- (void) initDataWithVideoInfo: (VideoInfoModel *) model;

@end
