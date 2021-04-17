//
//  FbRewardAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//

#include "EYAdmobRewardAdAdapter.h"
#include "EYAdManager.h"
#ifdef ADMOB_MEDIATION_ENABLED
#import <VungleAdapter/VungleAdapter.h>
#endif
#ifdef ADMOB_ADS_ENABLED

@implementation EYAdmobRewardAdAdapter

@synthesize isRewarded = _isRewarded;

-(void) loadAd
{
    NSLog(@"AdmobRewardAdAdapter loadAd #############. adId = #%@#", self.adKey.key);
    if([self isShowing ]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
    }else if([self isAdLoaded])
    {
        [self notifyOnAdLoaded];
    }else if([self isAdLoaded]){
        NSLog(@"one AdmobRewardAdAdapter was already loaded.");
        [self notifyOnAdLoadFailedWithError:ERROR_OTHER_ADMOB_REWARD_AD_LOADED];
    }else if(!self.isLoading)
    {
        self.isLoading = YES;
        
        GADRequest *request = [GADRequest request];
#ifdef ADMOB_MEDIATION_ENABLED
        VungleAdNetworkExtras *extras = [[VungleAdNetworkExtras alloc] init];
        extras.allPlacements = [EYAdManager sharedInstance].vunglePlacementIds;
        [request registerAdNetworkExtras:extras];
#endif
        //request.testDevices = @[ @"9b80927958fbfef89ca335966239ca9a",@"46fd4577df207ecb050bffa2948d5e52" ];
        [GADRewardedAd loadWithAdUnitID:self.adKey.key
                                request:request
                      completionHandler:^(GADRewardedAd *ad, NSError *error) {
            self.isLoading = NO;
            [self cancelTimeoutTask];
            if (error) {
                NSLog(@"admob Rewarded ad failed to load with error: %@", [error localizedDescription]);
                [self notifyOnAdLoadFailedWithError:(int)error.code];
                return;
            }
            self.rewardedAd = ad;
            self.rewardedAd.fullScreenContentDelegate = self;
            [self notifyOnAdLoaded];
            NSLog(@"Admob Rewarded ad loaded.");
        }];
        [self startTimeoutTask];
    }else{
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"AdmobRewardAdAdapter showAd #############.");
    if([self isAdLoaded])
    {
        self.isRewarded = NO;
        self.isShowing = YES;
        __weak typeof(self) weakSelf = self;
        [self.rewardedAd presentFromRootViewController:controller
                              userDidEarnRewardHandler:^{
            // TODO: Reward the user!
            weakSelf.isRewarded = true;
        }];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    return self.rewardedAd != NULL;
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"admobAd did fail to present full screen content.");
    self.isShowing = NO;
}

/// Tells the delegate that the ad presented full screen content.
- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"admobAd did present full screen content.");
    [self notifyOnAdShowed];
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
   NSLog(@"admobAd did dismiss full screen content.");
    if(self.isRewarded){
        [self notifyOnAdRewarded];
    }
    self.rewardedAd = NULL;
    self.isShowing = NO;
    self.isRewarded = NO;
    [self notifyOnAdClosed];
}

- (void)adDidRecordImpression:(id<GADFullScreenPresentingAd>)ad {
    [self notifyOnAdImpression];
}

@end
#endif /*ADMOB_ADS_ENABLED*/
