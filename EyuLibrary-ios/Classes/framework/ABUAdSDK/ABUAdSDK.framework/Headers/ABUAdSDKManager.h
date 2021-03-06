//
//  ABUAdSDKManager.h
//  ABUAdSDK
//
//  Created by wangchao on 2020/2/23.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ABUAdSDKDefines.h"

/// ABUAdSDKManager
@interface ABUAdSDKManager : NSObject

///SDKVersion
@property (nonatomic, copy, readonly, class) NSString *SDKVersion;

/**
 Register the App key that’s already been applied before requesting an ad from TikTok Audience Network.
 @param appID : the unique identifier of the App
 */
+ (void)setAppID:(NSString *)appID;

/// Set whether the app is a paid app, the default is a non-paid app.
/// Must obtain the consent of the user before incoming
+ (void)setIsPaidApp:(BOOL)isPaidApp;

/// extra device data for ABUAdSDK.Must be called before interface "setAppID"!Not required for every developer.Please make sure that it is called only when needed,Now the supported fields are "publisher_did".The incoming format is an dictionary of json strings,eg:"[{\"publisher_did\":\"62271333038\"}"
/// @param extraDeviceStr  eg:@"[{\"publisher_did\":\"62271333038\"}]"
+ (void)setExtDeviceData:(NSString *)extraDeviceStr;

/// Configure development mode.
/// @param level default BUAdSDKLogLevelNone
/// @param language default ABUAdSDKLogLanguageCH
+ (void)setLoglevel:(ABUAdSDKLogLevel)level language:(ABUAdSDKLogLanguage)language;

/// get appID
+ (NSString *)appID;

/// get isPaidApp
+ (BOOL)isPaidApp;

@end
