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
    NSLog(@" ATRewardAdAdapter loadAd #############. adId = #%@#", self.adKey.key);
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
    NSLog(@" EYATRewardAdAdapter showAd #############.");
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
    NSLog(@" AT didLoadAd adKey = %@", self.adKey);
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

-(void) didFailToLoadADWithPlacementID:(NSString* )placementID error:(NSError *)error {
    NSLog(@" AT reward didFailToLoadAdWithError: %d, adKey = %@", (int)error.code, self.adKey);
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

#pragma mark - showing delegate
-(void) rewardedVideoDidRewardSuccessForPlacemenID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSLog(@"AT Reward video ad is showed.");
    self.isRewarded = true;
}

-(void) rewardedVideoDidStartPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@" at reward ad wasDisplayedIn");
    [self notifyOnAdShowed];
    NSDictionary *data = @{@"adsource_price": extra[@"adsource_price"], @"unitId": self.adKey.key, @"unitName": self.adKey.keyId, @"placeId": self.adKey.placementid, @"adFormat": ADTypeReward, @"mediator": @"topon", @"networkName": extra[@"adsource_id"], @"currency": extra[@"currency"]};
    [self notifyOnAdShowedData:data];
    [self notifyOnAdImpression];
}

-(void) rewardedVideoDidEndPlayingForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATRewardedVideoVideoViewController::rewardedVideoDidEndPlayingForPlacementID:%@ extra:%@", placementID, extra);
}

-(void) rewardedVideoDidFailToPlayForPlacementID:(NSString*)placementID error:(NSError*)error extra:(NSDictionary *)extra {
    NSLog(@" at reward ad wasDisplayedIn");
    [self notifyOnAdShowed];
    NSDictionary *data = @{@"adsource_price": extra[@"adsource_price"], @"unitId": self.adKey.key, @"unitName": self.adKey.keyId, @"placeId": self.adKey.placementid, @"adFormat": ADTypeReward, @"mediator": @"topon", @"networkName": extra[@"adsource_id"], @"currency": extra[@"currency"]};
    [self notifyOnAdShowedData:data];
    [self notifyOnAdImpression];
}

-(void) rewardedVideoDidCloseForPlacementID:(NSString*)placementID rewarded:(BOOL)rewarded extra:(NSDictionary *)extra {
    NSLog(@" applovin reward ad wasHiddenIn isRewarded = %d", rewarded);
    self.isShowing = NO;
    if(rewarded){
        [self notifyOnAdRewarded];
    }
    self.isRewarded = false;
    [self notifyOnAdClosed];
}

-(void) rewardedVideoDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@" AT reward ad wasClickedIn");
    [self notifyOnAdClicked];
}
@end
#endif
