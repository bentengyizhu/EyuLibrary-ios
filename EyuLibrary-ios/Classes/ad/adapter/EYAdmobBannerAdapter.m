//
//  EYAdmobBannerAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/7.
//


//#include "EYBannerAdAdapter.h"

#ifdef ADMOB_ADS_ENABLED
#include "EYAdmobBannerAdapter.h"
#include "EYAdManager.h"

@interface EYAdmobBannerAdapter()
@property(nonatomic,assign)bool adLoaded;
@end

@implementation EYAdmobBannerAdapter
@synthesize bannerAdView = _bannerAdView;

- (instancetype)initWithAdKey:(EYAdKey *)adKey adGroup:(EYAdGroup *)group {
    self = [super initWithAdKey:adKey adGroup:group];
    if (self) {
        self.adLoaded = false;
    }
    return self;
}
-(void) loadAd
{
    NSLog(@" lwq, admob bannerAd ");
    if([self isAdLoaded])
    {
        [self notifyOnAdLoaded];
        return;
    }
    self.isLoading = true;
    if (self.bannerAdView == NULL) {
        self.bannerAdView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeSmartBannerPortrait];
        self.bannerAdView.adUnitID = self.adKey.key;
        self.bannerAdView.rootViewController = EYAdManager.sharedInstance.rootViewController;
        self.bannerAdView.delegate = self;
        self.bannerAdView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.bannerAdView loadRequest:[[GADRequest alloc] init]];
    }
}

- (bool)showAdGroup:(UIView *)viewGroup {
    if (self.bannerAdView == NULL) {
        return false;
    }
    [self.bannerAdView removeFromSuperview];
//    CGRect bounds = CGRectMake(0,0, self.bannerAdView.frame.size.width, self.bannerAdView.frame.size.height);
//    NSLog(@"lwq, bannerAdView witdh = %f, height = %f ", bounds.size.width, bounds.size.height);
//    self.bannerAdView.frame = bounds;
    CGFloat w = self.bannerAdView.frame.size.width;
    CGFloat h = self.bannerAdView.frame.size.height;
//    viewGroup.translatesAutoresizingMaskIntoConstraints = NO;
    [viewGroup addSubview:self.bannerAdView];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.bannerAdView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.bannerAdView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.bannerAdView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:w];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.bannerAdView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:h];
    [viewGroup addConstraint:centerX];
    [viewGroup addConstraint:centerY];
    [viewGroup addConstraint:width];
    [viewGroup addConstraint:height];
    return true;
}

- (UIView *)getBannerView {
    return self.bannerAdView;
}

-(bool) isAdLoaded
{
    return self.adLoaded;
}

#pragma mark GADBannerViewDelegate implementation
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    self.isLoading = false;
    self.adLoaded = true;
    [self notifyOnAdLoaded];
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    self.isLoading = false;
    self.adLoaded = false;
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
