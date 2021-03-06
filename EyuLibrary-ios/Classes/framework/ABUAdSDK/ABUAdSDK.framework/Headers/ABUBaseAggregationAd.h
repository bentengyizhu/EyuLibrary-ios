//
//  ABUBaseAggregationAd.h
//  ABUAdSDK
//
//  Created by wangchao on 2020/2/25.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ABUAdNetworkAdapterProtocol.h"
#import "ABUAdNetworkConnectorProtocol.h"
#import "ABUAdUnit.h"

// ade类型
typedef NS_ENUM (NSInteger, ABUAdClassType) {
    ABUAdClassTypeNative = 1,
    ABUAdClassTypeRewardedVideo,
    ABUAdClassTypeFullscreenVideo,
    ABUAdClassTypeInterstitial,
    ABUAdClassTypeSplash,
    ABUAdClassTypeBanner,
};

/// 聚合广告基类
@interface ABUBaseAggregationAd : NSObject

/// 广告类型
@property (nonatomic, assign) ABUAdSlotAdType adType;

/// 广告类型,与adslot不同，是区分由那个类创建的
@property (nonatomic, assign) ABUAdClassType adClsType;

@end
