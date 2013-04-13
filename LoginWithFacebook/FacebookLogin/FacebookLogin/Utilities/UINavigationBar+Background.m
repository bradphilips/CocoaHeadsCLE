//
//  UINavigationBar+SocialBackground.h
//  SocialExample
//
//  Created by Brad Philips on 10/15/12.
//  Copyright (c) 2012 Brad Philips. All rights reserved.
//

#import "UINavigationBar+Background.h"

@implementation UINavigationBar (MXNareBackground)
- (void)drawRect:(CGRect)rect {
  [[self image] drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
  self.tintColor = [UIColor blackColor];
}

- (void)setBackground {
  if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
    [self setBackgroundImage:[self image] forBarMetrics:UIBarMetricsDefault];
  }
  self.tintColor = [UIColor blackColor];
}

- (UIImage *)image {
  return [[UIImage imageNamed:@"NavBarLandscape"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
}

@end
