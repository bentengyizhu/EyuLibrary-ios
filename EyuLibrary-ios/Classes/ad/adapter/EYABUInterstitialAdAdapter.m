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
    NSLog(@" lwq, abu interstitialAd loadAd ");
    if([self isShowing ]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
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
        [self notifyOnAdLoaded];
    }else{
        if(self.loadingTimer == nil)
        {
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@" lwq, abu interstitialAd showAd ");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        return [self.interstitialAd showAdFromRootViewController:controller];
    }
    return false;
}

-(bool) isAdLoaded
{
    NSLog(@" lwq, abu interstitialAd isAdLoaded , interstitialAd = %@", self.interstitialAd);
    return self.interstitialAd != NULL && self.isLoadSuccess;
}

/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)fullscreenVideoAd:(ABUFullscreenVideoAd *_Nonnull)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error{
    NSLog(@"lwq, abu interstitialAd didFailWithError");
    self.isLoading = false;
    self.isLoadSuccess = false;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}


/**
 This method is called when cached successfully.
 */
- (void)fullscreenVideoAdDidDownLoadVideo:(ABUFullscreenVideoAd *_Nonnull)fullscreenVideoAd {
    NSLog(@"lwq, abu interstitialAd fullscreenVideoAdDidDownLoadVideo");
    self.isLoading = false;
    self.isLoadSuccess = true;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
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
    NSLog(@"lwq, abu interstitialAd fullscreenVideoAdDidVisible");
    [self notifyOnAdShowed];
    [self notifyOnAdShowedData:@{@"ecpm": fullscreenVideoAd.getPreEcpm}];
    [self notifyOnAdImpression];
}

/**
 This method is called when video ad is clicked.
 */
- (void)fullscreenVideoAdDidClick:(ABUFullscreenVideoAd *_Nonnull)fullscreenVideoAd {
    NSLog(@"lwq, abu interstitialAd fullscreenVideoAdDidClick");
    [self notifyOnAdClicked];
}

/**
 This method is called when video ad is closed.
 */
- (void)fullscreenVideoAdDidClose:(ABUFullscreenVideoAd *_Nonnull)fullscreenVideoAd {
    NSLog(@"lwq, abu interstitialAd fullscreenVideoAdDidClose");
    self.isShowing = NO;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self notifyOnAdClosed];
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
