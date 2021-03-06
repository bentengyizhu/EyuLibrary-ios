//
//  EYABUNativeAdView.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/6.
//

#ifdef ABUADSDK_ENABLED
#import <Foundation/Foundation.h>
#import "EYNativeAdAdapter.h"
#import <ABUAdSDK/ABUNativeAdView.h>
#import <ABUAdSDK/ABUNativeAdsManager.h>

@interface EYABUNativeAdView : EYNativeAdAdapter <ABUNativeAdsManagerDelegate, ABUNativeAdViewDelegate, ABUNativeAdVideoDelegate>
@property (nonatomic, strong) ABUNativeAdView *nativeAdView;
@property (nonatomic, strong) ABUNativeAdsManager *adManager;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,assign)bool isLoaded;
@end
#endif
