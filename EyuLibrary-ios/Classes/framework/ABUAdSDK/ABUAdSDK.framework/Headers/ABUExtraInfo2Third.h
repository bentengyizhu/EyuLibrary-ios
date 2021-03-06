//
//  ABUExtraInfo2Third.h
//  ABUAdSDK
//
//  Created by wangchao on 2020/6/3.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ABUAdUnit.h"
#import "ABURewardedVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

// 从聚合携带到第三方adn的额外信息
@interface ABUExtraInfo2Third : NSObject <NSCopying>

/// 可选配置 聚合---->三方
@property (nonatomic, assign) BOOL getExpressAdIfCan;   // 如果可以获取模板广告
@property (nonatomic, strong) ABUAdUnit *adSlot;
@property (nonatomic, strong) ABURewardedVideoModel *rewardedVideoModel;
@property (nonatomic, weak) UIViewController *rootViewController;
@property (nonatomic, assign) CGSize adSize;
@property (nonatomic, assign) BOOL IsSupportDeepLink;
@property (nonatomic, assign) NSInteger tolerateTimeout;    // 开屏超时时间
@property (nonatomic, assign) NSInteger autoRefreshTime;    // banner刷新时间

// For  nativeAd
@property (nonatomic, assign) NSInteger nativeAdLoadCount;
@property (nonatomic, assign) BOOL startMutedIfCan;
@property (nonatomic, assign) BOOL useExpress2IfCanForGDT;

// For splash Ad
@property (nonatomic, strong, nullable) UIView *customBottomView;   // 开发者自定义的底部view

// For server bidding ad
@property (atomic, copy) NSString *adm; // 来自服务端Bidding的广告物料，只有server bidding情况下回有值

@end

NS_ASSUME_NONNULL_END
