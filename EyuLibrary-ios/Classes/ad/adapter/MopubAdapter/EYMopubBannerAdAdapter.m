//
//  EYMopubBannerAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2021/4/12.
//
#ifdef MOPUB_ENABLED
#import "EYMopubBannerAdAdapter.h"
#import "EYAdManager.h"

@implementation EYMopubBannerAdAdapter
-(void) loadAd {
    NSLog(@" mopub bannerAd");
    if([self isAdLoaded])
    {
        [self notifyOnAdLoaded:[self getEyuAd]];
        self.isLoadSuccess = true;
        return;
    } else if (!self.isLoading) {
        self.isLoadSuccess = false;
        if (self.adView == NULL) {
            self.adView = [[MPAdView alloc] initWithAdUnitId:self.adKey.key];
            self.adView.delegate = self;
            self.adView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.adView loadAdWithMaxAdSize:CGSizeMake(UIScreen.mainScreen.bounds.size.width, 50)];
            self.isLoading = true;
        }
    } else {
        self.isLoadSuccess = false;
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
    ad.adFormat = ADTypeBanner;
    ad.mediator = @"mopub";
    return ad;
}

- (bool)isAdLoaded {
    return self.adView != NULL && self.isLoadSuccess;
}

- (bool)showAdGroup:(UIView *)viewGroup {
    if (self.adView == NULL) {
        return false;
    }
    viewGroup.bannerAdapter = self;
    [self.adView removeFromSuperview];
    CGFloat w = self.adView.frame.size.width;
    CGFloat h = self.adView.frame.size.height;
    if (w == 0 || h == 0) {
        w = [UIScreen mainScreen].bounds.size.width;
        h = 50;
    };
    [viewGroup addSubview:self.adView];
//    self.adView.frame = CGRectMake(0, 0, w, h);
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.adView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.adView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.adView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:w];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.adView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:h];
    [viewGroup addConstraint:centerX];
    [viewGroup addConstraint:centerY];
    [viewGroup addConstraint:width];
    [viewGroup addConstraint:height];
    return true;
}

- (UIView *)getBannerView {
    return self.adView;
}

- (void)adViewDidLoadAd:(MPAdView *)view adSize:(CGSize)adSize {
    self.isLoadSuccess = true;
    self.isLoading = false;
    NSLog(@"mopub ad didLoad");
    [self notifyOnAdLoaded:[self getEyuAd]];
}

- (void)adView:(MPAdView *)view didFailToLoadAdWithError:(NSError *)error {
    self.adView = NULL;
    NSLog(@"mopub banner ad failed to load with error: %@", error);
    self.isLoading = false;
    self.isLoadSuccess = false;
    EYuAd *ad = [self getEyuAd];
    ad.error = error;
    [self notifyOnAdLoadFailedWithError:ad];
}

- (UIViewController *)viewControllerForPresentingModalView {
    return [EYAdManager sharedInstance].rootViewController;
}

@end
#endif
