//
//  EYABUBannerAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/8.
//

#ifdef ABUADSDK_ENABLED
#import "EYABUBannerAdAdapter.h"
#import "EYAdManager.h"
@implementation EYABUBannerAdAdapter
-(void) loadAd {
    NSLog(@"abu bannerAd");
    if([self isAdLoaded])
    {
        [self notifyOnAdLoaded:[self getEyuAd]];
        self.isLoadSuccess = true;
        return;
    } else if (!self.isLoading) {
        self.isLoadSuccess = false;
        if (self.bannerAd == NULL) {
            self.bannerAd = [[ABUBannerAd alloc] initWithAdUnitID:self.adKey.key rootViewController:[EYAdManager sharedInstance].rootViewController adSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 50) autoRefreshTime:30];
            self.bannerAd.delegate = self;
//            self.bannerAd.translatesAutoresizingMaskIntoConstraints = NO;
            //该逻辑用于判断配置是否拉取成功。如果拉取成功，可直接加载广告，否则需要调用setConfigSuccessCallback，传入block并在block中调用加载广告。SDK内部会在配置拉取成功后调用传入的block
                __weak typeof(self) weakself = self;
                //当前配置拉取成功，直接loadAdData
                if(self.bannerAd.hasAdConfig){
                    [self.bannerAd loadAdData];
                    [self startTimeoutTask];
                }else{
                    //当前配置未拉取成功，在成功之后会调用该callback
                    [self.bannerAd setConfigSuccessCallback:^{
                        [weakself.bannerAd loadAdData];
                        [weakself startTimeoutTask];
                    }];
                }
            self.isLoading = true;
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
    viewGroup.bannerAdapter = self;
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
    UIView *viewGroup = [UIView new];
    viewGroup.bannerAdapter = self;
    [viewGroup addSubview:self.bannerView];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [viewGroup addConstraint:centerX];
    [viewGroup addConstraint:centerY];
    [viewGroup addConstraint:width];
    [viewGroup addConstraint:height];
    return viewGroup;
}

-(EYuAd *) getEyuAd{
    EYuAd *ad = [EYuAd new];
    ad.unitId = self.adKey.key;
    ad.unitName = self.adKey.keyId;
    ad.placeId = self.adKey.placementid;
    ad.adFormat = ADTypeBanner;
    ad.mediator = @"abu";
    return ad;
}

/**
 This method is called when bannerAdView ad slot loaded successfully.
 @param bannerView : view for bannerView
 */
- (void)bannerAdDidLoad:(ABUBannerAd *_Nonnull)bannerAd bannerView:(UIView *)bannerView{
    self.bannerView = bannerView;
    self.isLoadSuccess = true;
    self.isLoading = false;
    NSLog(@"abud ad didLoad");
    [self notifyOnAdLoaded:[self getEyuAd]];
}

/**
 This method is called when bannerAdView ad slot failed to load.
 @param error : the reason of error
 */
- (void)bannerAd:(ABUBannerAd *_Nonnull)bannerAd didLoadFailWithError:(NSError *_Nullable)error{
    self.bannerView = NULL;
    self.bannerAd = NULL;
    NSLog(@"abu banner ad failed to load with error: %@", error);
    self.isLoading = false;
    self.isLoadSuccess = false;
    EYuAd *ad = [self getEyuAd];
    ad.error = error;
    [self notifyOnAdLoadFailedWithError:ad];
}

/**
This method is called when bannerAdView ad slot success to show.
*/
- (void)bannerAdDidBecomVisible:(ABUBannerAd *_Nonnull)ABUBannerAd bannerView:(UIView *)bannerView{
    EYuAd *ad = [self getEyuAd];
    [self notifyOnAdShowed: ad];
    [self notifyOnAdImpression: ad];
    ad.adRevenue = ABUBannerAd.getPreEcpm;
    [self notifyOnAdRevenue:ad];
}

/**
 * This method is called when FullScreen modal has been presented.Include appstore jump.
 *  弹出详情广告页
 */
- (void)bannerAdWillPresentFullScreenModal:(ABUBannerAd *_Nonnull)ABUBannerAd bannerView:(UIView *)bannerView{
    
}

/**
 ** This method is called when FullScreen modal has been dismissed.Include appstore jump.
 *  详情广告页将要关闭
 */
- (void)bannerAdWillDismissFullScreenModal:(ABUBannerAd *_Nonnull)ABUBannerAd bannerView:(UIView *)bannerView{
    
}

/**
 This method is called when bannerAdView is clicked.
 */
- (void)bannerAdDidClick:(ABUBannerAd *_Nonnull)ABUBannerAd bannerView:(UIView *)bannerView{
    [self notifyOnAdClicked: [self getEyuAd]];
}

/**
 This method is called when the user clicked dislike button and chose dislike reasons.
 @param filterwords : the array of reasons for dislike.
*/

- (void)bannerAdDidClosed:(ABUBannerAd *_Nonnull)ABUBannerAd bannerView:(UIView *)bannerView dislikeWithReason:(NSArray<ABUDislikeWords *> *_Nullable)filterwords{
    // 移除
    [self.bannerView removeFromSuperview];
    self.bannerView = NULL;
    self.bannerAd = NULL;
    [self notifyOnAdClosed: [self getEyuAd]];
}
@end
#endif
