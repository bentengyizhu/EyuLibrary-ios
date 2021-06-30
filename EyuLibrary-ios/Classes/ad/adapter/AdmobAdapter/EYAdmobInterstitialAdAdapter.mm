//
//  AdmobInterstitialAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef ADMOB_ADS_ENABLED
#ifdef ADMOB_MEDIATION_ENABLED
#import <VungleAdapter/VungleAdapter.h>
#import "EYAdManager.h"
#endif
#include "EYAdmobInterstitialAdAdapter.h"


@implementation EYAdmobInterstitialAdAdapter

@synthesize interstitialAd = _interstitialAd;

-(void) loadAd
{
    NSLog(@"admob loadAd interstitialAd = %@", self.interstitialAd);
    if([self isShowing ]){
        EYuAd *ad = [self getEyuAd];
        ad.error = [[NSError alloc]initWithDomain:@"isshowingdomain" code:ERROR_AD_IS_SHOWING userInfo:nil];
        [self notifyOnAdLoadFailedWithError:ad];
    }else if(self.interstitialAd == NULL)
    {
        GADRequest *request = [GADRequest request];
#ifdef ADMOB_MEDIATION_ENABLED
        VungleAdNetworkExtras *extras = [[VungleAdNetworkExtras alloc] init];
        extras.allPlacements = [EYAdManager sharedInstance].vunglePlacementIds;
        [request registerAdNetworkExtras:extras];
#endif
        [GADInterstitialAd loadWithAdUnitID:self.adKey.key
                                    request:request
                          completionHandler:^(GADInterstitialAd *ad, NSError *error) {
            if (error) {
                NSLog(@"admob interstitial:didFailToReceiveAdWithError: %@, adKey = %@", [error localizedDescription], self.adKey);
                self.isLoading = false;
                if(self.interstitialAd!= NULL)
                {
                    self.interstitialAd = NULL;
                }
                [self cancelTimeoutTask];
                EYuAd *ad = [self getEyuAd];
                ad.error = error;
                [self notifyOnAdLoadFailedWithError:ad];
                return;
            }
            self.interstitialAd = ad;
            self.interstitialAd.fullScreenContentDelegate = self;
            NSLog(@"admob interstitialDidReceiveAd adKey = %@", self.adKey);
            self.isLoading = false;
            [self cancelTimeoutTask];
            [self notifyOnAdLoaded: [self getEyuAd]];
        }];
        [self startTimeoutTask];
        self.isLoading = true;
    }else if([self isAdLoaded]){
        [self notifyOnAdLoaded: [self getEyuAd]];
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
    ad.adFormat = ADTypeInterstitial;
    ad.mediator = @"admob";
    return ad;
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"admob showAd [self isAdLoaded] = %d", [self isAdLoaded]);
    if([self isAdLoaded])
    {
        self.isShowing = true;
        [self.interstitialAd presentFromRootViewController:controller];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    return self.interstitialAd != NULL;
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"admobAd did fail to present full screen content.");
    self.isShowing = false;
}

/// Tells the delegate that the ad presented full screen content.
- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"admobAd did present full screen content.");
    [self notifyOnAdShowed: [self getEyuAd]];
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
   NSLog(@"admobAd did dismiss full screen content.");
    if(self.interstitialAd!= NULL)
    {
        self.interstitialAd = NULL;
    }
    self.isShowing = false;
    [self notifyOnAdClosed: [self getEyuAd]];
}

- (void)adDidRecordImpression:(id<GADFullScreenPresentingAd>)ad {
    [self notifyOnAdImpression: [self getEyuAd]];
}

- (void)dealloc
{
    if(self.interstitialAd!= NULL)
    {
        self.interstitialAd = NULL;
    }
}

@end

#endif /*ADMOB_ADS_ENABLED*/
