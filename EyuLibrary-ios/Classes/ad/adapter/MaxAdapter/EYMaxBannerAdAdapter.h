//
//  EYMaxBannerAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/1/19.
//

#ifdef APPLOVIN_MAX_ENABLED

#ifndef EYMaxBannerAdAdapter_h
#define EYMaxBannerAdAdapter_h

#import "EYBannerAdAdapter.h"
#import <AppLovinSDK/AppLovinSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface EYMaxBannerAdAdapter : EYBannerAdAdapter <MAAdViewAdDelegate>
@property (nonatomic, strong) MAAdView *adView;
@property (nonatomic, assign) bool isLoadSuccess;
@end

NS_ASSUME_NONNULL_END

#endif
#endif
