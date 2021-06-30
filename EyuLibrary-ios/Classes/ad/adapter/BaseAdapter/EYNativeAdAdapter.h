//
//  IAd.h
//  ballzcpp-mobile
//
//  Created by Woo on 2017/12/19.
//

#import "EYAdAdapter.h"

@interface EYNativeAdAdapter : EYAdAdapter{
    
}

@property(nonatomic,strong)EYAdGroup *adGroup;
@property(nonatomic,strong)NSTimer *loadingTimer;


-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group;

-(void) loadAd;
-(bool) showAdWithAdLayout:(UIView*)nativeAdLayout iconView:(UIImageView*)nativeAdIcon titleView:(UILabel*)nativeAdTitle
                  descView:(UILabel*)nativeAdDesc mediaLayout:(UIView*)mediaLayout actBtn:(UIButton*)actBtn controller:(UIViewController*)controller;
-(bool) isAdLoaded;
-(void) unregisterView;

-(void) notifyOnAdLoaded:(EYuAd *)eyuAd;
-(void) notifyOnAdLoadFailedWithError:(EYuAd *)eyuAd;
-(void) notifyOnAdShowed:(EYuAd *)eyuAd;
-(void) notifyOnAdClicked:(EYuAd *)eyuAd;
-(void) notifyOnAdImpression:(EYuAd *)eyuAd;
-(void) notifyOnAdClosed:(EYuAd *)eyuAd;
-(void) notifyOnAdRevenue:(EYuAd *)eyuAd;

-(void) startTimeoutTask;
-(void) cancelTimeoutTask;

@end
