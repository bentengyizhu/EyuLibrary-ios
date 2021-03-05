//
//  EYSplashAdGroup.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/5.
//

#import "EYAdGroup.h"
#import <UIKit/UIKit.h>
#import "EYAdDelegate.h"
#import "EYAdConstants.h"
#import "EYAdConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface EYSplashAdGroup : NSObject
@property(nonatomic,weak) id<EYAdDelegate> delegate;
@property(nonatomic,strong)EYAdGroup *adGroup;

-(EYSplashAdGroup*) initWithGroup:(EYAdGroup*)group adConfig:(EYAdConfig*) adConfig;
-(void) loadAd:(NSString*) placeId;
-(bool) isCacheAvailable;
-(bool) showAd:(NSString*) placeId withController:(UIViewController*) controller;
@end

NS_ASSUME_NONNULL_END
