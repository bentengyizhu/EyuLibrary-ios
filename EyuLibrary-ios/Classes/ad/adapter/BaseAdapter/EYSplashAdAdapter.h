//
//  EYSplashAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/5.
//

#import "EYAdAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface EYSplashAdAdapter : EYAdAdapter

@property(nonatomic,strong,nullable)EYAdGroup *adGroup;
@property(nonatomic,strong,nullable)NSTimer *loadingTimer;
@property(nonatomic,assign)bool isShowing;

-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group;

-(void) loadAd;
-(bool) showAdWithController:(UIViewController*) controller;
-(bool) isAdLoaded;

-(void) notifyOnAdLoaded:(EYuAd *)eyuAd;
-(void) notifyOnAdLoadFailedWithError:(EYuAd *)eyuAd;
-(void) notifyOnAdClicked:(EYuAd *)eyuAd;
-(void) notifyOnAdClosed:(EYuAd *)eyuAd;
-(void) notifyOnAdImpression:(EYuAd *)eyuAd;
-(void) notifyOnAdRevenue:(EYuAd *)eyuAd;

-(void) startTimeoutTask;
-(void) cancelTimeoutTask;
@end
NS_ASSUME_NONNULL_END
