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
