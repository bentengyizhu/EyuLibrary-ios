//
//  ABUAdapterNativeAd.h
//  ABUDemo
//
//  Created by wangchao on 2020/3/27.
//  Copyright © 2020 wangchao. All rights reserved.
//

#import <BUAdSDK/BUAdSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABUAdapterNativeAd : NSObject

@property (nonatomic, strong) BUNativeAdRelatedView *relatedView;
@property (nonatomic, strong) BUMaterialMeta *datas;
@property (nonatomic, strong) BUNativeAd *nativeAd;

@end

NS_ASSUME_NONNULL_END
