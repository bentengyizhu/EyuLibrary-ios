//
//  EYMtgRewardAdAdapter.mm
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef MTG_ADS_ENABLED

#include "EYMtgRewardAdAdapter.h"
#import <MTGSDK/MTGSDK.h>
#import <MTGSDKReward/MTGRewardAdManager.h>

@interface EYMtgRewardAdAdapter()<MTGRewardAdLoadDelegate,MTGRewardAdShowDelegate>
@property(nonatomic,assign)bool isLoadSuccess;
@end

@implementation EYMtgRewardAdAdapter

-(void) loadAd
{
    NSLog(@" lwq, mtg loadAd isAdLoaded = %d", [self isAdLoaded]);
    if([self isShowing ]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
    }else if([self isAdLoaded])
    {
        [self notifyOnAdLoaded];
    }else if(![self isLoading] )
    {
        self.isLoading = true;
        
        [self startTimeoutTask];
        [[MTGRewardAdManager sharedInstance] loadVideoWithPlacementId:self.adKey.placementid unitId:self.adKey.key delegate:self];
//        [[MTGRewardAdManager sharedInstance] loadVideo:self.adKey.key delegate:self];
    }else{
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@" lwq, mtg showAd ");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        [[MTGRewardAdManager sharedInstance] showVideoWithPlacementId:self.adKey.placementid unitId:self.adKey.key withRewardId:@"1" userId:@"1" delegate:self viewController:controller];
//        [[MTGRewardAdManager sharedInstance] showVideo:self.adKey.key withRewardId:@"1" userId:@"1" delegate:self viewController:controller];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    bool isAdLoaded = [[MTGRewardAdManager sharedInstance] isVideoReadyToPlayWithPlacementId:self.adKey.placementid unitId:self.adKey.key];
//    bool isAdLoaded = [[MTGRewardAdManager sharedInstance] isVideoReadyToPlay:self.adKey.key];
    NSLog(@" lwq, mtg Reward video ad isAdLoaded = %d", isAdLoaded);
    return self.isLoadSuccess ;
}

#pragma mark MTGRewardAdLoadDelegate

- (void)onVideoAdLoadSuccess:(NSString *)placementId unitId:(NSString *)unitId {
    NSLog(@"lwq, mtg reawrded video did load");
    self.isLoading = false;
    [self cancelTimeoutTask];
    self.isLoadSuccess = true;
    [self notifyOnAdLoaded];
}


- (void)onAdLoadSuccess:(NSString *)placementId unitId:(NSString *)unitId {
    NSLog(@"lwq, mtg reawrded material load success");
//    self.isLoading = false;
//    self.isLoadSuccess = true;
    [self cancelTimeoutTask];
}

- (void)onVideoAdLoadFailed:(NSString *)placementId unitId:(NSString *)unitId error:(NSError *)error {
    NSLog(@"lwq, mtg rewarded video material load fail unitId = %@, error = %@", unitId, error);
    self.isLoading = false;
    self.isLoadSuccess = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

#pragma mark MTGRewardAdShowDelegate

- (void)onVideoAdShowSuccess:(NSString *)placementId unitId:(NSString *)unitId {
    NSLog(@"lwq, mtg rewarded video will visible, unitId = %@", unitId);
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

/**
 *  Called when the ad display success
 *
 *  @param unitId - the unitId string of the Ad that display success.
 */
- (void)onVideoAdShowFailed:(NSString *)placementId unitId:(NSString *)unitId withError:(NSError *)error {
    NSLog(@"lwq, mtg onVideoAdShowFailed unitId = %@, error = %@", unitId, error);
}

/**
 *  Called when the ad is clicked
 *
 *  @param unitId - the unitId string of the Ad clicked.
 */
- (void)onVideoAdClicked:(NSString *)placementId unitId:(NSString *)unitId {
    
}

/**
 *  Called when the ad has been dismissed from being displayed, and control will return to your app
 *
 *  @param unitId      - the unitId string of the Ad that has been dismissed
 *  @param converted   - BOOL describing whether the ad has converted
 *  @param rewardInfo  - the rewardInfo object containing the info that should be given to your user.
 */
- (void)onVideoAdDismissed:(NSString *)placementId unitId:(NSString *)unitId withConverted:(BOOL)converted withRewardInfo:(MTGRewardAdInfo *)rewardInfo {
    NSLog(@"lwq, mtg rewarded video did close, unitId = %@", unitId);
    if(rewardInfo){
        [self notifyOnAdRewarded];
    }
    self.isLoadSuccess = false;
    self.isShowing = NO;
    [self notifyOnAdClosed];
}

@end
#endif /*MTG_ADS_ENABLED*/
