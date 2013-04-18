//
//  MXNLoginService.m
//  MXNSlidingBoilerplate
//
//  Created by Brad Philips on 3/6/13.
//  Copyright (c) 2013 Mixin Mobile, LLC. All rights reserved.
//

#import "FBLLoginService.h"

#define kIsLoggedIn @"IS_LOGGED_IN"

@implementation FBLLoginService

- (BOOL)isLoggedIn {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  return [defaults boolForKey:kIsLoggedIn];
}

- (void)setIsLoggedIn:(BOOL)isLoggedIn {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:isLoggedIn forKey:kIsLoggedIn];
  [defaults synchronize];
}

- (void)getUserProfile:(usercallback_t)callback {
  NSURLRequest *request = [self createRequestForResource:@"user"
                                                  method:@"GET"
                                              parameters:nil
                                                 payload:nil];
  [self makeJSONRequest:request callback:^(id JSON, NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    FBLUser *user;
    if (error == nil) {
      user = [FBLUser deserialize:JSON];
    }
    [self setIsLoggedIn:user != nil];
    callback(user, nil);
  }];
}

- (void)loginWithFacebook:(NSString *)authToken callback:(usercallback_t)callback {
  NSURLRequest *request = [self createRequestForResource:@"user/facebook/login"
                                                  method:@"POST"
                                              parameters:@{ @"access_token": authToken }
                                                 payload:nil];
  [self makeJSONRequest:request callback:^(id JSON, NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    FBLUser *user;
    if (error == nil) {
      user = [FBLUser deserialize:JSON];
    }
    [self setIsLoggedIn:user != nil];
    callback(user, nil);
  }];
}

- (void)logout:(messagecallback_t)callback {
  NSURLRequest *request = [self createRequestForResource:@"user/session"
                                                  method:@"DELETE"
                                              parameters:nil
                                                 payload:nil];
  [self makeJSONRequest:request callback:^(id JSON, NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    [self setIsLoggedIn:NO];
    if (error) {
      callback(nil, error);
      return;
    }
    
    NSString *message = [JSON objectForKey:@"message"];
    callback(message, nil);
  }];
}

@end
