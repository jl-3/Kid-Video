//
//  mVideoCell.m
//  Funny Clip
//
//  Created by nhannlt on 19/04/2015.
//  Copyright (c) Năm 2015 NhanNLT. All rights reserved.
//

#import "mVideoCell.h"

@implementation mVideoCell


+ (id)initViewOwner {
    return [[[NSBundle mainBundle] loadNibNamed:@"mVideoCell" owner:nil options:nil]firstObject];
}
- (void)awakeFromNib {
    // Initialization code
    self.titleLabel.textColor= [UIColor whiteColor];
    self.titleLabel.textAlignment= NSTextAlignmentLeft;
    self.titleLabel.marqueeType = MLContinuous;
    self.titleLabel.scrollDuration = 20.0f;
    self.titleLabel.fadeLength = 20.0f;
    self.titleLabel.trailingBuffer = self.titleLabel.frame.size.width;
    self.titleLabel.animationDelay=0.f;
  
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)initDataWithVideoInfo:(VideoInfoModel *)model {
    [self.titleLabel setText:model.title];
     // [self.backgroundImage setImage:[UIImage imageNamed:television.png]];
}
@end
