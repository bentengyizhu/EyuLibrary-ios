//
//  EYATBannerAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/23.
//
#ifdef ANYTHINK_ENABLED
#import "EYATBannerAdAdapter.h"
#include "EYAdManager.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@implementation EYATBannerAdAdapter
-(void) loadAd
{
    NSLog(@" lwq, at bannerAd ");
    if([self isAdLoaded])
    {
        [self notifyOnAdLoaded];
        return;
    } else if (!self.isLoading) {
        self.isLoading = true;
        GADAdSize admobSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth([UIScreen mainScreen].bounds.size.width);
        [[ATAdManager sharedManager] loadADWithPlacementID:self.adKey.key extra:@{kATAdLoadingExtraBannerAdSizeKey:[NSValue valueWithCGSize:admobSize.size], kATAdLoadingExtraBannerSizeAdjustKey:@NO,kATAdLoadingExtraAdmobBannerSizeKey:[NSValue valueWithCGSize:admobSize.size],kATAdLoadingExtraAdmobAdSizeFlagsKey:@(admobSize.flags)} delegate:self];
        [self startTimeoutTask];
    } else {
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

- (bool)isAdLoaded {
    return [[ATAdManager sharedManager] bannerAdReadyForPlacementID:self.adKey.key];
}

- (bool)showAdGroup:(UIView *)viewGroup {
    if (![self isAdLoaded]) {
        return false;
    }
    ATBannerView *bannerView = [[ATAdManager sharedManager] retrieveBannerViewForPlacementID:self.adKey.key];
    bannerView.delegate = self;
    bannerView.presentingViewController = EYAdManager.sharedInstance.rootViewController;
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
//    [viewGroup layoutIfNeeded];
//    bannerView.frame = viewGroup.bounds;
    CGFloat w = viewGroup.frame.size.width;
    CGFloat h = viewGroup.frame.size.height;
    [viewGroup addSubview:bannerView];
//    viewGroup.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:w];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:h];
    [viewGroup addConstraint:centerX];
    [viewGroup addConstraint:centerY];
    [viewGroup addConstraint:width];
    [viewGroup addConstraint:height];
    return true;
}

#pragma mark - loading delegate
-(void) didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"lwq atbanner ad didLoad");
    self.isLoading = false;
    [self notifyOnAdLoaded];
}

-(void) didFailToLoadADWithPlacementID:(NSString* )placementID error:(NSError *)error {
    NSLog(@"lwq,at banner ad failed to load with error: %@", error);
    self.isLoading = false;
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

#pragma mark - banner delegate

-(void) bannerView:(ATBannerView *)bannerView failedToAutoRefreshWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSLog(@"ATBannerViewController::bannerView:failedToAutoRefreshWithPlacementID:%@ error:%@", placementID, error);
}
-(void) bannerView:(ATBannerView*)bannerView didTapCloseButtonWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra {
    NSLog(@"ATBannerViewController::bannerView:didTapCloseButtonWithPlacementID:%@ extra: %@", placementID,extra);
}

- (void)bannerView:(ATBannerView *)bannerView didAutoRefreshWithPlacement:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATBannerViewController::bannerView:didAutoRefreshWithPlacement:%@", placementID);
}


- (void)bannerView:(ATBannerView *)bannerView didClickWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"lwq,at bannerad didClick");
    [self notifyOnAdClicked];
}

- (void)bannerView:(ATBannerView *)bannerView didShowAdWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"lwq atbanner ad willLogImpression");
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

- (void)bannerView:(ATBannerView *)bannerView didCloseWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"lwq atbanner ad close");
}


- (void)bannerView:(ATBannerView *)bannerView didDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    
}

@end
#endif
