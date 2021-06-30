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
    NSLog(@"mopub interstitialAd loadAd ");
    if([self isShowing ]){
        EYuAd *ad = [self getEyuAd];
        ad.error = [[NSError alloc]initWithDomain:@"isshowingdomain" code:ERROR_AD_IS_SHOWING userInfo:nil];
        [self notifyOnAdLoadFailedWithError:ad];
    }else if(self.interstitialAd == NULL)
    {
//        NSDictionary *localExtras = @{@"testDevices" : @"683373713763c9962dbcd75e3aee1a20"};
        self.interstitialAd = [MPInterstitialAdController
                               interstitialAdControllerForAdUnitId:self.adKey.key];
//        self.interstitialAd.localExtras = localExtras;
        self.interstitialAd.delegate = self;
        self.isLoading = true;
        [self.interstitialAd loadAd];
        [self startTimeoutTask];
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
    ad.mediator = @"mopub";
    return ad;
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"mopub interstitialAd showAd ");
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
    NSLog(@"mopub interstitialAd isAdLoaded , interstitialAd = %@", self.interstitialAd);
    return self.interstitialAd != NULL && self.interstitialAd.ready;
}

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@" mopub interstitialAd interstitialDidLoadAd");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded: [self getEyuAd]];
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial withError:(NSError *)error {
    NSLog(@" mopub onInterstitialVideoLoadFail error = %@", error);
    self.isLoading = false;
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

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@" mopub onInterstitialVideoShowSuccess");
    [self notifyOnAdShowed: [self getEyuAd]];
    [self notifyOnAdImpression: [self getEyuAd]];
}

- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial {
    
}

- (void)interstitialDidDismiss:(MPInterstitialAdController *)interstitial {
    NSLog(@" mopub InterstitialVideoAdDismissed");
    self.isShowing = NO;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self notifyOnAdClosed:[self getEyuAd]];
}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial {
    NSLog(@" mopub interstitialAd fullscreenVideoAdDidClick");
    [self notifyOnAdClicked:[self getEyuAd]];
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
