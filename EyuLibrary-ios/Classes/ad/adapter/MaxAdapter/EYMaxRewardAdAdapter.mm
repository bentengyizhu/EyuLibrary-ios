//
//  EYMAXRewardAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef APPLOVIN_MAX_ENABLED

#include "EYMaxRewardAdAdapter.h"
#import <AppLovinSDK/AppLovinSDK.h>


@interface EYMaxRewardAdAdapter() <MARewardedAdDelegate>

@property (nonatomic, strong) MARewardedAd *ad;

@end

@implementation EYMaxRewardAdAdapter

-(void) loadAd
{
    NSLog(@" EYMaxRewardAdAdapter loadAd #############. adId = #%@#", self.adKey.key);
    if([self isShowing ]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
    }else if([self isAdLoaded])
    {
        [self notifyOnAdLoaded];
    }else if(!self.isLoading)
    {
        self.isLoading = true;
        if(self.ad == NULL )
        {
            self.ad = [MARewardedAd sharedWithAdUnitIdentifier: self.adKey.key];
            self.ad.delegate = self;
        }
        [self startTimeoutTask];
        [self.ad loadAd];
    }else{
        if(self.loadingTimer == nil)
        {
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@" EYMaxRewardAdAdapter showAd #############.");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        self.isRewarded = NO;
        [self.ad showAd];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    return self.ad != NULL && [self.ad isReady];
}

#pragma mark - MAAdDelegate Protocol

- (void)didLoadAd:(MAAd *)ad
{
    // Rewarded ad is ready to be shown. '[self.rewardedAd isReady]' will now return 'YES'
    // We now have an interstitial ad we can show!
    NSLog(@" MAX reward didLoadAd adKey = %@", self.adKey);
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {
    NSLog(@" MAX reward didFailToLoadAdWithError: %d, adKey = %@, message = %@, userinfo = %@", (int)error.code, self.adKey, error.message, error.adLoadFailureInfo);
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

//- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withErrorCode:(NSInteger)errorCode
//{
//    NSLog(@" MAX reward didFailToLoadAdWithError: %ld, adKey = %@", errorCode, self.adKey);
//    self.isLoading = false;
//    [self cancelTimeoutTask];
//    [self notifyOnAdLoadFailedWithError:(int)errorCode];
//}

- (void)didPayRevenueForAd:(MAAd *)ad {
    [self notifyOnAdShowedData: @{@"adsource_price": @(ad.revenue)}];
}

- (void)didDisplayAd:(MAAd *)ad {
    NSLog(@" MAX reward ad wasDisplayedIn");
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

- (void)didClickAd:(MAAd *)ad {
    NSLog(@" MAX reward ad wasClickedIn");
    [self notifyOnAdClicked];
}

- (void)didHideAd:(MAAd *)ad
{
    // Rewarded ad is hidden. Pre-load the next ad
    NSLog(@" MAX reward ad wasHiddenIn isRewarded = %d", self.isRewarded);
    self.isShowing = NO;
    if(self.isRewarded){
        [self notifyOnAdRewarded];
        self.isRewarded = false;
    }
    [self notifyOnAdClosed];
}

//- (void)didFailToDisplayAd:(MAAd *)ad withErrorCode:(NSInteger)errorCode
//{
//    // Rewarded ad failed to display. We recommend loading the next ad
//    NSLog(@" MAX reward ad didFailToDisplayAd %ld", errorCode);
//    self.isShowing = false;
//    self.isLoading = false;
//    [self cancelTimeoutTask];
//    [self notifyOnAdLoadFailedWithError:(int)errorCode];
//}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {
    NSLog(@" MAX reward ad didFailToDisplayAd %d, message = %@", (int)error.code, error.message);
    self.isShowing = false;
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

#pragma mark - MARewardedAdDelegate Protocol

- (void)didStartRewardedVideoForAd:(MAAd *)ad {
    NSLog(@" MAX reward ad didStartRewardedVideoForAd");

}

- (void)didCompleteRewardedVideoForAd:(MAAd *)ad {
    NSLog(@" MAX reward ad didCompleteRewardedVideoForAd");
}

- (void)didRewardUserForAd:(MAAd *)ad withReward:(MAReward *)reward
{
    // Rewarded ad was displayed and user should receive the reward
    NSLog(@" MAX reward ad didRewardUserForAd");
    self.isRewarded = true;
}

@end

#endif /*APPLOVIN_MAX_ENABLED*/
