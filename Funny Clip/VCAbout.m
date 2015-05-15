//
//  VCAbout.m
//  Funny Clip
//
//  Created by nhannlt on 03/05/2015.
//  Copyright (c) Năm 2015 NhanNLT. All rights reserved.
//

#import "VCAbout.h"

@interface VCAbout ()

@end

@implementation VCAbout

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self.view setBackgroundColor:[UIColor blackColor]];
    //[self.titleVC setTextColor:[UIColor whiteColor]];
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
//    [self.navigationItem.leftBarButtonItem setTitle:@"he"];
//    [self.navigationController.view setBackgroundColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
