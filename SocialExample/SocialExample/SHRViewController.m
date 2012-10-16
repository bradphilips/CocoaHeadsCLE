//
//  SHRViewController.m
//  SocialExample
//
//  Created by Brad Philips on 10/15/12.
//  Copyright (c) 2012 Brad Philips. All rights reserved.
//

#import "SHRViewController.h"

#import <Social/Social.h>

@interface SHRViewController ()

- (void)presentShareDialogForServiceType:(NSString *)type;

@property (weak, nonatomic) IBOutlet UITextView *messageText;
@end

@implementation SHRViewController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if(self) {
    self.title = NSLocalizedString(@"Share Me", @"Share Me");
  }
  return self;
}

#pragma mark - View Lifecycle 

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [[event allTouches] anyObject];
  if ([self.messageText isFirstResponder] && (self.messageText != touch.view)) {
    [self.messageText resignFirstResponder];
  }
}
#pragma mark - Actions

- (IBAction)facebookShareTapped:(id)sender {
  [self presentShareDialogForServiceType:SLServiceTypeFacebook];
}

- (IBAction)twitterShareTapped:(id)sender {
  [self presentShareDialogForServiceType:SLServiceTypeTwitter];
}

#pragma mark - Internal

- (void)presentShareDialogForServiceType:(NSString *)type {
  // Check required system version and the account is available...
  NSString *reqSysVer = @"6.0";
  NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
  if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending &&
      [SLComposeViewController isAvailableForServiceType:type]) {
    SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:type];
    // Use this if you want to add an image...
    // [composeViewController addImage:[UIImage imageNamed:@"iOS6"]];
    [composeViewController addURL:[NSURL URLWithString:@"http://www.meetup.com/Cleveland-CocoaHeads"]];
    
    NSString *message = [self.messageText text];
    NSUInteger textLength = [message length] > 140 ? 140 : [message length];
    [composeViewController setInitialText:[message substringToIndex:textLength]];
    
    SLComposeViewControllerCompletionHandler handler = ^(SLComposeViewControllerResult result) {
      if (result == SLComposeViewControllerResultDone) {
        // Could do something here to alert or log...
      } else if (result == SLComposeViewControllerResultCancelled) {
        // Could do something here to alert or log...
      }
      
      [composeViewController dismissViewControllerAnimated:YES completion:nil];
    };
    
    composeViewController.completionHandler = handler;
    [self presentViewController:composeViewController animated:YES completion:nil];
  } else {
    // Fallback to other methods...
    UIAlertView *alertNotSupported = [[UIAlertView alloc] initWithTitle:@"Not Supported"
                                                                message:@"You must have iOS 6 and your account enabled for %@"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
    [alertNotSupported show];
  }
}

@end
