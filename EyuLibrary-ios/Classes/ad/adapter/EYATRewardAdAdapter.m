//
//  EYATRewardAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/21.
//
#ifdef ANYTHINK_ENABLED
#import "EYATRewardAdAdapter.h"
#include "EYAdManager.h"

@implementation EYATRewardAdAdapter
@synthesize isRewarded = _isRewarded;
@synthesize isLoaded = _isLoaded;

-(void) loadAd
{
    NSLog(@"lwq, ATRewardAdAdapter loadAd #############. adId = #%@#", self.adKey.key);
    if([self isShowing ]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
    }else if([self isAdLoaded])
    {
        [self notifyOnAdLoaded];
    }else if(!self.isLoading)
    {
        self.isLoading = YES;
        [[ATAdManager sharedManager] loadADWithPlacementID:self.adKey.key extra:@{} delegate:self];
        [self startTimeoutTask];
    }else{
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

-(bool) isAdLoaded
{
    return  [[ATAdManager sharedManager] rewardedVideoReadyForPlacementID:self.adKey.key];
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"lwq, EYATRewardAdAdapter showAd #############.");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        self.isRewarded = NO;
        [[ATAdManager sharedManager] showRewardedVideoWithPlacementID:self.adKey.key inViewController:controller delegate:self];
        return true;
    }
    return false;
}

#pragma mark - loading delegate
-(void) didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"lwq, AT didLoadAd adKey = %@", self.adKey);
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

-(void) didFailToLoadADWithPlacementID:(NSString* )placementID error:(NSError *)error {
    NSLog(@"lwq, AT reward didFailToLoadAdWithError: %d, adKey = %@", (int)error.code, self.adKey);
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

#pragma mark - showing delegate
-(void) rewardedVideoDidRewardSuccessForPlacemenID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSLog(@" lwq, AT Reward video ad is showed.");
    self.isRewarded = true;
}

-(void) rewardedVideoDidStartPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"lwq, at reward ad wasDisplayedIn");
    [self notifyOnAdShowed];
    [self notifyOnAdShowedData:extra];
    [self notifyOnAdImpression];
}

-(void) rewardedVideoDidEndPlayingForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATRewardedVideoVideoViewController::rewardedVideoDidEndPlayingForPlacementID:%@ extra:%@", placementID, extra);
}

-(void) rewardedVideoDidFailToPlayForPlacementID:(NSString*)placementID error:(NSError*)error extra:(NSDictionary *)extra {
    NSLog(@"lwq, at reward ad wasDisplayedIn");
    [self notifyOnAdShowed];
    [self notifyOnAdShowedData:extra];
    [self notifyOnAdImpression];
}

-(void) rewardedVideoDidCloseForPlacementID:(NSString*)placementID rewarded:(BOOL)rewarded extra:(NSDictionary *)extra {
    NSLog(@"lwq, applovin reward ad wasHiddenIn isRewarded = %d", rewarded);
    self.isShowing = NO;
    if(rewarded){
        [self notifyOnAdRewarded];
    }
    self.isRewarded = false;
    [self notifyOnAdClosed];
}

-(void) rewardedVideoDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"lwq, AT reward ad wasClickedIn");
    [self notifyOnAdClicked];
}
@end
#endif
