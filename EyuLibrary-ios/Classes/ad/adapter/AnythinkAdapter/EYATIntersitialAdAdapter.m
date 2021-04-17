//
//  EYATIntersitialAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/19.
//

#ifdef ANYTHINK_ENABLED
#import "EYATIntersitialAdAdapter.h"

@implementation EYATIntersitialAdAdapter
-(void) loadAd
{
    NSLog(@"AT loadAd interstitialAd");
    if([self isShowing]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
    }else if([self isAdLoaded]){
        [self notifyOnAdLoaded];
    }else if (!self.isLoading){
        [[ATAdManager sharedManager] loadADWithPlacementID:self.adKey.key extra:@{} delegate:self];
        [self startTimeoutTask];
        self.isLoading = true;
    } else {
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

-(bool) isAdLoaded
{
    return [[ATAdManager sharedManager] interstitialReadyForPlacementID:self.adKey.key];
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"AT showAd [self isAdLoaded] = %d", [self isAdLoaded]);
    if([self isAdLoaded])
    {
        self.isShowing = true;
        [[ATAdManager sharedManager] showInterstitialWithPlacementID:self.adKey.key inViewController:controller delegate:self];
        return true;
    }
    return false;
}

#pragma mark - showing delegate
-(void) interstitialDidShowForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"AT interstitialWillPresentScreen");
    [self notifyOnAdShowed];
    [self notifyOnAdShowedData:extra];
    [self notifyOnAdImpression];
}

-(void) interstitialFailedToShowForPlacementID:(NSString*)placementID error:(NSError*)error extra:(NSDictionary *)extra {
    NSLog(@"ATInterstitialViewController::interstitialFailedToShowForPlacementID:%@ error:%@ extra:%@", placementID, error, extra);
}

-(void) interstitialDidFailToPlayVideoForPlacementID:(NSString*)placementID error:(NSError*)error extra:(NSDictionary*)extra {
    NSLog(@"ATInterstitialViewController::interstitialDidFailToPlayVideoForPlacementID:%@ error:%@ extra:%@", placementID, error, extra);
}

-(void) interstitialDidStartPlayingVideoForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATInterstitialViewController::interstitialDidStartPlayingVideoForPlacementID:%@ extra:%@", placementID, extra);
}

-(void) interstitialDidEndPlayingVideoForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATInterstitialViewController::interstitialDidEndPlayingVideoForPlacementID:%@ extra:%@", placementID, extra);
}

-(void) interstitialDidCloseForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"AT interstitialDidDismissScreen");
    self.isShowing = false;
    [self notifyOnAdClosed];
}

-(void) interstitialDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"AT interstitialWillLeaveApplication");
    [self notifyOnAdClicked];
}

- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSLog(@"AT interstitial:didFailToReceiveAdWithError: %@, adKey = %@", [error localizedDescription], self.adKey);
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"AT interstitialDidReceiveAd adKey = %@", self.adKey);
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}
@end
#endif
