//
//  EYWMBannerAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2021/2/20.
//
#ifdef BYTE_DANCE_ADS_ENABLED

#import "EYWMBannerAdAdapter.h"
#import "EYAdManager.h"

@implementation EYWMBannerAdAdapter
-(void) loadAd {
    NSLog(@"lwq, wm bannerAd");
    if([self isAdLoaded])
    {
        [self notifyOnAdLoaded];
        self.isLoadSuccess = true;
        return;
    } else if (!self.isLoading) {
        self.isLoadSuccess = false;
        if (self.bannerView == NULL) {
            self.isLoading = true;
            self.bannerView = [[BUNativeExpressBannerView alloc] initWithSlotID:self.adKey.key rootViewController:[EYAdManager sharedInstance].rootViewController adSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 50)];
            self.bannerView.delegate = self;
            self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.bannerView loadAdData];
            [self startTimeoutTask];
        }
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
    if (self.bannerView == NULL) {
        return false;
    }
    [self.bannerView removeFromSuperview];
    CGFloat w = self.bannerView.frame.size.width;
    CGFloat h = self.bannerView.frame.size.height;
    if (w == 0 || h == 0) {
        w = [UIScreen mainScreen].bounds.size.width;
        h = 50;
    };
    [viewGroup addSubview:self.bannerView];
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

- (void)nativeExpressBannerAdViewDidLoad:(BUNativeExpressBannerView *)bannerAdView {
    self.isLoadSuccess = true;
    self.isLoading = false;
    NSLog(@"lwq wmbanner ad didLoad");
    [self notifyOnAdLoaded];
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError *)error {
    NSLog(@"lwq,wm banner ad failed to load with error: %@", error);
    self.isLoading = false;
    self.isLoadSuccess = false;
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

- (void)nativeExpressBannerAdViewDidClick:(BUNativeExpressBannerView *)bannerAdView {
    [self notifyOnAdClicked];
}

- (void)nativeExpressBannerAdViewRenderSuccess:(BUNativeExpressBannerView *)bannerAdView {
    
}

- (void)nativeExpressBannerAdViewRenderFail:(BUNativeExpressBannerView *)bannerAdView error:(NSError *)error {
    
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterwords {
    [self.bannerView removeFromSuperview];
    self.bannerView = NULL;
    [self notifyOnAdClosed];
}

- (void)nativeExpressBannerAdViewWillBecomVisible:(BUNativeExpressBannerView *)bannerAdView {
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

- (void)nativeExpressBannerAdViewDidCloseOtherController:(BUNativeExpressBannerView *)bannerAdView interactionType:(BUInteractionType)interactionType {
    
}
@end
#endif 

