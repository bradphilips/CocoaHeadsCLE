//
//  FBLMainViewController.m
//  FacebookLogin
//
//  Created by Brad Philips on 4/13/13.
//  Copyright (c) 2013 Mixin Mobile, LLC. All rights reserved.
//

#import "FBLMainViewController.h"
#import <FacebookSDK/Facebook.h>

@interface FBLMainViewController () {
  __unsafe_unretained IBOutlet FBLoginView *_fbLoginView;
  __unsafe_unretained IBOutlet UITableView *_profileTable;
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

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
  _fbLoginView = nil;
  _profileTable = nil;
  [super viewDidUnload];
}
@end