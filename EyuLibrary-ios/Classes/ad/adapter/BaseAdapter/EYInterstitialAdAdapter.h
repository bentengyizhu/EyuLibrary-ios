//
//  IAd.h
//  ballzcpp-mobile
//
//  Created by Woo on 2017/12/19.
//

#import "EYAdAdapter.h"
@interface EYInterstitialAdAdapter : EYAdAdapter{
    
}

@property(nonatomic,strong)EYAdGroup *adGroup;
@property(nonatomic,strong)NSTimer *loadingTimer;
@property(nonatomic,assign)bool isShowing;


-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group;

-(void) loadAd;
-(bool) showAdWithController:(UIViewController*) controller;
-(bool) isAdLoaded;
-(void) notifyOnAdLoaded;
-(void) notifyOnAdLoadFailedWithError:(int)errorCode;
-(void) notifyOnAdShowed;
-(void) notifyOnAdClicked;
-(void) notifyOnAdClosed;
-(void) notifyOnAdImpression;
-(void) notifyOnAdShowedData:(NSDictionary *)data;

-(void) startTimeoutTask;
-(void) cancelTimeoutTask;

@end
