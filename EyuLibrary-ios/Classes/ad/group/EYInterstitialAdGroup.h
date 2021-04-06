//
//  InterstitialAdGroup.h
//  Freecell
//
//  Created by apple on 2018/7/13.
//

#import "EYInterstitialAdAdapter.h"
#import "EYBasicAdGroup.h"

@interface EYInterstitialAdGroup :EYBasicAdGroup

-(EYInterstitialAdGroup*) initWithGroup:(EYAdGroup*)adGroup adConfig:(EYAdConfig*) adConfig;
-(bool) isCacheAvailable;
-(bool) showAd:(NSString*)adPlaceId controller:(UIViewController*)controller;
@end
