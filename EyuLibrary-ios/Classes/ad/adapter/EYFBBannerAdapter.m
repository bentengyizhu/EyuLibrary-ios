//
//  EYFBBannerAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/9.
//

#ifdef FB_ADS_ENABLED
#include "EYFBBannerAdapter.h"

@interface EYFBBannerAdapter()
@property(nonatomic,assign)bool fbadLoaded;
@end

@implementation EYFBBannerAdapter
@synthesize bannerView = _bannerView;
- (instancetype)initWithAdKey:(EYAdKey *)adKey adGroup:(EYAdGroup *)group {
    self = [super initWithAdKey:adKey adGroup:group];
    if (self) {
        self.fbadLoaded = false;
    }
    return self;
}
-(void) loadAd:(UIViewController *)controller {
    NSLog(@"lwq, fb bannerAd");
    if([self isAdLoaded])
    {
        [self notifyOnAdLoaded];
        return;
    }
    if (self.bannerView == NULL) {
        self.bannerView = [[FBAdView alloc] initWithPlacementID:self.adKey.key adSize:kFBAdSizeHeight50Banner rootViewController:controller];
        self.bannerView.delegate = self;
        self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.bannerView loadAd];
    }
}

- (bool)showAdGroup:(UIView *)viewGroup {
    if (self.bannerView == NULL) {
        return false;
    }
    [self.bannerView removeFromSuperview];
//    CGRect bounds = CGRectMake(0,0, self.bannerView.frame.size.width, self.bannerView.frame.size.height);
//    NSLog(@"lwq, bannerAdView witdh = %f, height = %f ", bounds.size.width, bounds.size.height);
//    self.bannerView.frame = bounds;
    CGFloat w = self.bannerView.frame.size.width;
    CGFloat h = self.bannerView.frame.size.height;
    [viewGroup addSubview:self.bannerView];
    viewGroup.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:w];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:h];
    [viewGroup addConstraint:centerX];
    [viewGroup addConstraint:centerY];
    [viewGroup addConstraint:width];
    [viewGroup addConstraint:height];
    return true;
}

- (UIView *)getBannerView {
    return self.bannerView;
}

-(bool) isAdLoaded
{
    return self.fbadLoaded;
}

- (void)adViewDidLoad:(FBAdView *)adView {
    NSLog(@"lwq fbbanner ad didLoad");
    self.isLoading = false;
    self.fbadLoaded = true;
    [self notifyOnAdLoaded];
}

- (void)adView:(FBAdView *)adView didFailWithError:(NSError *)error {
    NSLog(@"lwq,fb banner ad failed to load with error: %@", error);
    self.isLoading = false;
    self.fbadLoaded = false;
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

- (void)adViewWillLogImpression:(FBAdView *)adView {
    NSLog(@"lwq fbbanner ad willLogImpression");
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

- (void)adViewDidFinishHandlingClick:(FBAdView *)adView {
    NSLog(@"lwq,fb bannerad didFinishHandlingClick");
}

- (void)adViewDidClick:(FBAdView *)adView {
    NSLog(@"lwq,fb bannerad didClick");
    [self notifyOnAdClicked];
}
@end
#endif /*FB_ADS_ENABLED*/
