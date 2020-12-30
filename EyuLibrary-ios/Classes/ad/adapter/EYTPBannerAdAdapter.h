//
//  EYTPBannerAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2020/12/30.
//

#ifdef TRADPLUS_ENABLED
#ifndef TPBannerAdAdapter_h
#define TPBannerAdAdapter_h

#import "EYBannerAdAdapter.h"
#import <TradPlusAds/MsBannerView.h>

@interface EYTPBannerAdAdapter : EYBannerAdAdapter <MsBannerViewDelegate>
@property (nonatomic, strong) MsBannerView *bannerView;
@property (nonatomic, assign) bool isLoadSuccess;
@end

#endif
#endif
