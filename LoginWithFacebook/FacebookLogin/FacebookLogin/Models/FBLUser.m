//
//  MXNUser.m
//  MXNSlidingBoilerplate
//
//  Created by Brad Philips on 3/19/13.
//  Copyright (c) 2013 Mixin Mobile, LLC. All rights reserved.
//

#import "FBLUser.h"

@implementation FBLUser
@synthesize email;

+ (DCParserConfiguration *)configuration {
  // This maps attributes of the model from config.  For example:
  // [config addObjectMapping:[DCObjectMapping mapKeyPath:@"user" toAttribute:@"userName" onClass:[MXNLoginRequest class]]];
  // See: https://github.com/dchohfi/KeyValueObjectMapping
  
  DCParserConfiguration *userConfig = [DCParserConfiguration configuration];
  [userConfig addObjectMapping:[DCObjectMapping mapKeyPath:@"email" toAttribute:@"email" onClass:[FBLUser class]]];
  [userConfig addObjectMapping:[DCObjectMapping mapKeyPath:@"firstname" toAttribute:@"firstname" onClass:[FBLUser class]]];
  return userConfig;
}
@end
