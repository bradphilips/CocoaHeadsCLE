//
//  FBLMainViewController.m
//  FacebookLogin
//
//  Created by Brad Philips on 4/13/13.
//  Copyright (c) 2013 Mixin Mobile, LLC. All rights reserved.
//

#import "FBLAppDelegate.h"
#import "FBLMainViewController.h"
#import <FacebookSDK/Facebook.h>

#import "FBLLoginService.h"
#import "MXNValueLabelCell.h"
#import "LabelCell.h"

@interface FBLMainViewController () <FBLoginViewDelegate> {
  __unsafe_unretained IBOutlet FBLoginView *_fbLoginView;
  __unsafe_unretained IBOutlet UITableView *_profileTable;
  
  FBLUser *_fbUser;
}

@end

@implementation FBLMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"Facebook Login", @"Facebook Login");
  }
  return self;
}

#pragma mark - View Lifecycle

- (NSString *)nibName {
  return @"FBLMainView";
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _fbLoginView.delegate = self;
  NSArray *permissions = @[ @"email" ]; // Extra permissions you need on top of basic profile
  _fbLoginView.readPermissions = permissions;
  _fbLoginView.publishPermissions = permissions;
  _fbLoginView.defaultAudience = FBSessionDefaultAudienceFriends;
  
  [self setTableView:_profileTable];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self refreshData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
  _fbLoginView = nil;
  _profileTable = nil;
  [super viewDidUnload];
}

#pragma mark - TableView

- (void)refreshData {
  [self removeAllSectionsWithAnimation:UITableViewRowAnimationFade];
  [self addSectionAtIndex:0 withAnimation:UITableViewRowAnimationFade];
  if (_fbUser) {
    [self appendRowToSection:0
                   cellClass:[MXNValueLabelCell class]
                    cellData:
     @{ @"detailText": @"Success",
        @"detailAlign": @(UITextAlignmentCenter),
        @"detailTextColor": [UIColor whiteColor],
        @"text": @"status"
     }
               withAnimation:UITableViewRowAnimationTop];
    [self appendRowToSection:0
                   cellClass:[MXNValueLabelCell class]
                    cellData:
     @{ @"detailText": _fbUser.email,
        @"detailAlign": @(UITextAlignmentCenter),
        @"detailTextColor": [UIColor whiteColor],
        @"text": @"email"
     }
               withAnimation:UITableViewRowAnimationTop];
    [self appendRowToSection:0
                   cellClass:[MXNValueLabelCell class]
                    cellData:
     @{ @"detailText": _fbUser.firstname,
        @"detailAlign": @(UITextAlignmentCenter),
        @"detailTextColor": [UIColor whiteColor],
        @"text": @"name"
     }
               withAnimation:UITableViewRowAnimationTop];
  } else {
    [self appendRowToSection:0
                   cellClass:[MXNValueLabelCell class]
                    cellData:
     @{ @"detailText": @"Not logged in",
        @"detailAlign": @(UITextAlignmentCenter),
        @"detailTextColor": [UIColor whiteColor],
        @"text": @"status"
     }
               withAnimation:UITableViewRowAnimationTop];
  }
}

#pragma mark - FBLoginViewDelegate Methods

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id <FBGraphUser>)fbUser {
  FBLLoginService *loginService = [[FBLLoginService alloc] init];
  [FBLAppDelegate showProgressIndicator:@"Please wait..." withCenter:self.view.center];
  [loginService loginWithFacebook:[FBSession activeSession].accessTokenData.accessToken callback:^(FBLUser *user, NSError *error) {
    [FBLAppDelegate hideProgressIndicator];
    if (error) {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                      message:error.localizedDescription
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
      [alert show];
      if ([[FBSession activeSession] isOpen]) {
        [[FBSession activeSession] closeAndClearTokenInformation];
      }
      [self logoutUser];
    }
    
    _fbUser = user;
    [self refreshData];
  }];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
  if (_fbUser == nil) { // User is not logged in yet...
    return;
  }
  
  [self logoutUser];
}

- (void)logoutUser {
  FBLLoginService *loginService = [[FBLLoginService alloc] init];
  [FBLAppDelegate showProgressIndicator:@"Please wait..." withCenter:self.view.center];
  [loginService logout:^(NSString *message, NSError *error) {
    [FBLAppDelegate hideProgressIndicator];
    NSString *userMessage = message;
    if (error) {
      userMessage = error.localizedDescription;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logged Out"
                                                    message:userMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    _fbUser = nil;
    [self refreshData];
  }];
}
@end