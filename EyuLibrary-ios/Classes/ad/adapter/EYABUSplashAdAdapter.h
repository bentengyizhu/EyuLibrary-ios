//
//  EYABUSplashAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/5.
//

#ifdef ABUADSDK_ENABLED

#import <Foundation/Foundation.h>
#import <ABUAdSDK/ABUSplashAd.h>
#import "EYSplashAdAdapter.h"
#import <ABUAdSDK/ABUAdSDK.h>

@interface EYABUSplashAdAdapter : EYSplashAdAdapter <ABUSplashAdDelegate>
@property(nonatomic,strong)ABUSplashAd *splashAd;
@property(nonatomic,assign)bool isLoadSuccess;
@end

#endif
