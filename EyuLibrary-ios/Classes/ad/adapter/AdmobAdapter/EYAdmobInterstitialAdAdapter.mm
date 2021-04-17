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
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
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
                [self notifyOnAdLoadFailedWithError:(int)error.code];
                return;
            }
            self.interstitialAd = ad;
            self.interstitialAd.fullScreenContentDelegate = self;
            NSLog(@"admob interstitialDidReceiveAd adKey = %@", self.adKey);
            self.isLoading = false;
            [self cancelTimeoutTask];
            [self notifyOnAdLoaded];
        }];
        [self startTimeoutTask];
        self.isLoading = true;
    }else if([self isAdLoaded]){
        [self notifyOnAdLoaded];
    }else{
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
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
    [self notifyOnAdShowed];
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
   NSLog(@"admobAd did dismiss full screen content.");
    if(self.interstitialAd!= NULL)
    {
        self.interstitialAd = NULL;
    }
    self.isShowing = false;
    [self notifyOnAdClosed];
}

- (void)adDidRecordImpression:(id<GADFullScreenPresentingAd>)ad {
    [self notifyOnAdImpression];
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
