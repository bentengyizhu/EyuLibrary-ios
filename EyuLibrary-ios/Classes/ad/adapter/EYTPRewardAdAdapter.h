//
//  EYTPRewardAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2020/12/29.
//

#ifdef TRADPLUS_ENABLED
#ifndef TPRewardAdAdapter_h
#define TPRewardAdAdapter_h

#import "EYRewardAdAdapter.h"
#import <TradPlusAds/MsRewardedVideoAd.h>

@interface EYTPRewardAdAdapter : EYRewardAdAdapter <MsRewardedVideoAdDelegate>
@property (strong, nonatomic) MsRewardedVideoAd *rewardedVideoAd;
@property(nonatomic,assign)bool isRewarded;
@end

#endif
#endif
