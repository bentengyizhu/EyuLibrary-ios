//
//  EYMopubRewardAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/4/12.
//
#ifdef MOPUB_ENABLED
#import "EYRewardAdAdapter.h"
#import "MPRewardedAds.h"
#import "MoPub.h"

@interface EYMopubRewardAdAdapter : EYRewardAdAdapter <MPRewardedAdsDelegate>
@property(nonatomic,assign)bool isRewarded;
@end
#endif
