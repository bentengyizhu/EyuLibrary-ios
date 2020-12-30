//
//  EYTPBannerAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2020/12/30.
//

#ifdef TRADPLUS_ENABLED
#import "EYTPBannerAdAdapter.h"
#include "EYAdManager.h"

@implementation EYTPBannerAdAdapter
-(void) loadAd
{
    NSLog(@" lwq, tp bannerAd ");
    if ([EYAdManager sharedInstance].isTradPlusInited == false) {
        NSLog(@" lwq, tp init not compeleted");
        [self notifyOnAdLoadFailedWithError:ERROR_SDK_UNINITED];
        return;
    }
    if([self isAdLoaded])
    {
        self.isLoadSuccess = true;
        [self notifyOnAdLoaded];
        return;
    } else if (!self.isLoading) {
        self.isLoadSuccess = false;
        self.isLoading = true;
        self.bannerView = [[MsBannerView alloc] init];
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
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat w = viewGroup.frame.size.width;
    CGFloat h = viewGroup.frame.size.height;
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

//ad加载成功
- (void)MsBannerViewLoaded:(MsBannerView *)adView {
    self.isLoadSuccess = true;
    self.isLoading = false;
    NSLog(@"lwq tpbanner ad didLoad");
    [self notifyOnAdLoaded];
}
- (void)MsBannerView:(MsBannerView *)adView didFailWithError:(NSError *)error
{
    NSLog(@"lwq,tp banner ad failed to load with error: %@", error);
    self.isLoading = false;
    self.isLoadSuccess = false;
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}
- (void)MsBannerViewClicked:(MsBannerView *)adView {
    [self notifyOnAdClicked];
}
@end
#endif
