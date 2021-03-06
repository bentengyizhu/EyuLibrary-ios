//
//  ABUAdapterInfoModel.h
//  ABUAdSDK
//
//  Created by wangchao on 2020/3/2.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ABUAdUnit.h"
#import "ABUAggregationBaseProtocol.h"
#import "ABURewardedVideoModel.h"
#import "ABUExtraInfo2Third.h"
#import "ABUExtraInfo2Aggregation.h"
#import "ABUAdSDKDefines.h"


// server load请求类型
typedef NS_ENUM(NSInteger, ABURequestType) {
    ABURequestTypeUnKnown = 0,   // 未知
    ABURequestTypeNormal,         // 正常请求
    ABURequestTypePreLoad,        // 预缓存请求
    ABURequestTypeUseCache,       // 使用预缓存链路
    ABURequestTypeReLoad,     // 预缓存未命中重新请求
};

// 广告模型有效性判断
typedef NS_ENUM(NSInteger, ABUAdValidStatus) {
    ABUAdValidStatusNotForAdn = 0,     // 三方Adn返回不可用,该值不可变！！！
    ABUAdValidStatusNomal,             // 正常可用
    ABUAdValidStatusUnknow,
    ABUAdValidStatusNotForExpired,     // 聚合有效时间过期
    ABUAdValidStatusNotForFailed,      // 三方Adn填充失败
    ABUAdValidStatusNotForNoResp,      // 三方Adn未返回
};

/// 广告适配器信息
@interface ABUAdapterInfoModel : NSObject <ABUAggregationBaseProtocol, NSCopying>

@property (nonatomic, assign) ABUAdSlotAdType adType;   // 广告类型
@property (nonatomic, copy) NSString *platformName; // 广告平台名称(服务器下发)
@property (nonatomic, copy) NSString *adapterName;  // 适配器名称
@property (nonatomic, copy) NSString *configAdapterName;  // 配置器名称
@property (nonatomic, copy) NSString *adUnitID;   // 聚合广告位
@property (nonatomic, copy) NSString *platformSlotID;   // adn代码位
@property (nonatomic, copy) NSString *ritPrice;   // 广告位底价或历史cpm
@property (nonatomic, copy) NSString *priceRate;   // 价格汇率，实际价格ritPrice * priceRate
@property (nonatomic, copy) NSString *slotPrice;   // 竞价广告位cpm
@property (nonatomic, copy) NSString *nativeAdTransformName;    // 原生自渲染广告物料转换器名称
@property (nonatomic, assign) ABUAdPriceType priceType;   // 广告位类型：0为普通广告位，1为竞价广告位, 2服务端竞价， 100P层

/// 从整体config继承的信息
@property (nonatomic, copy) NSString *appID;    // 所属SDKappID
@property (nonatomic, copy) NSString *appKey;    // 所属SDKappKey

/// 从waterfall配置(ABUAdapterAdSlotListModel)继承的信息
@property (nonatomic, copy) NSString *waterfallID;      // 某个waterfall的唯一id
@property (nonatomic, assign) BOOL inTestMode;      // 当前waterfall配置是否属于测试模式，用于开发者自测
@property (nonatomic, copy) NSString *waterfallVersion;      // 某个waterfall的配置版本(标识waterfall配置修改) add in 2200 by wangchao

@property (nonatomic, strong) ABUExtraInfo2Third *extraInfo2Third;  // 从聚合携带到第三方adn的额外信息
@property (nonatomic, strong) ABUExtraInfo2Aggregation *extraInfo2Aggregation;  // 三方---->聚合的携带信息

@property (nonatomic, assign) ABURequestType reqType;    // 标记是否是预缓存，用于激励和全屏视频广告
@property (nonatomic, assign) NSInteger adExpiredTime;  // 缓存广告过期时间，adExpiredTime内有效 仅在三方adn无有效接口下生效
@property (nonatomic, assign) NSTimeInterval fillTime;  // 广告填充时间，

@property (nonatomic, assign) ABUAdValidStatus adValidStatus;   // 广告是否过期

@property (nonatomic, assign) ABUAdnType adnType; 

@property (nonatomic, assign) NSInteger isVideoCacheSuccess; //当前广告是否缓存成功
@property (nonatomic, assign) BOOL preLoadFromShow; // 预缓存是否来自show

@end
