//
//  MXNLoginService.h
//  MXNSlidingBoilerplate
//
//  Created by Brad Philips on 3/6/13.
//  Copyright (c) 2013 Mixin Mobile, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FBLUser.h"
#import "MXNBaseService.h"

typedef void(^usercallback_t)(FBLUser *user, NSError *error);

@interface FBLLoginService : MXNBaseService

- (void)logout:(messagecallback_t)callback;
- (void)loginWithFacebook:(NSString *)authToken callback:(usercallback_t)callback;

@end
