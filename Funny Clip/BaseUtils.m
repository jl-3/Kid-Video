//
//  BaseUtils.m
//  Tivi Cho Bé 
//
//  Created by nhannlt on 10/05/2015.
//  Copyright (c) Năm 2015 NhanNLT. All rights reserved.
//

#import "BaseUtils.h"

@implementation BaseUtils

// Helper for showing a wait indicator in a popup
+ (UIAlertView *)showWaitIndicator:(NSString *)title {
    UIAlertView *progressAlert;
    progressAlert = [[UIAlertView alloc] initWithTitle:title
                                               message:@"Please wait..."
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil];
    [progressAlert show];
    
    UIActivityIndicatorView *activityView;
    activityView = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.center =
    CGPointMake(progressAlert.bounds.size.width / 2, progressAlert.bounds.size.height - 45);
    
    [progressAlert addSubview:activityView];
    [activityView startAnimating];
    return progressAlert;
}

// Helper for showing an alert
+ (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:message
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [alert show];
}
+ (id ) objectAtIndex: (NSMutableArray *) mArray : (int) index {
    if (mArray)
        if (mArray.count>index)
            return [mArray objectAtIndex:index];
        else return nil;
        else
            return  nil;
}
+ (NSString *)humanReadableFromYouTubeTime:(NSString *)youTubeTimeFormat {
    
    if (!youTubeTimeFormat) return  @"(Unknown)";
    NSString *hour=@"";
    NSString *min=@"";
    NSString *sec=@"";
    @try {
        for (int i=3; i< youTubeTimeFormat.length; i++) {
            if ([youTubeTimeFormat characterAtIndex:i] == 'H' ){
                if ([youTubeTimeFormat characterAtIndex:i-3]=='T'){
                    NSRange mRange = NSMakeRange(i-2, 2);
                    hour = [youTubeTimeFormat substringWithRange:mRange];
                } else {
                    NSRange mRange = NSMakeRange(i-1, 1);
                    hour = [youTubeTimeFormat substringWithRange:mRange];
                }
            }
            if ([youTubeTimeFormat characterAtIndex:i] == 'M' ){
                if (([youTubeTimeFormat characterAtIndex:i-3]=='H')||(([youTubeTimeFormat characterAtIndex:i-3]=='T'))){
                    NSRange mRange = NSMakeRange(i-2, 2);
                    min = [youTubeTimeFormat substringWithRange:mRange];
                } else {
                    NSRange mRange = NSMakeRange(i-1, 1);
                    min = [youTubeTimeFormat substringWithRange:mRange];
                }
            }
            if ([youTubeTimeFormat characterAtIndex:i] == 'S' ){
                if (([youTubeTimeFormat characterAtIndex:i-3]=='M')||(([youTubeTimeFormat characterAtIndex:i-3]=='T'))){
                    NSRange mRange = NSMakeRange(i-2, 2);
                    sec = [youTubeTimeFormat substringWithRange:mRange];
                } else {
                    NSRange mRange = NSMakeRange(i-1, 1);
                    sec = [youTubeTimeFormat substringWithRange:mRange];
                }
            }
        } // for
    } //catch
    @catch (NSException *ex) {
        NSLog(@"error");
    }
    
    
    NSString *humanReadable = @"(Unknown)";
    if ([hour isEqualToString:@""])humanReadable = [NSString stringWithFormat:@"%01d:%02d", [min intValue], [sec intValue]];
    else
        humanReadable = [NSString stringWithFormat:@"%d:%01d:%02d", [hour intValue],[min intValue], [sec intValue]];
    NSLog(@"Translated %@ to %@", youTubeTimeFormat, humanReadable);
    return humanReadable;
}

@end
