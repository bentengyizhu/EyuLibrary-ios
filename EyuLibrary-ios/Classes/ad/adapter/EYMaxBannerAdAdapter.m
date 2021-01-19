//
//  EYMaxBannerAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2021/1/19.
//

#ifdef APPLOVIN_MAX_ENABLED

#import "EYMaxBannerAdAdapter.h"

@implementation EYMaxBannerAdAdapter
-(void) loadAd
{
    NSLog(@" lwq, laod max bannerAd");
    if([self isAdLoaded])
    {
        self.isLoadSuccess = true;
        [self notifyOnAdLoaded];
        return;
    } else if (!self.isLoading) {
        self.isLoading = true;
        self.isLoadSuccess = false;
        self.adView = [[MAAdView alloc] initWithAdUnitIdentifier: self.adKey.key];
        self.adView.delegate = self;
        [self.adView loadAd];
//        self.adView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
        [self.adView loadAd];
        [self startTimeoutTask];
    } else {
        self.isLoadSuccess = false;
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

- (bool)showAdGroup:(UIView *)viewGroup {
    if (![self isAdLoaded]) {
        return false;
    }
    self.adView.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat w = viewGroup.frame.size.width;
    CGFloat h = viewGroup.frame.size.height;
    [viewGroup addSubview:self.adView];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:_adView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_adView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_adView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:w];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_adView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:h];
    [viewGroup addConstraint:centerX];
    [viewGroup addConstraint:centerY];
    [viewGroup addConstraint:width];
    [viewGroup addConstraint:height];
    return true;
}

- (UIView *)getBannerView {
    return self.adView;
}

- (bool)isAdLoaded {
    return self.adView != NULL && self.isLoadSuccess;
}

#pragma mark - MAAdDelegate Protocol

- (void)didLoadAd:(MAAd *)ad {
    self.isLoadSuccess = true;
    self.isLoading = false;
    NSLog(@"lwq max banner ad didLoad");
    [self notifyOnAdLoaded];
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withErrorCode:(NSInteger)errorCode {
    NSLog(@"lwq,max banner ad failed to load with error: %ld", (long)errorCode);
    self.isLoading = false;
    self.isLoadSuccess = false;
    [self notifyOnAdLoadFailedWithError:(int)errorCode];
}

- (void)didClickAd:(MAAd *)ad {
    [self notifyOnAdClicked];
}

- (void)didFailToDisplayAd:(MAAd *)ad withErrorCode:(NSInteger)errorCode {
    NSLog(@"lwq,max banner ad failed to display with error: %ld", (long)errorCode);
}

- (void)didDisplayAd:(nonnull MAAd *)ad {}

- (void)didHideAd:(nonnull MAAd *)ad {}

- (void)didCollapseAd:(nonnull MAAd *)ad {}

- (void)didExpandAd:(nonnull MAAd *)ad {}

@end

#endif
