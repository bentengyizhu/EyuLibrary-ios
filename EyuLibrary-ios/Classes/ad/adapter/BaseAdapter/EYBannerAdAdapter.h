//
//  EYBannerAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/7.
//

#import "EYAdAdapter.h"
#import "UIViewExtension.h"

@interface EYBannerAdAdapter : EYAdAdapter

@property(nonatomic,strong)EYAdGroup *adGroup;
@property(nonatomic,assign)bool isShowing;
@property(nonatomic,strong)NSTimer *loadingTimer;

-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group;

-(bool) showAdGroup:(UIView *)viewGroup;
-(void) notifyOnAdLoaded:(EYuAd *)eyuAd;
-(void) notifyOnAdLoadFailedWithError:(EYuAd *)eyuAd;
-(void) notifyOnAdShowed:(EYuAd *)eyuAd;
-(void) notifyOnAdClicked:(EYuAd *)eyuAd;
-(void) notifyOnAdRewarded:(EYuAd *)eyuAd;
-(void) notifyOnAdClosed:(EYuAd *)eyuAd;
-(void) notifyOnAdImpression:(EYuAd *)eyuAd;
-(void) notifyOnAdRevenue:(EYuAd *)eyuAd;
-(UIView *) getBannerView;

-(void) startTimeoutTask;
-(void) cancelTimeoutTask;
@end

