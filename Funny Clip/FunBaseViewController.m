//
//  FunBaseViewController.m
//  Funny Clip
//
//  Created by nhannlt on 15/04/2015.
//  Copyright (c) Năm 2015 NhanNLT. All rights reserved.
//

#import "FunBaseViewController.h"

@interface FunBaseViewController ()

@end

@implementation FunBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.view setBackgroundColor:[UIColor clearColor]];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:NO];
    [self.tabBarController setTitle:@"dasds"];
    self.mFavoriteVideos = [NSMutableArray array];

    
   
}
- (BOOL) loadAllFavoriteVideosFromDB {
        NSString *alertString = @"Data Insertion failed";
        self.mFavoriteVideos = (NSMutableArray *)[[DBManager getSharedInstance] getAllVideos];
    //success = [[DBManager getSharedInstance] saveVideo:item2];
    
    if (!self.mFavoriteVideos) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
                              alertString message:nil
                                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    else {
        NSLog(@"load all data OK");
        return YES;
    }
    return NO;
}
- (BOOL) saveToFavorite: (FavoriteVideoDetail *) mFavoriteItem {
    BOOL success = NO;
    NSString *alertString = @"Data Insertion failed";
    success = [[DBManager getSharedInstance] saveVideo:mFavoriteItem];
    //success = [[DBManager getSharedInstance] saveVideo:item2];
    
    if (success == NO) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
                              alertString message:nil
                                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        NSLog(@"Save data OK");
        //return YES;
    }
    return success;
}

-(void) setTitleNavigationBar
{
    [self.navigationItem setTitle:@"Funny Clip"];

}
-(void) setLeftButtonNavigationBar
{
        self.navigationItem.leftBarButtonItem.title = @"BackView";
        self.navigationController.navigationBar.backItem.leftBarButtonItem.title = @"backview";
        //self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"Purple.png"];
        UIImage *buttonImage = [UIImage imageNamed:@"Purple.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:buttonImage forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, buttonImage.size.width/2, buttonImage.size.height/2);
        button.titleLabel.text = @"popview";
        [button addTarget:self action:@selector(backBtnNavigationBar) forControlEvents:UIControlEventTouchUpInside];
    
        UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    [self.navigationItem setLeftBarButtonItem:customBarItem];
       //[self.navigationItem setLeftBarButtonItem:[UIBarButtonItem new]];
       //self.navigationItem.leftBarButtonItem.title = @"Back";

    
}
- (void)backBtnNavigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
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
