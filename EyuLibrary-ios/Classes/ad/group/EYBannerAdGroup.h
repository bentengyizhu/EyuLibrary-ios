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
@property(nonatomic,weak)UIView *viewGroup;
@property(nonatomic,strong)EYAdGroup *adGroup;

-(EYBannerAdGroup*) initWithGroup:(EYAdGroup*)adGroup adConfig:(EYAdConfig*) adConfig;
-(CGSize) getBannerSize;
-(bool) isCacheAvailable;
-(bool) showAdGroup:(UIView *)viewGroup;
-(void) loadAd:(NSString*)adPlaceId controller:(UIViewController*)controller;
@end
