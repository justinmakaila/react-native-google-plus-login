//
//  RCTGooglePlusLoginManager.m
//  RCTGooglePlusLogin
//
//  Created by Justin Makaila on 7/15/15.
//  Copyright (c) 2015 Justin Makaila. All rights reserved.
//


#import "RCTGooglePlusLoginManager.h"

#import "RCTBridgeModule.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"

#import <GoogleSignIn/GoogleSignIn.h>

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

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
  // TODO: Handle a signed in user
  id errorObject = (error) ? error : [NSNull null];
  id authData = [NSNull null];

  if (error) {
    [self fireEvent:LoginErrorEvent withData:@{
      @"description": error.localizedDescription
    }];
  } else {
    GIDAuthentication *authentication = user.authentication;
    authData = [@{
      @"accessToken": authentication.accessToken,
      @"refreshToken": authentication.refreshToken,
      @"expirationDate": authentication.accessTokenExpirationDate.description,
      @"userID": user.userID,
    } mutableCopy];

    if (user.profile) {
      GIDProfileData *profileData = user.profile;

      if (profileData.email) {
        ((NSMutableDictionary *)authData)[@"userEmail"] = profileData.email;
      }

      if (profileData.name) {
        ((NSMutableDictionary *)authData)[@"name"] = profileData.name;
      }
    }

    [self fireEvent:LoginEvent withData:authData];
  }

  if (self.completion) {
    self.completion(@[errorObject, authData]);
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
  self.completion = completion;
  [[GIDSignIn sharedInstance] signIn];
}

RCT_EXPORT_METHOD(setClientId:(NSString *)clientId) {
  _clientId = clientId;
  [self setupSignInProxy];
}

RCT_EXPORT_METHOD(loadCredentials:(RCTResponseSenderBlock)completion) {
  GIDSignIn *signInProxy = [GIDSignIn sharedInstance];
  if (signInProxy.currentUser) {
    [self signIn:signInProxy didSignInForUser:signInProxy.currentUser withError:nil];
  } else {
    [self fireEvent:LoginErrorEvent withData:@{
      @"description": @"Could not load credentials"
    }];

    completion(@[@"Could not load credentials"]);
  }
}

#pragma mark - Setup

- (void)setupSignInProxy {
  GIDSignIn *signInProxy = [GIDSignIn sharedInstance];
  signInProxy.delegate = self;
  signInProxy.uiDelegate = self;

  signInProxy.shouldFetchBasicProfile = YES;
  signInProxy.clientID = self.clientId;
  signInProxy.scopes = @[@"profile", @"email"];
}

#pragma mark - GIDSignInUIDelegate

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
  [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
  [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
