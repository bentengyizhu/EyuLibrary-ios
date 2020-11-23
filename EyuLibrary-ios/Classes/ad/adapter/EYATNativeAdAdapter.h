//
//  EYATNativeAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/21.
//

#ifdef ANYTHINK_ENABLED
#ifndef ATNativeAdAdapter_h
#define ATNativeAdAdapter_h
#import "EYNativeAdAdapter.h"
#import <AnyThinkNative/AnyThinkNative.h>
#import "EYATNativeAdView.h"

@interface EYATNativeAdAdapter : EYNativeAdAdapter <ATAdLoadingDelegate, ATNativeADDelegate>
@property(nonatomic,strong)EYATNativeAdView *nativeAdView;
@end

#endif
#endif
