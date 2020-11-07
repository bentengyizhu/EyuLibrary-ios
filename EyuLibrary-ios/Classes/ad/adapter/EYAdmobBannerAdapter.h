//
//  EYAdmobBannerAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/7.
//

#ifdef ADMOB_ADS_ENABLED

#ifndef AdmobBannerAdAdapter_h
#define AdmobBannerAdAdapter_h

#import "EYBannerAdAdapter.h"
#import "GoogleMobileAds/GoogleMobileAds.h"
#import <Foundation/Foundation.h>


@interface EYAdmobBannerAdapter : EYBannerAdAdapter <GADBannerViewDelegate>
@property(nonatomic,strong)GADBannerView *bannerAdView;
@end

#endif /* AdmobBannerAdAdapter_h */
#endif /*ADMOB_ADS_ENABLED*/
