//
//  Utils.h
//  YouTube Direct Lite for iOS
//
//  Created by Ibrahim Ulukaya on 11/6/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const DEFAULT_KEYWORD = @"ytdl";
static NSString *const UPLOAD_PLAYLIST = @"Replace me with the playlist ID you want to upload into";

static NSString *const kClientID = @"352228618510-m24qqg1v3r7f96926or523b03kri1362.apps.googleusercontent.com";
static NSString *const kClientSecret = @"Jd1PVRLfDZtv2FSYmFUDi6Kb";

static NSString *const kKeychainItemName = @"YouTube Direct Lite";

@interface Utils : NSObject

+ (UIAlertView*)showWaitIndicator:(NSString *)title;
+ (void)showAlert:(NSString *)title message:(NSString *)message;
+ (NSString *)humanReadableFromYouTubeTime:(NSString *)youTubeTimeFormat;

@end
