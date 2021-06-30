//
//  EYABURewardAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/8.
//
#ifdef ABUADSDK_ENABLED
#import "EYABURewardAdAdapter.h"

@implementation EYABURewardAdAdapter
-(void) loadAd
{
    NSLog(@"abu loadAd isAdLoaded = %d", [self isAdLoaded]);
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
        ABURewardedVideoModel *model = [[ABURewardedVideoModel alloc] init];
        model.userId = @"123";
        self.rewardAd = [[ABURewardedVideoAd alloc] initWithAdUnitID:self.adKey.key rewardedVideoModel:model];
        self.rewardAd.getExpressAdIfCan = YES;
        self.rewardAd.delegate = self;
        
        //该逻辑用于判断配置是否拉取成功。如果拉取成功，可直接加载广告，否则需要调用setConfigSuccessCallback，传入block并在block中调用加载广告。SDK内部会在配置拉取成功后调用传入的block
        __weak typeof(self) weakself = self;
        //当前配置拉取成功，直接loadAdData
        if(self.rewardAd.hasAdConfig){
            [self startTimeoutTask];
            [self.rewardAd loadAdData];
        }else{
            //当前配置未拉取成功，在成功之后会调用该callback
            [self.rewardAd setConfigSuccessCallback:^{
                [weakself.rewardAd loadAdData];
                [weakself startTimeoutTask];
            }];
        }
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
    ad.mediator = @"abu";
    return ad;
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"abu showAd ");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        return [self.rewardAd showAdFromRootViewController:controller];
    }
    return false;
}

-(bool) isAdLoaded
{
    return self.rewardAd != NULL && self.isLoadSuccess;
}

/**
 This method is called when video ad material loaded successfully.
 */
- (void)rewardedVideoAdDidLoad:(ABURewardedVideoAd *_Nonnull)rewardedVideoAd {
    
}

/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)rewardedVideoAd:(ABURewardedVideoAd *_Nonnull)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    self.isLoadSuccess = false;
    NSLog(@"abu rewarded video material load fail, %@", error);
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

/**
 This method is called when a ABURewardedVideoAd failed to render.
 @param error : the reason of error
 Only for expressAd,hasExpressAdGot = yes
 */
- (void)rewardedVideoAdViewRenderFail:(ABURewardedVideoAd *_Nonnull)rewardedVideoAd error:(NSError *_Nullable)error {
    
}

/**
 This method is called when cached successfully.
 */
- (void)rewardedVideoAdDidDownLoadVideo:(ABURewardedVideoAd *_Nonnull)rewardedVideoAd {
    self.isLoadSuccess = true;
    NSLog(@"abu reawrded video did download");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded: [self getEyuAd]];
}

/**
 This method is called when video ad slot has been shown.
 */
- (void)rewardedVideoAdDidVisible:(ABURewardedVideoAd *_Nonnull)rewardedVideoAd {
    NSLog(@"abu rewarded video will visible");
    EYuAd *ad = [self getEyuAd];
    [self notifyOnAdShowed: ad];
    [self notifyOnAdImpression: ad];
    ad.adRevenue = rewardedVideoAd.getPreEcpm;
    [self notifyOnAdRevenue:ad];
}

/**
 This method is called when video ad is closed.
 */
- (void)rewardedVideoAdDidClose:(ABURewardedVideoAd *_Nonnull)rewardedVideoAd {
    NSLog(@"abu rewarded video did close");
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

/**
 This method is called when video ad is clicked.
 */
- (void)rewardedVideoAdDidClick:(ABURewardedVideoAd *_Nonnull)rewardedVideoAd {
    NSLog(@"abu rewarded video did click");
    [self notifyOnAdClicked: [self getEyuAd]];
}

- (void)rewardedVideoAdServerRewardDidSucceed:(ABURewardedVideoAd *)rewardedVideoAd rewardInfo:(ABUAdapterRewardAdInfo *)rewardInfo verify:(BOOL)verify {
    NSLog(@"abu verify result: %@", verify ? @"success" : @"fail");
    self.isRewarded = true;
}

@end
#endif
