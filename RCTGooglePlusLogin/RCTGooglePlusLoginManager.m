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
static NSString * const LogoutEvent = @"Logout";
static NSString * const LoginErrorEvent = @"LoginError";
static NSString * const LoginCancelEvent = @"LoginCancel";

static NSString * const GooglePlusLoginSuccessEvent = @"GooglePlusLoginSuccessEvent";
static NSString * const GooglePlusLoginFoundEvent = @"GooglePlusLoginFoundEvent";
static NSString * const GooglePlusLogoutEvent = @"GooglePlusLogoutEvent";
static NSString * const GooglePlusLoginErrorEvent = @"GooglePlusLoginErrorEvent";
static NSString * const GooglePlusLoginCancelEvent = @"GooglePlusLoginCancelEvent";

@interface RCTGooglePlusLoginManager ()

@property (strong, nonatomic) NSArray *permissions;
@property (strong, nonatomic) RCTResponseSenderBlock completion;

@end

@implementation RCTGooglePlusLoginManager

@synthesize bridge = _bridge;

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
    LoginCancelEvent: GooglePlusLoginCancelEvent,
    LoginFoundEvent: GooglePlusLoginFoundEvent,
    LogoutEvent: GooglePlusLogoutEvent
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

RCT_EXPORT_METHOD(loginWithClientId:(NSString *)clientId completion:(RCTResponseSenderBlock)completion) {
    [self loginWithPermissions:self.permissions clientId:clientId completion:completion];
}

RCT_EXPORT_METHOD(loginWithPermissions:(NSArray *)permissions clientId:(NSString *)clientId completion:(RCTResponseSenderBlock)completion) {
  GPPSignIn *signIn = [GPPSignIn sharedInstance];
  signIn.shouldFetchGooglePlusUser = YES;
  signIn.clientID = clientId;

  signIn.scopes = @[kGTLAuthScopePlusLogin, @"profile"];

  signIn.delegate = self;
  
  [signIn authenticate];
}

@end
