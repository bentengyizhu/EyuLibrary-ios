//
//  AdmobInterstitialAdAdapter.hpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef ADMOB_ADS_ENABLED

#ifndef AdmobInterstitialAdAdapter_h
#define AdmobInterstitialAdAdapter_h


#import "EYInterstitialAdAdapter.h"
#import "GoogleMobileAds/GoogleMobileAds.h"

@interface EYAdmobInterstitialAdAdapter : EYInterstitialAdAdapter <GADFullScreenContentDelegate> {
    
}
@property(nonatomic, strong) GADInterstitialAd *interstitialAd;
@end

#endif /* AdmobInterstitialAdAdapter_h */
#endif /*ADMOB_ADS_ENABLED*/
