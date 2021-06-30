//
//  EYAdAdapter.h
//  EyuLibrary-ios-EyuLibrary
//
//  Created by eric on 2021/4/1.
//

#import <UIKit/UIKit.h>
#import "EYAdKey.h"
#import "EYAdGroup.h"
#import "EYuAd.h"
#include "EYAdConstants.h"

@protocol IAdDelegate;
@interface EYAdAdapter : NSObject
@property(nonatomic,weak)id<IAdDelegate> delegate;
@property(nonatomic,strong)EYAdKey *adKey;
@property(nonatomic,assign)int tryLoadAdCount;
@property(nonatomic,assign)bool isLoading;
-(void) loadAd;
-(bool) isAdLoaded;
@end

@protocol IAdDelegate <NSObject>
@optional
-(void) onAdLoaded:(EYAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd;
-(void) onAdLoadFailed:(EYAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd;
-(void) onAdShowed:(EYAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd;
-(void) onAdClicked:(EYAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd;
-(void) onAdClosed:(EYAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd;
-(void) onAdRewarded:(EYAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd;
-(void) onAdImpression:(EYAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd;
-(void) onAdRevenue:(EYAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd;
@end
