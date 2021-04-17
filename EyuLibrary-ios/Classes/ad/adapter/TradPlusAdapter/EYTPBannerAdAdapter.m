//
//  EYTPBannerAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2020/12/30.
//

#ifdef TRADPLUS_ENABLED
#import "EYTPBannerAdAdapter.h"
#import "EYAdManager.h"

@implementation EYTPBannerAdAdapter
-(void) loadAd
{
    NSLog(@"tp bannerAd ");
    if([self isAdLoaded])
    {
        self.isLoadSuccess = true;
        [self notifyOnAdLoaded];
        return;
    } else if (!self.isLoading) {
        self.isLoadSuccess = false;
        self.isLoading = true;
        self.bannerView = [[MsBannerView alloc] init];
//        self.bannerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
        self.bannerView.delegate = self;
        [self.bannerView setAdUnitID:self.adKey.key];
        [self.bannerView loadAd];
        [self startTimeoutTask];
    } else {
        self.isLoadSuccess = false;
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

- (bool)isAdLoaded {
    return self.bannerView != NULL && self.isLoadSuccess;
}

- (bool)showAdGroup:(UIView *)viewGroup {
    if (![self isAdLoaded]) {
        return false;
    }
    viewGroup.bannerAdapter = self;
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat w = viewGroup.frame.size.width;
    CGFloat h = viewGroup.frame.size.height;
    if (w == 0 || h == 0) {
        w = [UIScreen mainScreen].bounds.size.width;
        h = 50;
    };
    [viewGroup addSubview:self.bannerView];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:_bannerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_bannerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_bannerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:w];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_bannerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:h];
    [viewGroup addConstraint:centerX];
    [viewGroup addConstraint:centerY];
    [viewGroup addConstraint:width];
    [viewGroup addConstraint:height];
    return true;
}

- (UIViewController *)viewControllerForPresentingModalView
{
    if (EYAdManager.sharedInstance.rootViewController != NULL) {
        return EYAdManager.sharedInstance.rootViewController;
    }
    return UIApplication.sharedApplication.keyWindow.rootViewController;
}

- (UIView *)getBannerView {
    return self.bannerView;
}

//ad加载成功
- (void)MsBannerViewLoaded:(MsBannerView *)adView {
    self.isLoadSuccess = true;
    self.isLoading = false;
    NSLog(@"tpbanner ad didLoad");
    [self notifyOnAdLoaded];
}
- (void)MsBannerView:(MsBannerView *)adView didFailWithError:(NSError *)error
{
    NSLog(@"tp banner ad failed to load with error: %@", error);
    self.isLoading = false;
    self.isLoadSuccess = false;
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}
- (void)MsBannerViewClicked:(MsBannerView *)adView {
    [self notifyOnAdClicked];
}
@end
#endif
