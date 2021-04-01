//
//  EYTPNativeAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2020/12/30.
//

#ifdef TRADPLUS_ENABLED
#ifndef TPNativeAdAdapter_h
#define TPNativeAdAdapter_h
#import "EYNativeAdAdapter.h"
#import <TradPlusAds/MsNativeAdsLoader.h>
#import "EYTPNativeAdView.h"

@interface EYTPNativeAdAdapter : EYNativeAdAdapter <MsNativeAdsLoaderDelegate>
@property (strong, nonatomic) MsNativeAdsLoader *adsLoader;
@property(nonatomic,weak)EYTPNativeAdView *nativeAdView;
@property(nonatomic,strong)UIView *adView;
@end
#endif
#endif
