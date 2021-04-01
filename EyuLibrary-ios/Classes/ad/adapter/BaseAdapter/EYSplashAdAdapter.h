//
//  EYSplashAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/5.
//

#import "EYAdAdapter.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ISplashAdDelegate;

@interface EYSplashAdAdapter : EYAdAdapter
@property(nonatomic,weak,nullable)id<ISplashAdDelegate> delegate;
@property(nonatomic,strong,nullable)EYAdKey *adKey;
@property(nonatomic,strong,nullable)EYAdGroup *adGroup;
@property(nonatomic,assign)bool isLoading;
@property(nonatomic,strong,nullable)NSTimer *loadingTimer;
@property(nonatomic,assign)bool isShowing;

-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group;

-(void) loadAd;
-(bool) showAdWithController:(UIViewController*) controller;
-(bool) isAdLoaded;

-(void) notifyOnAdLoaded;
-(void) notifyOnAdLoadFailedWithError:(int)errorCode;
-(void) notifyOnAdClicked;
-(void) notifyOnAdClosed;
-(void) notifyOnAdImpression;
-(void) notifyOnAdShowedData:(nullable NSDictionary *)data;

-(void) startTimeoutTask;
-(void) cancelTimeoutTask;
@end

@protocol ISplashAdDelegate<NSObject>
-(void) onAdLoaded:(EYSplashAdAdapter *)adapter;
-(void) onAdLoadFailed:(EYSplashAdAdapter *)adapter withError:(int)errorCode;
-(void) onAdClosed:(EYSplashAdAdapter *)adapter;
-(void) onAdClicked:(EYSplashAdAdapter *)adapter;
-(void) onAdImpression:(EYSplashAdAdapter *)adapter;
-(void) onAdShowed:(EYSplashAdAdapter *)adapter extraData:(nullable NSDictionary *)extraData;
@end

NS_ASSUME_NONNULL_END
