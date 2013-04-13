//
//  FBLAppDelegate.h
//  FacebookLogin
//
//  Created by Brad Philips on 4/13/13.
//  Copyright (c) 2013 Mixin Mobile, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (FBLAppDelegate *)appDelegate;

+ (void)showProgressIndicator:(NSString *)labelText;
+ (void)showProgressIndicator:(NSString *)labelText withCenter:(CGPoint)center;
+ (void)showProgressIndicator;
+ (void)hideProgressIndicator;
+ (void)hideProgressIndicatorAfterDelay:(NSTimeInterval)delay;

@end
