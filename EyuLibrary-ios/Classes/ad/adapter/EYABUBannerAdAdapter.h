//
//  EYABUBannerAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/8.
//

#ifdef ABUADSDK_ENABLED
#import <Foundation/Foundation.h>
#import <ABUAdSDK/ABUBannerAd.h>
#import "EYBannerAdAdapter.h"

@interface EYABUBannerAdAdapter : EYBannerAdAdapter <ABUBannerAdDelegate>
@property (nonatomic, strong) ABUBannerAd *bannerAd;
@property (nonatomic, assign) bool isLoadSuccess;
@property (nonatomic, strong) UIView *bannerView;
@end
#endif
