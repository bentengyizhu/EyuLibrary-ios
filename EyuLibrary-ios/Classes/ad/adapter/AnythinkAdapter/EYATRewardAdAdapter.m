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
        EYuAd *ad = [self getEyuAd];
        ad.error = [[NSError alloc]initWithDomain:@"isshowingdomain" code:ERROR_AD_IS_SHOWING userInfo:nil];
        [self notifyOnAdLoadFailedWithError:ad];
    }else if([self isAdLoaded])
    {
        [self notifyOnAdLoaded:[self getEyuAd]];
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

-(EYuAd *) getEyuAd{
    EYuAd *ad = [EYuAd new];
    ad.unitId = self.adKey.key;
    ad.unitName = self.adKey.keyId;
    ad.placeId = self.adKey.placementid;
    ad.adFormat = ADTypeReward;
    ad.mediator = @"topon";
    return ad;
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
    [self notifyOnAdLoaded:[self getEyuAd]];
}

-(void) didFailToLoadADWithPlacementID:(NSString* )placementID error:(NSError *)error {
    NSLog(@" AT reward didFailToLoadAdWithError: %d, adKey = %@", (int)error.code, self.adKey);
    self.isLoading = false;
    [self cancelTimeoutTask];
    EYuAd *ad = [self getEyuAd];
    ad.error = error;
    [self notifyOnAdLoadFailedWithError:ad];
}

#pragma mark - showing delegate
-(void) rewardedVideoDidRewardSuccessForPlacemenID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSLog(@"AT Reward video ad is showed.");
    self.isRewarded = true;
}

-(void) rewardedVideoDidStartPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@" at reward ad wasDisplayedIn");
    EYuAd *ad = [self getEyuAd];
    [self notifyOnAdShowed:ad];
    [self notifyOnAdImpression: ad];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    ad.adRevenue = [numberFormatter stringFromNumber:extra[@"adsource_price"]];
    ad.networkName = extra[@"adsource_id"];
    [self notifyOnAdRevenue:ad];
}

-(void) rewardedVideoDidEndPlayingForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATRewardedVideoVideoViewController::rewardedVideoDidEndPlayingForPlacementID:%@ extra:%@", placementID, extra);
}

-(void) rewardedVideoDidFailToPlayForPlacementID:(NSString*)placementID error:(NSError*)error extra:(NSDictionary *)extra {
    NSLog(@" at reward ad wasDisplayedIn");
    EYuAd *ad = [self getEyuAd];
    [self notifyOnAdShowed:ad];
    [self notifyOnAdImpression: ad];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    ad.adRevenue = [numberFormatter stringFromNumber:extra[@"adsource_price"]];
    ad.networkName = extra[@"adsource_id"];
    [self notifyOnAdRevenue:ad];
}

-(void) rewardedVideoDidCloseForPlacementID:(NSString*)placementID rewarded:(BOOL)rewarded extra:(NSDictionary *)extra {
    NSLog(@" applovin reward ad wasHiddenIn isRewarded = %d", rewarded);
    self.isShowing = NO;
    if(rewarded){
        [self notifyOnAdRewarded:[self getEyuAd]];
    }
    self.isRewarded = false;
    [self notifyOnAdClosed:[self getEyuAd]];
}

-(void) rewardedVideoDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@" AT reward ad wasClickedIn");
    [self notifyOnAdClicked:[self getEyuAd]];
}
@end
#endif
