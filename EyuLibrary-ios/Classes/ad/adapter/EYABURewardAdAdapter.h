//
//  EYABURewardAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/8.
//
#ifdef ABUADSDK_ENABLED

#import <Foundation/Foundation.h>
#import "EYRewardAdAdapter.h"
#import <ABUAdSDK/ABURewardedVideoModel.h>
#import <ABUAdSDK/ABURewardedVideoAd.h>

@interface EYABURewardAdAdapter : EYRewardAdAdapter <ABURewardedVideoAdDelegate>
@property(nonatomic,assign)bool isRewarded;
@property(nonatomic,strong)ABURewardedVideoAd* rewardAd;
@property(nonatomic,assign)bool isLoadSuccess;
@end

#endif
