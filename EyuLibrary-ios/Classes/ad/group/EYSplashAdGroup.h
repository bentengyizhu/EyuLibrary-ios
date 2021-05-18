//
//  EYSplashAdGroup.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/5.
//

#import "EYBasicAdGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface EYSplashAdGroup : EYBasicAdGroup

-(EYSplashAdGroup*) initWithGroup:(EYAdGroup*)group adConfig:(EYAdConfig*) adConfig;
-(bool) showAd:(NSString*) placeId withController:(UIViewController*) controller;
@end

NS_ASSUME_NONNULL_END
