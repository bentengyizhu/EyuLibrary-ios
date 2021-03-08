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
    NSLog(@"lwq, abu bannerAd");
    if([self isAdLoaded])
    {
        [self notifyOnAdLoaded];
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

/**
 This method is called when bannerAdView ad slot loaded successfully.
 @param bannerView : view for bannerView
 */
- (void)bannerAdDidLoad:(ABUBannerAd *_Nonnull)bannerAd bannerView:(UIView *)bannerView{
    self.bannerView = bannerView;
    self.isLoadSuccess = true;
    self.isLoading = false;
    NSLog(@"lwq abud ad didLoad");
    [self notifyOnAdLoaded];
}

/**
 This method is called when bannerAdView ad slot failed to load.
 @param error : the reason of error
 */
- (void)bannerAd:(ABUBannerAd *_Nonnull)bannerAd didLoadFailWithError:(NSError *_Nullable)error{
    self.bannerView = NULL;
    NSLog(@"lwq,abu banner ad failed to load with error: %@", error);
    self.isLoading = false;
    self.isLoadSuccess = false;
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

/**
This method is called when bannerAdView ad slot success to show.
*/
- (void)bannerAdDidBecomVisible:(ABUBannerAd *_Nonnull)ABUBannerAd bannerView:(UIView *)bannerView{
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
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
    [self notifyOnAdClicked];
}

/**
 This method is called when the user clicked dislike button and chose dislike reasons.
 @param filterwords : the array of reasons for dislike.
*/

- (void)bannerAdDidClosed:(ABUBannerAd *_Nonnull)ABUBannerAd bannerView:(UIView *)bannerView dislikeWithReason:(NSArray<ABUDislikeWords *> *_Nullable)filterwords{
    // 移除
    [self.bannerView removeFromSuperview];
    self.bannerView = NULL;
    [self notifyOnAdClosed];
}    
@end
#endif
