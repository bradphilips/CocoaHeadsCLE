//
//  SHRTimelineViewController.m
//  SocialExample
//
//  Created by Brad Philips on 12/9/12.
//  Copyright (c) 2012 Brad Philips. All rights reserved.
//

#import "SHRTimelineViewController.h"
#import "UIImageView+WebCache.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>

typedef void(^requestcallback_t)(NSData *responseData, NSHTTPURLResponse *response, NSError *error);

@interface SHRTimelineViewController ()<UITableViewDataSource, UITableViewDataSource> {
  __weak IBOutlet UITableView *_timelineTable;
  NSArray *_tweets;
}

@end

@implementation SHRTimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"Timeline", @"Timeline");
  }
  return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadTimeline];
}

#pragma mark - SLRequest Methods

- (void)loadTimeline {
  NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
  [parameters setObject:@"@" forKey:@"screen_name"]; // Change to @whoever. '@' is for local user...
  [parameters setObject:@"30" forKey:@"count"];
  [parameters setObject:@"1" forKey:@"include_rts"];
  
  //  Next, we create an URL that points to the target endpoint
  NSURL *requestUrl = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
  
  //  Now we can create our request.  Note that we are performing a GET request.
  [self makeRequestWithURL:requestUrl
                parameters:parameters
             requestMethod:SLRequestMethodGET
                  callback:
   ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
     if (error) {
       dispatch_async( dispatch_get_main_queue(), ^{
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:error.localizedDescription
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
       });
       return;
     }
     
     NSError *jsonError;
     NSArray *timeline = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:NSJSONReadingMutableLeaves
                                                           error:&jsonError];
     dispatch_async( dispatch_get_main_queue(), ^{
       _tweets = timeline;
       [_timelineTable reloadData];
     });
   }];
}

- (void)makeRequestWithURL:(NSURL *)requestUrl
                parameters:(NSDictionary *)parameters
             requestMethod:(SLRequestMethod)method
                  callback:(requestcallback_t)callback {
  ACAccountStore *accountStore = [[ACAccountStore alloc] init];
  ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  [accountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
    if (!granted) {
      NSError *accessNotGranted = [NSError errorWithDomain:@"SLSharingDomain"
                                                      code:1000
                                                  userInfo:@{NSLocalizedDescriptionKey: @"Access has not been granted to twitter accounts.  Please visit settings and enable them to use this feature"}];
      callback(nil, nil, accessNotGranted);
      return;
    }
    
    NSArray *twitterAccounts = [accountStore accountsWithAccountType:twitterAccountType];
    
    if ([twitterAccounts count] > 0) {
      // Use the first account for simplicity
      ACAccount *account = [twitterAccounts objectAtIndex:0];
      // Use the account to make the request
      SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                              requestMethod:method
                                                        URL:requestUrl
                                                 parameters:parameters];
      [request setAccount:account];
      [request performRequestWithHandler:callback];
    }
  }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_tweets count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"SHRTweetCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
  }
  
  NSDictionary *tweet = [_tweets objectAtIndex:indexPath.row];
  cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
  cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
  cell.textLabel.numberOfLines = 3;
  
  cell.textLabel.text = [tweet valueForKey:@"text"];
  NSDictionary *user = [tweet valueForKey:@"user"];
  [cell.imageView setImageWithURL:[NSURL URLWithString:[user objectForKey:@"profile_image_url"]]
                 placeholderImage:[UIImage imageNamed:@"Twitter"]];
  return cell;
}

@end