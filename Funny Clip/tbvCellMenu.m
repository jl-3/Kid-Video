//
//  tbvCellMenu.m
//  Video Clip for Kids
//
//  Created by NhanNLT on 5/19/15.
//  Copyright (c) 2015 NhanNLT. All rights reserved.
//

#import "tbvCellMenu.h"

@implementation tbvCellMenu

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)valueChange:(id)sender {
    
    BOOL isOn = ((UISwitch *) sender).isOn;
    if (self.index == 0)
        [[NSUserDefaults standardUserDefaults] setBool:isOn forKey:@"playRepeat"];
    if (self.index == 1)
        [ [NSUserDefaults standardUserDefaults] setBool:isOn forKey:@"playBackground"];
}
@end
