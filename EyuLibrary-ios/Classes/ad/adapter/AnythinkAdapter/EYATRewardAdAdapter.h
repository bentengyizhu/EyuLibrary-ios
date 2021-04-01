//
//  EYATRewardAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/21.
//

#ifdef ANYTHINK_ENABLED
#ifndef ATRewardAdAdapter_h
#define ATRewardAdAdapter_h

#import "EYRewardAdAdapter.h"
#import <AnyThinkRewardedVideo/AnyThinkRewardedVideo.h>
@interface EYATRewardAdAdapter : EYRewardAdAdapter <ATRewardedVideoDelegate, ATAdLoadingDelegate>
@property(nonatomic,assign)bool isRewarded;
@property(nonatomic,assign)bool isLoaded;
@end

#endif
#endif
