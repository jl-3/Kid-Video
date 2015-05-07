//
//  VideoItemCollectCell.m
//  Funny Clip
//
//  Created by nhannlt on 20/04/2015.
//  Copyright (c) Năm 2015 NhanNLT. All rights reserved.
//

#import "VideoItemCollectCell.h"

@implementation VideoItemCollectCell

- (void)awakeFromNib {
    // Initialization code
    self.titleLbl.textColor= [UIColor whiteColor];
    self.titleLbl.textAlignment= NSTextAlignmentLeft;
    self.titleLbl.marqueeType = MLContinuous;
    self.titleLbl.scrollDuration = 20.0f;
    self.titleLbl.fadeLength = 0.0f;
    self.titleLbl.trailingBuffer = self.titleLbl.frame.size.width;
    self.titleLbl.animationDelay=0.f;
   
}

- (void)initDataWithVideoInfo:(VideoModel *)model {
   // [self.titleLabel setText:model.title];
    
}

@end
