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
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        NSLog(@"Ipad: %f",screenSize.size.height);
        self.PlayListViewController = [[PlaylistViewController alloc] initWithNibName:@"IpadPlayListViewController" bundle:nil];
        self.PlayListViewController.delegate = self;
        [self pushViewController:self.PlayListViewController animated:YES];
        if ([UIScreen mainScreen].scale >= 2) {
            //self.typeOfDevice = [DEVICE_IPAD_RETINA intValue];
        } else {
           // self.typeOfDevice = [DEVICE_IPAD_NON_RETINA intValue];
        }
    }else{
         NSLog(@"Iphone : %f",screenSize.size.height);
        self.PlayListViewController = [[PlaylistViewController alloc] initWithNibName:@"PlaylistViewController" bundle:nil];
        self.PlayListViewController.delegate = self;
        [self pushViewController:self.PlayListViewController animated:YES];
     
    }
    
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
