//
//  EYMopubInterstitialAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2021/4/12.
//
#ifdef MOPUB_ENABLED
#import "EYMopubInterstitialAdAdapter.h"

@implementation EYMopubInterstitialAdAdapter
-(void) loadAd
{
    NSLog(@" lwq, mopub interstitialAd loadAd ");
    if([self isShowing ]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
    }else if(self.interstitialAd == NULL)
    {
        self.interstitialAd = [MPInterstitialAdController
                               interstitialAdControllerForAdUnitId:self.adKey.key];
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
    NSLog(@" lwq, mopub interstitialAd showAd ");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        [self.interstitialAd showFromViewController:controller];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    NSLog(@" lwq, mopub interstitialAd isAdLoaded , interstitialAd = %@", self.interstitialAd);
    return self.interstitialAd != NULL && self.interstitialAd.ready;
}

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"lwq, mopub interstitialAd interstitialDidLoadAd");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial withError:(NSError *)error {
    NSLog(@"lwq, mopub onInterstitialVideoLoadFail error = %@", error);
    self.isLoading = false;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"lwq, mopub onInterstitialVideoShowSuccess");
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial {
    
}

- (void)interstitialDidDismiss:(MPInterstitialAdController *)interstitial {
    NSLog(@"lwq, mopub InterstitialVideoAdDismissed");
    self.isShowing = NO;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self notifyOnAdClosed];
}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial {
    NSLog(@"lwq, mopub interstitialAd fullscreenVideoAdDidClick");
    [self notifyOnAdClicked];
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
