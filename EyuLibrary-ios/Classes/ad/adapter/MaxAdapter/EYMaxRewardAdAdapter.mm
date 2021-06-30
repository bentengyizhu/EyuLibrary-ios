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
        EYuAd *ad = [self getEyuAd];
        ad.error = [[NSError alloc]initWithDomain:@"isshowingdomain" code:ERROR_AD_IS_SHOWING userInfo:nil];
        [self notifyOnAdLoadFailedWithError:ad];
    }else if([self isAdLoaded])
    {
        [self notifyOnAdLoaded: [self getEyuAd]];
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

-(EYuAd *) getEyuAd{
    EYuAd *ad = [EYuAd new];
    ad.unitId = self.adKey.key;
    ad.unitName = self.adKey.keyId;
    ad.placeId = self.adKey.placementid;
    ad.adFormat = ADTypeReward;
    ad.mediator = @"max";
    return ad;
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
    [self notifyOnAdLoaded: [self getEyuAd]];
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {
    NSLog(@" MAX reward didFailToLoadAdWithError: %d, adKey = %@, message = %@, userinfo = %@", (int)error.code, self.adKey, error.message, error.adLoadFailureInfo);
    self.isLoading = false;
    [self cancelTimeoutTask];
    EYuAd *ad = [self getEyuAd];
    ad.error = [[NSError alloc]initWithDomain:@"adloaderrordomain" code:error.code userInfo:nil];
    [self notifyOnAdLoadFailedWithError:ad];
}

//- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withErrorCode:(NSInteger)errorCode
//{
//    NSLog(@" MAX reward didFailToLoadAdWithError: %ld, adKey = %@", errorCode, self.adKey);
//    self.isLoading = false;
//    [self cancelTimeoutTask];
//    [self notifyOnAdLoadFailedWithError:(int)errorCode];
//}

- (void)didPayRevenueForAd:(MAAd *)ad {
    EYuAd *eyuAd = [self getEyuAd];
    eyuAd.adRevenue = [NSString stringWithFormat:@"%f",ad.revenue];
    eyuAd.networkName = ad.networkName;
    [self notifyOnAdRevenue:eyuAd];
}

- (void)didDisplayAd:(MAAd *)ad {
    NSLog(@" MAX reward ad wasDisplayedIn");
    [self notifyOnAdShowed: [self getEyuAd]];
    [self notifyOnAdImpression: [self getEyuAd]];
}

- (void)didClickAd:(MAAd *)ad {
    NSLog(@" MAX reward ad wasClickedIn");
    [self notifyOnAdClicked: [self getEyuAd]];
}

- (void)didHideAd:(MAAd *)ad
{
    // Rewarded ad is hidden. Pre-load the next ad
    NSLog(@" MAX reward ad wasHiddenIn isRewarded = %d", self.isRewarded);
    self.isShowing = NO;
    if(self.isRewarded){
        [self notifyOnAdRewarded: [self getEyuAd]];
        self.isRewarded = false;
    }
    [self notifyOnAdClosed: [self getEyuAd]];
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
    EYuAd *eyuAd = [self getEyuAd];
    eyuAd.error = [[NSError alloc]initWithDomain:@"adloaderrordomain" code:error.code userInfo:nil];
    [self notifyOnAdLoadFailedWithError:eyuAd];
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
