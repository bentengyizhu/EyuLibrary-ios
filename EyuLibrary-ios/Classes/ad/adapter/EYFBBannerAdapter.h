//
//  EYFBBannerAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/9.
//

#ifdef FB_ADS_ENABLED

#ifndef FbBannerAdAdapter_h
#define FbBannerAdAdapter_h


#import "EYBannerAdAdapter.h"
#import "FBAudienceNetwork/FBAudienceNetwork.h"

@interface EYFBBannerAdapter : EYBannerAdAdapter <FBAdViewDelegate>
@property(nonatomic,strong)FBAdView *bannerView;
@end

#endif /* FbBannerAdAdapter_h */

#endif /**FB_ADS_ENABLED*/
