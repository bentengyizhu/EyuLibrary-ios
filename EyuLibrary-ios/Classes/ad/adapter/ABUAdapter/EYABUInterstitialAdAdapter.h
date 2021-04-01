//
//  EYABUInterstitialAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/8.
//
#ifdef ABUADSDK_ENABLED
#import <Foundation/Foundation.h>
#import "EYInterstitialAdAdapter.h"
#import <ABUAdSDK/ABUFullscreenVideoAd.h>

@interface EYABUInterstitialAdAdapter : EYInterstitialAdAdapter <ABUFullscreenVideoAdDelegate>
@property(nonatomic,strong)ABUFullscreenVideoAd *interstitialAd;
@property(nonatomic,assign)bool isLoadSuccess;
@end


#endif
