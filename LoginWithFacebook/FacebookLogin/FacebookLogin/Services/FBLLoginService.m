//
//  MXNLoginService.m
//  MXNSlidingBoilerplate
//
//  Created by Brad Philips on 3/6/13.
//  Copyright (c) 2013 Mixin Mobile, LLC. All rights reserved.
//

#import "FBLLoginService.h"

@implementation FBLLoginService

- (void)loginWithFacebook:(NSString *)authToken callback:(usercallback_t)callback {
  NSURLRequest *request = [self createRequestForResource:@"user/facebook/login"
                                                  method:@"POST"
                                              parameters:@{ @"access_token": authToken }
                                                 payload:nil];
  [self makeJSONRequest:request callback:^(id JSON, NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      callback(nil, error);
      return;
    }
    
    FBLUser *user = [FBLUser deserialize:JSON];
    callback(user, nil);
  }];
}

- (void)logout:(messagecallback_t)callback {
  NSURLRequest *request = [self createRequestForResource:@"user/session"
                                                  method:@"DELETE"
                                              parameters:nil
                                                 payload:nil];
  [self makeJSONRequest:request callback:^(id JSON, NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      callback(nil, error);
      return;
    }
    
    NSString *message = [JSON objectForKey:@"message"];
    callback(message, nil);
  }];
}

@end
