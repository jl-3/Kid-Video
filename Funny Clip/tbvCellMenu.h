//
//  tbvCellMenu.h
//  Video Clip for Kids
//
//  Created by NhanNLT on 5/19/15.
//  Copyright (c) 2015 NhanNLT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tbvCellMenu : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *view_switch;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (nonatomic) NSInteger index;
+ (void)  changeValue ;
- (IBAction)valueChange:(id)sender;

@end
