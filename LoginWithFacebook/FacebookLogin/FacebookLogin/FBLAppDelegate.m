//
//  FBLAppDelegate.m
//  FacebookLogin
//
//  Created by Brad Philips on 4/13/13.
//  Copyright (c) 2013 Mixin Mobile, LLC. All rights reserved.
//

#import <FacebookSDK/Facebook.h>
#import "FBLAppDelegate.h"
#import "FBLMainViewController.h"
#import "MBProgressHUD.h"

#import "UINavigationBar+Background.h"

@interface FBLAppDelegate () {
  MBProgressHUD *_progressIndicator;
}

@end

@implementation FBLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  _progressIndicator = [[MBProgressHUD alloc] initWithWindow:self.window];
  _progressIndicator.xOffset = 0;
  _progressIndicator.yOffset = 0;
  [self.window addSubview:_progressIndicator];
  
  FBLMainViewController *mainController = [[FBLMainViewController alloc] init];
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainController];
  [navigationController.navigationBar setBackground];
  
  [self.window setRootViewController:navigationController];
  [self.window makeKeyAndVisible];
  return YES;
}

#pragma mark - SSO Methods

- (BOOL)handleOpenURL:(NSURL *)url {
  NSString *scheme = [url scheme];
  NSString *facebookId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookAppID"];
  NSString *prefix = [NSString stringWithFormat:@"fb%@", facebookId];
  if ([scheme hasPrefix:prefix])
    return [FBSession.activeSession handleOpenURL:url];
  
  return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  return [self handleOpenURL:url];
}

#pragma mark - MBProgressHUD

+ (FBLAppDelegate *)appDelegate {
  return (FBLAppDelegate *) [[UIApplication sharedApplication] delegate];
}

- (MBProgressHUD *)progressIndicator {
  return _progressIndicator;
}

+ (void)showProgressIndicator {
  [self showProgressIndicator:nil];
}

+ (void)showProgressIndicator:(NSString *)labelText withCenter:(CGPoint)center {
  FBLAppDelegate *appDelegate = [FBLAppDelegate appDelegate];
  [appDelegate progressIndicator].center = center;
  [self showProgressIndicator:labelText];
}

+ (void)showProgressIndicator:(NSString *)labelText {
  FBLAppDelegate *appDelegate = [FBLAppDelegate appDelegate];
  [appDelegate progressIndicator].labelFont = [UIFont systemFontOfSize:14.0];
  
  if (labelText) {
    [appDelegate progressIndicator].labelText = labelText;
  }
  else {
    [appDelegate progressIndicator].labelText = @"Loading...";
  }
  
  [[appDelegate progressIndicator] show:YES];
  [appDelegate.window bringSubviewToFront:[appDelegate progressIndicator]];
}

+ (void)hideProgressIndicator {
  FBLAppDelegate *appDelegate = [FBLAppDelegate appDelegate];
  [[appDelegate progressIndicator] hide:YES];
}

+ (void)hideProgressIndicatorAfterDelay:(NSTimeInterval)delay {
  FBLAppDelegate *appDelegate = [FBLAppDelegate appDelegate];
  [[appDelegate progressIndicator] hide:YES afterDelay:delay];
}

@end
