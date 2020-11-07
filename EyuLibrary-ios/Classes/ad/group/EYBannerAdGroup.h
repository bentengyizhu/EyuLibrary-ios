//
//  EYBannerAdGroup.h
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/7.
//

#import <Foundation/Foundation.h>
#import "EYAdGroup.h"
#import "EYBannerAdAdapter.h"
#import <UIKit/UIKit.h>
#import "EYAdDelegate.h"
#import "EYAdConstants.h"
#import "EYAdConfig.h"

@interface EYBannerAdGroup : NSObject
@property(nonatomic,weak) id<EYAdDelegate> delegate;
@property(nonatomic,strong)EYAdGroup *adGroup;

-(EYBannerAdGroup*) initWithGroup:(EYAdGroup*)adGroup adConfig:(EYAdConfig*) adConfig;
-(bool) isCacheAvailable;
-(bool) showAd:(NSString*)adPlaceId controller:(UIViewController*)controller;
-(void) loadAd:(NSString*)adPlaceId;
@end
