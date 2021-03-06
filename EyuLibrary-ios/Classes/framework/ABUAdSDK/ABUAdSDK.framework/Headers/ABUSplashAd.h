//
//  ABUSplashAdView.h
//  ABUAdSDK
//
//  Created by wangchao on 2020/2/25.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ABUBaseAggregationAd.h"
#import "ABUSplashAdDelegate.h"
#import "ABUSplashUserData.h"

/// ABUSplashAd
@interface ABUSplashAd : ABUBaseAggregationAd
/// The unique identifier of splash ad.
@property (nonatomic, copy, readonly, nonnull) NSString *adUnitID;

/// Maximum allowable load timeout, default 3s, unit s.
@property (nonatomic, assign) NSTimeInterval tolerateTimeout;

///  Get a express Ad if SDK can.Default is NO.
@property (nonatomic, assign, readwrite) BOOL getExpressAdIfCan;

/// Is a express Ad Generally if there is a return value available in the receive method "AdDidVisible".Only for BuAdSDK.
@property (nonatomic, assign, readonly) BOOL hasExpressAdGot;

/**
 The delegate for receiving state change messages.
 */
@property (nonatomic, weak, nullable) id<ABUSplashAdDelegate> delegate;

/// Root view controller for handling ad actions.
@property (nonatomic, weak) UIViewController *_Nullable rootViewController;


/// custom bottom view for Splash Ad View.Developers can set logo and other elements here.If not set, the ad size will fill the screen. The max height can not exceed 25% of the screen height.If the height is over range,it will be set according to the maximum value available.Adn it is invalid for ksSDK.
@property (nonatomic, strong, nullable) UIView *customBottomView;


/// Initializes splash ad with slot id and frame.
/// @param adUnitID the unique identifier of splash ad
- (instancetype _Nonnull)initWithAdUnitID:(NSString *_Nonnull)adUnitID;

/// Load splash ad datas.
- (void)loadAdData;

/// 返回显示广告对应的Adn（该接口需要在splashAdWillVisible之后会返回对应的adn），当广告加载中未显示会返回-2，当没有权限访问该部分会放回-3
- (ABUAdnType)getAdNetworkPlaformId;
/// 返回显示广告对应的rit（该接口需要在splashAdWillVisible之后会返回对应的rit），当广告加载中未显示会返回-2，当没有权限访问该部分会放回-3
- (NSString *_Nullable)getAdNetworkRitId;
/// 返回显示广告对应的ecpm（该接口需要在splashAdWillVisible之后会返回对应的ecpm）），当未在平台配置ecpm会返回-1，当广告加载中未显示会返回-2，当没有权限访问该部分会放回-3  单位：分
- (NSString *_Nullable)getPreEcpm;

/**
 Display video ad.
 @param window : root window for displaying ad, must be key window.
 */
- (void)showInWindow:(UIWindow *_Nullable)window;

/**
 Optional:
在广告位配置拉取失败后，会使用传入的rit和appID兜底，进行广告加载，需要在创建manager时就调用该接口（仅支持穿山甲/MTG/Ks/GDT/百度）,
 */
- (void)setUserData:(ABUSplashUserData *_Nonnull)userData error:(NSError * _Nullable *)error;

/**
Required, destory the ad when ad close.
*/
- (void)destoryAd;

@end
