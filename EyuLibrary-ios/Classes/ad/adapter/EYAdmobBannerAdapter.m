//
//  EYAdmobBannerAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/7.
//

#import "EYAdmobBannerAdapter.h"
//#include "EYBannerAdAdapter.h"

#ifdef ADMOB_ADS_ENABLED

@implementation EYAdmobBannerAdapter
@synthesize bannerAdView = _bannerAdView;
bool _adLoaded = false;

-(void) loadAd
{
    NSLog(@" lwq, admob bannerAd ");
    if([self isAdLoaded])
    {
        [self notifyOnAdLoaded];
        return;
    }
    if (self.bannerAdView == NULL) {
        self.bannerAdView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeSmartBannerPortrait];
        self.bannerAdView.adUnitID = self.adKey.keyId;
        self.bannerAdView.delegate = self;
        [self.bannerAdView loadRequest:[[GADRequest alloc] init]];
    }
}

- (bool)showAdWithController:(UIViewController *)controller {
    if ([self isAdLoaded])
    {
        self.bannerAdView.rootViewController = controller;
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    return _adLoaded;
}

#pragma mark GADBannerViewDelegate implementation
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    self.isLoading = false;
    _adLoaded = true;
    [self notifyOnAdLoaded];
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    self.isLoading = false;
    _adLoaded = false;
    [self.delegate onAdLoadFailed:self withError:(int)error.code];
    NSLog(@"lwq, admob banner:didFailToReceiveAdWithError: %@, adKey = %@", [error localizedDescription], self.adKey);
}

- (void)adViewWillPresentScreen:(GADBannerView *)bannerView {
    NSLog(@"lwq, admob bannerWillPresentScreen");
    self.isShowing = true;
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"lwq, admob bannerWillDismissScreen");
}

- (void)adViewDidDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"lwq, admob bannerDidDismissScreen");
    self.isShowing = false;
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView {
    NSLog(@"lwq, admob bannerWillLeaveApplication");
    [self notifyOnAdClicked];
}
@end
#endif /*ADMOB_ADS_ENABLED*/
