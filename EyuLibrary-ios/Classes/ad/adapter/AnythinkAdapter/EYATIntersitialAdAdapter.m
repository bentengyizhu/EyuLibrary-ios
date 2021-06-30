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
        EYuAd *ad = [self getEyuAd];
        ad.error = [[NSError alloc]initWithDomain:@"isshowingdomain" code:ERROR_AD_IS_SHOWING userInfo:nil];
        [self notifyOnAdLoadFailedWithError:ad];
    }else if([self isAdLoaded]){
        [self notifyOnAdLoaded: [self getEyuAd]];
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

-(EYuAd *) getEyuAd{
    EYuAd *ad = [EYuAd new];
    ad.unitId = self.adKey.key;
    ad.unitName = self.adKey.keyId;
    ad.placeId = self.adKey.placementid;
    ad.adFormat = ADTypeInterstitial;
    ad.mediator = @"topon";
    return ad;
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
    EYuAd *ad = [self getEyuAd];
    [self notifyOnAdShowed:ad];
    [self notifyOnAdImpression: ad];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatteralloc] init];
    ad.networkName = extra[@"adsource_id"];
    ad.adRevenue = [numberFormatter stringFromNumber:extra[@"adsource_price"]];
    [self notifyOnAdRevenue:ad];
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
    [self notifyOnAdClosed: [self getEyuAd]];
}

-(void) interstitialDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"AT interstitialWillLeaveApplication");
    [self notifyOnAdClicked: [self getEyuAd]];
}

- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSLog(@"AT interstitial:didFailToReceiveAdWithError: %@, adKey = %@", [error localizedDescription], self.adKey);
    self.isLoading = false;
    [self cancelTimeoutTask];
    EYuAd *ad = [self getEyuAd];
    ad.error = error;
    [self notifyOnAdLoadFailedWithError:ad];
}

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"AT interstitialDidReceiveAd adKey = %@", self.adKey);
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded: [self getEyuAd]];
}
@end
#endif
