//
//  EYBannerAdGroup.h
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/7.
//


#import "EYBannerAdAdapter.h"
#import "EYBasicAdGroup.h"

@interface EYBannerAdGroup : EYBasicAdGroup

-(EYBannerAdGroup*) initWithGroup:(EYAdGroup*)adGroup adConfig:(EYAdConfig*) adConfig;
-(bool) showAdGroup:(UIView *)viewGroup;
//-(void) loadAd:(NSString*)adPlaceId;
@end
