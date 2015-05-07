//
//  Utils.m
//  YouTube Direct Lite for iOS
//
//  Created by Ibrahim Ulukaya on 11/6/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import "Utils.h"

@implementation Utils

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

+ (NSString *)humanReadableFromYouTubeTime:(NSString *)youTubeTimeFormat {
 //  youTubeTimeFormat=@"PT12H20M40S";
    if (!youTubeTimeFormat) return  @"(Unknown)";
    if (([youTubeTimeFormat characterAtIndex:4]=='M') || ([youTubeTimeFormat characterAtIndex:3]=='M')) {
                NSRange range = NSMakeRange(0, youTubeTimeFormat.length);
              NSError *error = NULL;
              NSRegularExpression *regex =
                  [NSRegularExpression regularExpressionWithPattern:@"PT(\\d*)M(\\d+)S"
                                                            options:NSRegularExpressionCaseInsensitive
                                                              error:&error];
              NSArray *matches = [regex matchesInString:youTubeTimeFormat options:0 range:range];
              NSString *humanReadable = @"(Unknown)";
              for (NSTextCheckingResult *match in matches) {
                NSRange minuteRange = [match rangeAtIndex:1];
                NSString *minuteString = [youTubeTimeFormat substringWithRange:minuteRange];
                NSRange secRange = [match rangeAtIndex:2];
                NSString *secString = [youTubeTimeFormat substringWithRange:secRange];
                humanReadable =
                    [NSString stringWithFormat:@"%01d:%02d", [minuteString intValue], [secString intValue]];
              }

              NSLog(@"Translated %@ to %@", youTubeTimeFormat, humanReadable);
                    return humanReadable;
    }
    else if (([youTubeTimeFormat characterAtIndex:3]=='H') || ([youTubeTimeFormat characterAtIndex:4]=='H')) {
             if ([youTubeTimeFormat characterAtIndex:youTubeTimeFormat.length-1]=='S' )
             {
                 NSRange range = NSMakeRange(0, youTubeTimeFormat.length);
                 NSError *error = NULL;
                 NSRegularExpression *regex =
                 [NSRegularExpression regularExpressionWithPattern:@"PT(\\d*)H(\\d*)M(\\d+)S"
                                                           options:NSRegularExpressionCaseInsensitive
                                                             error:&error];
                 NSArray *matches = [regex matchesInString:youTubeTimeFormat options:0 range:range];
                 NSString *humanReadable = @"(Unknown)";
                 for (NSTextCheckingResult *match in matches) {
                     NSRange hourRange = [match rangeAtIndex:1];
                     NSString *hourString = [youTubeTimeFormat substringWithRange:hourRange];
                     NSRange minuteRange = [match rangeAtIndex:2];
                     NSString *minuteString = [youTubeTimeFormat substringWithRange:minuteRange];
                     NSRange secRange = [match rangeAtIndex:3];
                     NSString *secString = [youTubeTimeFormat substringWithRange:secRange];
                     humanReadable =
                     [NSString stringWithFormat:@"%01d:%01d:%02d", [hourString intValue],[minuteString intValue], [secString intValue]];
                 }
                 
                 NSLog(@"Translated %@ to %@", youTubeTimeFormat, humanReadable);
                 return humanReadable;

             } else
             {
                 NSRange range = NSMakeRange(0, youTubeTimeFormat.length);
                 NSError *error = NULL;
                 NSRegularExpression *regex =
                 [NSRegularExpression regularExpressionWithPattern:@"PT(\\d*)H(\\d+)M"
                                                           options:NSRegularExpressionCaseInsensitive
                                                             error:&error];
                 NSArray *matches = [regex matchesInString:youTubeTimeFormat options:0 range:range];
                 NSString *humanReadable = @"(Unknown)";
                 for (NSTextCheckingResult *match in matches) {
                     NSRange minuteRange = [match rangeAtIndex:1];
                     NSString *minuteString = [youTubeTimeFormat substringWithRange:minuteRange];
                     NSRange secRange = [match rangeAtIndex:2];
                     NSString *secString = [youTubeTimeFormat substringWithRange:secRange];
                     humanReadable =
                     [NSString stringWithFormat:@"%01d:%02d:00", [minuteString intValue], [secString intValue]];
                 }
                 
                 NSLog(@"Translated %@ to %@", youTubeTimeFormat, humanReadable);
                 return humanReadable;
             
             }
    
    } else return @"(Unknown)";
}
+ (NSString *)humanReadableFromYouTubeTime2:(NSString *)youTubeTimeFormat {
    
    
    NSRange range = NSMakeRange(0, youTubeTimeFormat.length);
    NSError *error = NULL;
    NSRegularExpression *regex =
    [NSRegularExpression regularExpressionWithPattern:@"PT(\\d*)H(\\d*)M(\\d+)S"
                                              options:NSRegularExpressionCaseInsensitive
                                                error:&error];
    NSArray *matches = [regex matchesInString:youTubeTimeFormat options:0 range:range];
    NSString *humanReadable = @"(Unknown)";
    for (NSTextCheckingResult *match in matches) {
        NSRange hourRange = [match rangeAtIndex:1];
        NSString *hourString = [youTubeTimeFormat substringWithRange:hourRange];
        NSRange minuteRange = [match rangeAtIndex:2];
        NSString *minuteString = [youTubeTimeFormat substringWithRange:minuteRange];
        NSRange secRange = [match rangeAtIndex:3];
        NSString *secString = [youTubeTimeFormat substringWithRange:secRange];
        humanReadable =
        [NSString stringWithFormat:@"%01d:%01d:%02d", [hourString intValue],[minuteString intValue], [secString intValue]];
    }
    
    NSLog(@"Translated %@ to %@", youTubeTimeFormat, humanReadable);
    return humanReadable;
    
}
@end
