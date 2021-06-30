//
//  EYABUInterstitialAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/8.
//
#ifdef ABUADSDK_ENABLED
#import "EYABUInterstitialAdAdapter.h"

@implementation EYABUInterstitialAdAdapter
-(void) loadAd
{
    NSLog(@"abu interstitialAd loadAd ");
    if([self isShowing ]){
        EYuAd *ad = [self getEyuAd];
        ad.error = [[NSError alloc]initWithDomain:@"isshowingdomain" code:ERROR_AD_IS_SHOWING userInfo:nil];
        [self notifyOnAdLoadFailedWithError:ad];
    }else if(self.interstitialAd == NULL)
    {
        self.interstitialAd = [[ABUFullscreenVideoAd alloc] initWithAdUnitID:self.adKey.key];
        self.interstitialAd.delegate = self;
        self.isLoading = true;
        __weak typeof(self) weakself = self;
        //当前配置拉取成功，直接loadAdData
        if (self.interstitialAd.hasAdConfig) {
            [self startTimeoutTask];
            [self.interstitialAd loadAdData];
        } else {
            //当前配置未拉取成功，在成功之后会调用该callback
            [self.interstitialAd setConfigSuccessCallback:^{
                [weakself startTimeoutTask];
                [weakself.interstitialAd loadAdData];
            }];
        }
    }else if([self isAdLoaded]){
        [self notifyOnAdLoaded: [self getEyuAd]];
    }else{
        if(self.loadingTimer == nil)
        {
            [self startTimeoutTask];
        }
    }
}

-(EYuAd *) getEyuAd{
    EYuAd *ad = [EYuAd new];
    ad.unitId = self.adKey.key;
    ad.unitName = self.adKey.keyId;
    ad.placeId = self.adKey.placementid;
    ad.adFormat = ADTypeInterstitial;
    ad.mediator = @"abu";
    return ad;
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"abu interstitialAd showAd ");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        return [self.interstitialAd showAdFromRootViewController:controller];
    }
    return false;
}

-(bool) isAdLoaded
{
    NSLog(@"abu interstitialAd isAdLoaded , interstitialAd = %@", self.interstitialAd);
    return self.interstitialAd != NULL && self.isLoadSuccess;
}

/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)fullscreenVideoAd:(ABUFullscreenVideoAd *_Nonnull)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error{
    NSLog(@"abu interstitialAd didFailWithError");
    self.isLoading = false;
    self.isLoadSuccess = false;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self cancelTimeoutTask];
    EYuAd *ad = [self getEyuAd];
    ad.error = error;
    [self notifyOnAdLoadFailedWithError:ad];
}


/**
 This method is called when cached successfully.
 */
- (void)fullscreenVideoAdDidDownLoadVideo:(ABUFullscreenVideoAd *_Nonnull)fullscreenVideoAd {
    NSLog(@"abu interstitialAd fullscreenVideoAdDidDownLoadVideo");
    self.isLoading = false;
    self.isLoadSuccess = true;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded: [self getEyuAd]];
}

/**
 This method is called when a nativeExpressAdView failed to render.
 Only for expressAd,hasExpressAdGot = yes
 @param error : the reason of error
 */
- (void)fullscreenVideoAdViewRenderFail:(ABUFullscreenVideoAd *_Nonnull)fullscreenVideoAd error:(NSError *_Nullable)error {
    
    
}

/**
 This method is called when video ad slot will be showing.
 */
- (void)fullscreenVideoAdDidVisible:(ABUFullscreenVideoAd *_Nonnull)fullscreenVideoAd {
    NSLog(@"abu interstitialAd fullscreenVideoAdDidVisible");
    EYuAd *ad = [self getEyuAd];
    [self notifyOnAdShowed: ad];
    [self notifyOnAdImpression: ad];
    ad.adRevenue = fullscreenVideoAd.getPreEcpm;
    [self notifyOnAdRevenue:ad];
}

/**
 This method is called when video ad is clicked.
 */
- (void)fullscreenVideoAdDidClick:(ABUFullscreenVideoAd *_Nonnull)fullscreenVideoAd {
    NSLog(@"abu interstitialAd fullscreenVideoAdDidClick");
    [self notifyOnAdClicked: [self getEyuAd]];
}

/**
 This method is called when video ad is closed.
 */
- (void)fullscreenVideoAdDidClose:(ABUFullscreenVideoAd *_Nonnull)fullscreenVideoAd {
    NSLog(@"abu interstitialAd fullscreenVideoAdDidClose");
    self.isShowing = NO;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self notifyOnAdClosed: [self getEyuAd]];
}

/**
 * This method is called when FullScreen modal has been presented.
 *  弹出详情广告页
 */
- (void)fullscreenVideoAdWillPresentFullScreenModal:(ABUFullscreenVideoAd *_Nonnull)fullscreenVideoAd {
    
}

- (void)dealloc
{
    if(self.interstitialAd!= NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
}
@end
#endif
