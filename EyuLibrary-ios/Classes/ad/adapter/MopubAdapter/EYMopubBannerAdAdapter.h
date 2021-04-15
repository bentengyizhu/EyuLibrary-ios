//
//  EYMopubBannerAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/4/12.
//

#ifdef MOPUB_ENABLED
#import <Foundation/Foundation.h>
#import "MPAdView.h"
#import "EYBannerAdAdapter.h"

@interface EYMopubBannerAdAdapter : EYBannerAdAdapter <MPAdViewDelegate>
@property (nonatomic, strong) MPAdView *adView;
@property (nonatomic, assign) bool isLoadSuccess;
@end

#endif
