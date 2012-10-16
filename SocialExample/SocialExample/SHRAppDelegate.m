//
//  SHRAppDelegate.m
//  SocialExample
//
//  Created by Brad Philips on 10/15/12.
//  Copyright (c) 2012 Brad Philips. All rights reserved.
//

#import "SHRAppDelegate.h"

#import "UINavigationBar+SocialBackground.h"
#import "SHRViewController.h"

@implementation SHRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  SHRViewController *shareViewController = [[SHRViewController alloc] init];
  self.navigationController = [[UINavigationController alloc] initWithRootViewController:shareViewController];
  [self.navigationController.navigationBar setBackground];
  
  self.window.rootViewController = self.navigationController;
  [self.window makeKeyAndVisible];
  return YES;
}

@end
