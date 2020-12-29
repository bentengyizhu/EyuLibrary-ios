//
//  EYTPInterstitialAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2020/12/29.
//
#ifdef TRADPLUS_ENABLED

#ifndef TPInterstitialAdAdapter_h
#define TPInterstitialAdAdapter_h
#import "EYInterstitialAdAdapter.h"
#import <TradPlusAds/MsInterstitialAd.h>

@interface EYTPInterstitialAdAdapter : EYInterstitialAdAdapter<MsInterstitialAdDelegate>
@property (nonatomic, strong) MsInterstitialAd *interstitialAd;
@end

#endif
#endif
