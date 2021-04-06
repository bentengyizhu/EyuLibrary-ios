//
//  RewardAdGroup.h
//  Freecell
//
//  Created by apple on 2018/7/13.
//

#import "EYRewardAdAdapter.h"
#import "EYBasicAdGroup.h"


@interface EYRewardAdGroup :EYBasicAdGroup
-(EYRewardAdGroup*) initWithGroup:(EYAdGroup*)group adConfig:(EYAdConfig*) adConfig;
//-(void) loadAd:(NSString*) placeId;
-(bool) isCacheAvailable;
-(bool) showAd:(NSString*) placeId withController:(UIViewController*) controller;

@end
