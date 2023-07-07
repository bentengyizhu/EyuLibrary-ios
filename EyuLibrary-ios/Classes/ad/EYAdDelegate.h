//
//  EYAdDelegate.h
//  EyuLibrary-ios_Example
//
//  Created by qianyuan on 2018/10/17.
//  Copyright © 2018年 WeiqiangLuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EYuAd.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EYAdDelegate <NSObject>

-(void) onAdLoaded:(EYuAd*) eyuAd;
-(void) onAdReward:(EYuAd*) eyuAd;
-(void) onAdShowed:(EYuAd*) eyuAd;
-(void) onAdClosed:(EYuAd*) eyuAd;
-(void) onAdClicked:(EYuAd*) eyuAd;
-(void) onAdLoadFailed:(EYuAd*) eyuAd;
-(void) onAdImpression:(EYuAd*) eyuAd;
-(void) onAdShowLoadFailed: (EYuAd*) eyuAd;
@optional
-(void) onAdRevenue:(EYuAd*) eyuAd;
-(void) onDefaultNativeAdClicked;
@end

NS_ASSUME_NONNULL_END
