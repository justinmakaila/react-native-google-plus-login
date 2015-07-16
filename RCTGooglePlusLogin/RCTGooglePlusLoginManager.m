//
//  RCTGooglePlusLoginManager.m
//  RCTGooglePlusLogin
//
//  Created by Justin Makaila on 7/15/15.
//  Copyright (c) 2015 Justin Makaila. All rights reserved.
//


#import "RCTGooglePlusLoginManager.h"
#import "RCTGooglePlusLoginButton.h"

#import "RCTBridgeModule.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"

#import <GoogleOpenSource/GoogleOpenSource.h>

static NSString * const LoginEvent = @"Login";
static NSString * const LoginFoundEvent = @"LoginFound";
static NSString * const LoginErrorEvent = @"LoginError";

static NSString * const GooglePlusLoginSuccessEvent = @"GooglePlusLoginSuccessEvent";
static NSString * const GooglePlusLoginFoundEvent = @"GooglePlusLoginFoundEvent";
static NSString * const GooglePlusLoginErrorEvent = @"GooglePlusLoginErrorEvent";

@interface RCTGooglePlusLoginManager ()

@property (strong, nonatomic) NSString *clientId;
@property (strong, nonatomic) RCTResponseSenderBlock completion;

@end

@implementation RCTGooglePlusLoginManager

@synthesize bridge = _bridge;
@synthesize methodQueue = _methodQueue;

- (id)init {
  if (self = [super init]) {
    [self setupSignInProxy];

  }
  
  return self;
}

- (UIView *)view {
  return [[RCTGooglePlusLoginButton alloc] init];
}

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
  if (self.completion) {
    if (error) {
      [self fireEvent:LoginErrorEvent withData:@{ @"description": error.localizedDescription }];
      self.completion(@[error]);
    }
    else {
      [self fireEvent:LoginEvent withData:auth.properties];
      self.completion(@[[NSNull null], auth.properties]);
    }
  }
    
  self.completion = nil;
}

RCT_EXPORT_MODULE()

- (NSDictionary *)constantsToExport {
  NSDictionary *events = @{
    LoginEvent: GooglePlusLoginSuccessEvent,
    LoginErrorEvent: GooglePlusLoginErrorEvent,
    LoginFoundEvent: GooglePlusLoginFoundEvent,
  };
  
  return @{
    @"Events": events
  };
}

- (void)fireEvent:(NSString *)event {
  [self fireEvent:event withData:nil];
}

- (void)fireEvent:(NSString *)event withData:(NSDictionary *)data {
  NSString *eventName = self.constantsToExport[@"Events"][event];
  [self.bridge.eventDispatcher sendDeviceEventWithName:eventName body:[NSMutableDictionary dictionaryWithDictionary:data]];
}

RCT_EXPORT_METHOD(login:(RCTResponseSenderBlock)completion) {
  [[GPPSignIn sharedInstance] authenticate];
}

RCT_EXPORT_METHOD(setClientId:(NSString *)clientId) {
  _clientId = clientId;
  [self setupSignInProxy];
}

RCT_EXPORT_METHOD(loadCredentials:(RCTResponseSenderBlock)completion) {
  GTMOAuth2Authentication *authData = [[GPPSignIn sharedInstance] authentication];
  if (authData) {
    [self fireEvent:LoginFoundEvent withData:authData.properties];
    completion(@[[NSNull null], authData]);
  }
  else {
    [self fireEvent:LoginErrorEvent withData:@{ @"description": @"Could not load credentials" }];
    completion(@[@"Could not load credentials"]);
  }
}

#pragma mark - Setup

- (void)setupSignInProxy {
  GPPSignIn *signInProxy = [GPPSignIn sharedInstance];
  signInProxy.delegate = self;
  
  signInProxy.shouldFetchGooglePlusUser = YES;
  signInProxy.clientID = self.clientId;
  
  signInProxy.scopes = @[kGTLAuthScopePlusLogin, @"profile"];
}

@end
