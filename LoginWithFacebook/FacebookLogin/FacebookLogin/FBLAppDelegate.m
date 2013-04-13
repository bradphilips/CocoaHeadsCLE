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

#import "UINavigationBar+Background.h"

@implementation FBLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
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

@end
