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
   // self.titleLabel.marqueeType = MLContinuous;
    self.titleLabel.scrollDuration = 20.0f;
    self.titleLabel.fadeLength = 1.0f;
   // self.titleLabel.trailingBuffer = self.titleLabel.frame.size.width;
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
- (void) setConstraint {
    [self.leftImgTableVideo setConstant: self.frame.size.width*41/395];
    [self.topImgTableVideo setConstant: self.frame.size.height*82/325];
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}
- (void)setNeedsUpdateConstraints {
    [self.leftImgTableVideo setConstant: self.frame.size.width*41/395];
    [self.topImgTableVideo setConstant: self.frame.size.height*82/325];
     [super setNeedsLayout];
    [super layoutIfNeeded];
    [super setNeedsUpdateConstraints];
}
- (IBAction)actionClick:(UIButton *)sender {
    
    if (sender == self.btnDelete) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteVideoFromFavorite" object:self];
         
    }
}
@end
