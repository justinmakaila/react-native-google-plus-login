//
//  RCTGooglePlusLoginButton.m
//  RCTGooglePlusLogin
//
//  Created by Justin Makaila on 7/16/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "RCTGooglePlusLoginButton.h"

#import "RCTLog.h"

#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface RCTGooglePlusLoginButton ()

@property (strong, nonatomic) GPPSignInButton *signInButton;

@end

@implementation RCTGooglePlusLoginButton

- (id)init {
  if (self = [super init]) {
    [self setup];
  }
  
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self setup];
  }
  
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setup];
  }
  
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  RCTAssert(self.subviews.count == 1, @"RCTGooglePlusLoginButton should only contain one (1) subview");
  RCTAssert([[self subviews] lastObject] == _signInButton, @"RCTGooglePlusLoginButton should be the last subview.");
  
  _signInButton.frame = self.bounds;
}

- (void)insertReactSubview:(UIView *)view atIndex:(NSInteger)atIndex {
  RCTLogError(@"RCTGooglePlusLoginButton does not support subviews");
  return;
}

- (void)removeReactSubview:(UIView *)subview {
  RCTLogError(@"RCTGooglePlusLoginButton does not support subviews");
  return;
}

- (NSArray *)reactSubviews {
  return @[];
}

#pragma mark - Setup

- (void)setup {
  if (!_signInButton) {
    _signInButton = [[GPPSignInButton alloc] init];
    [self addSubview:_signInButton];
  }
}

@end
