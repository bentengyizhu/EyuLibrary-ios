//
//  EYTPInterstitialAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2020/12/29.
//

#ifdef TRADPLUS_ENABLED

#import "EYTPInterstitialAdAdapter.h"

@implementation EYTPInterstitialAdAdapter

@synthesize interstitialAd = _interstitialAd;

-(void) loadAd
{
    NSLog(@"tp interstitialAd loadAd ");
    if([self isShowing ]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
    }else if(self.interstitialAd == NULL)
    {
        self.interstitialAd = [[MsInterstitialAd alloc] init];
        [self.interstitialAd setAdUnitID:self.adKey.key isAutoLoad:false];
        self.interstitialAd.delegate = self;
        self.isLoading = true;
        [self.interstitialAd loadAd];
        [self startTimeoutTask];
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
    NSLog(@"tp interstitialAd showAd ");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        return [self.interstitialAd showAdFromRootViewController:controller];
    }
    return false;
}

-(bool) isAdLoaded
{
    NSLog(@"tp interstitialAd isAdLoaded , interstitialAd = %@", self.interstitialAd);
    return self.interstitialAd != NULL && [self.interstitialAd isAdReady];
}

//load 完成
- (void)interstitialAdAllLoaded:(MsInterstitialAd *)interstitialAd readyCount:(int)readyCount
{
    if (readyCount > 0)
    {
        //加载成功，有可供展示的插屏广告。
    }
    else {
        //加载失败，如果没有设置isAutoLoad为YES，需要在30秒后重新load一次。
    }
}

//单个广告源 加载成功
-(void)interstitialAdLoaded:(MsInterstitialAd *)interstitialAd
{
    NSLog(@"tp,Interstitial did loaded");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

//单个广告源 加载失败
-(void)interstitialAd:(MsInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    NSLog(@"tp interstitial Ad failed to load");
    self.isLoading = false;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

-(void)interstitialAdShown:(MsInterstitialAd *)interstitialAd
{
    NSLog(@"tp The user sees the add");
    // Use this function as indication for a user's impression on the ad.
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

//视频播放结束后回调
-(void)interstitialAdDismissed:(MsInterstitialAd *)interstitialAd
{
    NSLog(@"tp Interstitial had been closed, %@", [NSThread currentThread]);
    // Consider to add code here to resume your app's flow
    self.isShowing = NO;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self notifyOnAdClosed];
}

//点击广告后回调。
-(void)interstitialAdClicked:(MsInterstitialAd *)interstitialAd
{
    NSLog(@"tp The user clicked on the ad and will be taken to its destination");
    // Use this function as indication for a user's click on the ad.
    [self notifyOnAdClicked];
}
@end

#endif
