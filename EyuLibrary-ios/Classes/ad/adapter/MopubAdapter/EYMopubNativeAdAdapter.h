//
//  EYMopubNativeAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/4/12.
//
#ifdef MOPUB_ENABLED
#import <Foundation/Foundation.h>
#import "EYNativeAdAdapter.h"
#import "MPNativeAds.h"

@interface EYMopubNativeAdAdapter : EYNativeAdAdapter <MPNativeAdDelegate>
@property (nonatomic, strong) MPNativeAd *nativeAd;
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, strong) UIImageView *nativeAdImgView;
@end

#endif
