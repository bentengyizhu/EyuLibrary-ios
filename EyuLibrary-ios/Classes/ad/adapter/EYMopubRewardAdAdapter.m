//
//  EYMopubRewardAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2021/4/12.
//
#ifdef MOPUB_ENABLED
#import "EYMopubRewardAdAdapter.h"

@implementation EYMopubRewardAdAdapter
-(void) loadAd
{
    NSLog(@" lwq, mopub loadAd isAdLoaded = %d", [self isAdLoaded]);
    if([self isShowing ]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
    }else if([self isAdLoaded])
    {
        [self notifyOnAdLoaded];
    }else if(![self isLoading] )
    {
        self.isLoading = true;
        [self startTimeoutTask];
        [MPRewardedAds loadRewardedAdWithAdUnitID:self.adKey.key withMediationSettings:nil];
        [MPRewardedAds setDelegate:self forAdUnitId:self.adKey.key];
    }else{
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@" lwq, mopub showAd ");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        NSArray *rewards = [MPRewardedAds availableRewardsForAdUnitID:self.adKey.key];
        [MPRewardedAds presentRewardedAdForAdUnitID:self.adKey.key fromViewController:controller withReward:rewards.firstObject];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    NSArray *rewards = [MPRewardedAds availableRewardsForAdUnitID:self.adKey.key];
    bool isAdLoaded = rewards != NULL && rewards.count > 1;
//    bool isAdLoaded = [[MTGRewardAdManager sharedInstance] isVideoReadyToPlay:self.adKey.key];
    NSLog(@" lwq, mopub Reward video ad isAdLoaded = %d", isAdLoaded);
    return isAdLoaded;
}

- (void)rewardedAdDidLoadForAdUnitID:(NSString *)adUnitID {
    NSLog(@"lwq, mopub reawrded video did load");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

- (void)rewardedAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    NSLog(@"lwq, mopub rewarded video material load fail unitId = %@, error = %@", adUnitID, error);
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}


- (void)rewardedAdDidFailToShowForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    
}

- (void)rewardedAdWillPresentForAdUnitID:(NSString *)adUnitID {
    
}

- (void)rewardedAdDidPresentForAdUnitID:(NSString *)adUnitID {
    NSLog(@"lwq, mopub rewarded video will visible, unitId = %@", adUnitID);
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

- (void)rewardedAdWillDismissForAdUnitID:(NSString *)adUnitID {}

- (void)rewardedAdDidDismissForAdUnitID:(NSString *)adUnitID {
    NSLog(@"lwq, mopub rewarded video did close, unitId = %@", adUnitID);
    
    if(self.isRewarded){
        [self notifyOnAdRewarded];
    }
    self.isShowing = NO;
    self.isRewarded = NO;
    [self notifyOnAdClosed];
}

- (void)rewardedAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPReward *)reward {
    self.isRewarded = true;
}

- (void)rewardedAdDidExpireForAdUnitID:(NSString *)adUnitID {}
// Called when a rewarded ad is expired.

- (void)rewardedAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID {
    NSLog(@"lwq, mopub rewarded video did click, unitId = %@", adUnitID);
    [self notifyOnAdClicked];
}

- (void)rewardedAdWillLeaveApplicationForAdUnitID:(NSString *)adUnitID {}

/**
 Called when an impression is fired on a Rewarded Ad. Includes information about the impression if applicable.

 @param adUnitID The ad unit ID of the rewarded ad that fired the impression.
 @param impressionData Information about the impression, or @c nil if the server didn't return any information.
 */
- (void)didTrackImpressionWithAdUnitID:(NSString *)adUnitID impressionData:(MPImpressionData *)impressionData {}
@end
#endif
