//
//  EYWMRewardAdAdapter.mm
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef BYTE_DANCE_ADS_ENABLED
#include "EYWMRewardAdAdapter.h"
#import <BUAdSDK/BURewardedVideoAd.h>
#import <BUAdSDK/BURewardedVideoModel.h>

@interface EYWMRewardAdAdapter()<BURewardedVideoAdDelegate>

@property(nonatomic,assign)bool isRewarded;
@property(nonatomic,strong)BURewardedVideoAd* rewardAd;

@end

@implementation EYWMRewardAdAdapter

@synthesize isRewarded = _isRewarded;
@synthesize rewardAd = _rewardAd;

-(void) loadAd
{
    NSLog(@"wm loadAd isAdLoaded = %d", [self isAdLoaded]);
    if([self isShowing ]){
        EYuAd *ad = [self getEyuAd];
        ad.error = [[NSError alloc]initWithDomain:@"isshowingdomain" code:ERROR_AD_IS_SHOWING userInfo:nil];
        [self notifyOnAdLoadFailedWithError:ad];
    }else if([self isAdLoaded])
    {
        [self notifyOnAdLoaded: [self getEyuAd]];
    }else if(![self isLoading] )
    {
        if(self.rewardAd!=NULL)
        {
            self.rewardAd.delegate = nil;
        }
        self.isLoading = true;
        BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
        model.userId = @"123";
//        model.isShowDownloadBar = YES;
        self.rewardAd = [[BURewardedVideoAd alloc] initWithSlotID:self.adKey.key rewardedVideoModel:model];
        self.rewardAd.delegate = self;
        [self startTimeoutTask];
        [self.rewardAd loadAdData];
    }else{
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

-(EYuAd *) getEyuAd{
    EYuAd *ad = [EYuAd new];
    ad.unitId = self.adKey.key;
    ad.unitName = self.adKey.keyId;
    ad.placeId = self.adKey.placementid;
    ad.adFormat = ADTypeReward;
    ad.mediator = @"wm";
    return ad;
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"wm showAd ");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        return [self.rewardAd showAdFromRootViewController:controller];
    }
    return false;
}

-(bool) isAdLoaded
{
    bool isAdLoaded = self.rewardAd != NULL && [self.rewardAd isAdValid];
    NSLog(@"wm Reward video ad isAdLoaded = %d", isAdLoaded);
    return isAdLoaded;
}

#pragma mark BURewardedVideoAdDelegate

- (void)rewardedVideoAdDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@" wm reawrded material load success");
    
}

- (void)rewardedVideoAdVideoDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@" wm reawrded video did load");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded: [self getEyuAd]];
}

- (void)rewardedVideoAdWillVisible:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@" wm rewarded video will visible");
    [self notifyOnAdShowed: [self getEyuAd]];
    [self notifyOnAdImpression: [self getEyuAd]];
}

- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@" wm rewarded video did close");
    if(self.rewardAd != NULL ){
        self.rewardAd.delegate = NULL;
        self.rewardAd = NULL;
    }
    
    if(self.isRewarded){
        [self notifyOnAdRewarded: [self getEyuAd]];
    }
    self.isShowing = NO;
    self.isRewarded = NO;
    [self notifyOnAdClosed: [self getEyuAd]];
}

- (void)rewardedVideoAdDidClick:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@" wm rewarded video did click");
    [self notifyOnAdClicked: [self getEyuAd]];
}

- (void)rewardedVideoAd:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    NSLog(@" wm rewarded video material load fail, %@", error);
    self.isLoading = false;
    if(self.rewardAd != NULL ){
        self.rewardAd.delegate = NULL;
        self.rewardAd = NULL;
    }
    [self cancelTimeoutTask];
    EYuAd *ad = [self getEyuAd];
    ad.error = error;
    [self notifyOnAdLoadFailedWithError:ad];
}

- (void)rewardedVideoAdDidPlayFinish:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    if (error) {
        NSLog(@" wm rewarded play error");
    } else {
        NSLog(@" wm rewarded play finish");
    }
    
}

- (void)rewardedVideoAdServerRewardDidFail:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@" wm rewarded verify failed");
    
}

- (void)rewardedVideoAdServerRewardDidSucceed:(BURewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify{
    NSLog(@" wm rewarded verify succeed");
    NSLog(@" wm verify result: %@", verify ? @"success" : @"fail");
//    if(verify){
        self.isRewarded = true;
//    }
}

@end

#endif /*BYTE_DANCE_ADS_ENABLED*/
