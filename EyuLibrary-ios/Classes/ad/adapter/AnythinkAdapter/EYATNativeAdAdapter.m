//
//  EYATNativeAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/21.
//

#ifdef ANYTHINK_ENABLED
#import "EYATNativeAdAdapter.h"

@implementation EYATNativeAdAdapter
@synthesize nativeAdView = _nativeAdView;

-(void) loadAd
{
    NSLog(@"load at nativeAd ");
    if([self isAdLoaded])
    {   
        [self notifyOnAdLoaded: [self getEyuAd]];
    }else if (!self.isLoading){
        self.isLoading = true;
        [[ATAdManager sharedManager] loadADWithPlacementID:self.adKey.key extra:@{} delegate:self];
        [self startTimeoutTask];
    }else{
        if(self.loadingTimer == nil)
        {
            [self startTimeoutTask];
        }
    }
}

-(bool)showAdWithAdLayout:(UIView *)nativeAdLayout iconView:(UIImageView *)nativeAdIcon titleView:(UILabel *)nativeAdTitle descView:(UILabel *)nativeAdDesc mediaLayout:(UIView *)mediaLayout actBtn:(UIButton *)actBtn controller:(UIViewController *)controller {
    if (![self isAdLoaded]) {
        return false;
    }
    ATNativeADConfiguration *config = [[ATNativeADConfiguration alloc] init];
    config.ADFrame = mediaLayout.bounds;
    config.delegate = self;
    config.mediaViewFrame = mediaLayout.bounds;
    config.renderingViewClass = [EYATNativeAdView class];
    config.rootViewController = controller;
    self.nativeAdView = (EYATNativeAdView *)[[ATAdManager sharedManager] retriveAdViewWithPlacementID:self.adKey.key configuration:config];
    if(nativeAdIcon != NULL)
    {
        nativeAdIcon.image = self.nativeAdView.nativeAd.icon;
        nativeAdIcon.userInteractionEnabled = NO;
    }
    if(nativeAdTitle!=NULL){
        nativeAdTitle.text = self.nativeAdView.nativeAd.title;
    }
    if(nativeAdDesc != NULL){
        nativeAdDesc.text = self.nativeAdView.nativeAd.mainText;
    }
    if(actBtn != NULL){
        if (self.nativeAdView.nativeAd.ctaText) {
            actBtn.hidden = false;
            [actBtn setTitle:self.nativeAdView.nativeAd.ctaText forState:UIControlStateNormal];
        } else {
            actBtn.hidden = true;
        }
    }
    [mediaLayout addSubview:self.nativeAdView];
    return true;
}

-(bool) isAdLoaded
{
    return [[ATAdManager sharedManager] nativeAdReadyForPlacementID:self.adKey.key];
}

-(EYuAd *) getEyuAd{
    EYuAd *ad = [EYuAd new];
    ad.unitId = self.adKey.key;
    ad.unitName = self.adKey.keyId;
    ad.placeId = self.adKey.placementid;
    ad.adFormat = ADTypeNative;
    ad.mediator = @"topon";
    return ad;
}

- (void)unregisterView {
    if(self.nativeAdView != NULL ){
        NSLog(@" ATNativeAdAdapter self->nativeAdView.adChoicesView removeFromSuperview ");
        [self.nativeAdView removeFromSuperview];
        self.nativeAdView = NULL;
    }
}

#pragma mark - loading delegate
-(void) didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@" AT didLoadAd adKey = %@", self.adKey);
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded: [self getEyuAd]];
}

-(void) didFailToLoadADWithPlacementID:(NSString* )placementID error:(NSError *)error {
    NSLog(@" AT reward didFailToLoadAdWithError: %d, adKey = %@", (int)error.code, self.adKey);
    self.isLoading = false;
    [self cancelTimeoutTask];
    EYuAd *ad = [self getEyuAd];
    ad.error = error;
    [self notifyOnAdLoadFailedWithError:ad];
}

#pragma mark - native delegate
- (void)didClickNativeAdInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    [self notifyOnAdClicked: [self getEyuAd]];
}

- (void)didEndPlayingVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"at videoControllerDidEndVideoPlayback, adLoader = : %@", self);
}

- (void)didEnterFullScreenVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
}

- (void)didExitFullScreenVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
}

- (void)didLoadSuccessDrawWith:(NSArray *)views placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
}

- (void)didShowNativeAdInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
//    if (!self.nativeAdView.mainImageView.image) {
//        self.nativeAdView.mainImageView.image = self.nativeAdView.nativeAd.mainImage;
//    }
    EYuAd *ad = [self getEyuAd];
    [self notifyOnAdShowed:ad];
    [self notifyOnAdImpression: ad];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    ad.networkName = extra[@"adsource_id"];
    ad.adRevenue = [numberFormatter stringFromNumber:extra[@"adsource_price"]];
    [self notifyOnAdRevenue:ad];
}

- (void)didStartPlayingVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
}

- (void)didTapCloseButtonInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
}

- (void)dealloc
{
    NSLog(@" ATNativeAdAdapter dealloc");
    [self unregisterView];
}
@end

#endif
