//
//  EYWMBannerAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/2/20.
//
#ifdef BYTE_DANCE_ADS_ENABLED
#ifndef EYWMRewardAdAdapter_h
#define EYWMRewardAdAdapter_h

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUNativeExpressBannerView.h>
#import "EYBannerAdAdapter.h"
NS_ASSUME_NONNULL_BEGIN

@interface EYWMBannerAdAdapter : EYBannerAdAdapter <BUNativeExpressBannerViewDelegate>
@property (nonatomic, strong, nullable) BUNativeExpressBannerView *bannerView;
@property (nonatomic, assign) bool isLoadSuccess;
@end

NS_ASSUME_NONNULL_END
#endif
#endif 
