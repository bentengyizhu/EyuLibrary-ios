//
//  EYAdmobBannerAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/7.
//


//#include "EYBannerAdAdapter.h"

#ifdef ADMOB_ADS_ENABLED
#include "EYAdmobBannerAdapter.h"

@implementation EYAdmobBannerAdapter
@synthesize bannerAdView = _bannerAdView;
bool _adLoaded = false;

-(void) loadAd:(UIViewController *)controller
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
        self.bannerAdView.rootViewController = controller;
        self.bannerAdView.delegate = self;
        [self.bannerAdView loadRequest:[[GADRequest alloc] init]];
    }
}

- (bool)showAdGroup:(UIView *)viewGroup {
    if (self.bannerAdView == NULL) {
        return false;
    }
    [self.bannerAdView removeFromSuperview];
    CGRect bounds = CGRectMake(0,0, self.bannerAdView.frame.size.width, self.bannerAdView.frame.size.height);
    NSLog(@"lwq, bannerAdView witdh = %f, height = %f ", bounds.size.width, bounds.size.height);
    self.bannerAdView.frame = bounds;
    [viewGroup addSubview:self.bannerAdView];
    return true;
}

- (UIView *)getBannerView {
    return self.bannerAdView;
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
