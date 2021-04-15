//
//  EYMopubInterstitialAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/4/12.
//

#ifdef MOPUB_ENABLED
#import "EYInterstitialAdAdapter.h"
#import "MPInterstitialAdController.h"

@interface EYMopubInterstitialAdAdapter : EYInterstitialAdAdapter <MPInterstitialAdControllerDelegate>
@property (nonatomic, strong) MPInterstitialAdController *interstitialAd;
@end

#endif
