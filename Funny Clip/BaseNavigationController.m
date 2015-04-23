//
//  BaseNavigationController.m
//  Funny Clip
//
//  Created by NhanNLT on 4/15/15.
//  Copyright (c) 2015 NhanNLT. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
       CGRect screenSize = [UIScreen mainScreen].bounds;
  
        //    self.baseViewController = [[FunBaseViewController alloc] initWithNibName:@"FunBaseViewController" bundle:nil];
        //    self.baseViewController.delegate = self;
        //    [self pushViewController:_baseViewController animated:NO];

        self.playListViewController = [[PlaylistViewController alloc] initWithNibName:@"PlaylistViewController" bundle:nil];
        self.playListViewController.delegate = self;
        [self pushViewController:self.playListViewController animated:YES];
    
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
