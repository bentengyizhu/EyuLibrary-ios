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
    NSLog(@" lwq, load at nativeAd ");
    if([self isAdLoaded])
    {   
        [self notifyOnAdLoaded];
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
        return  false;
    }
    ATNativeADConfiguration *config = [[ATNativeADConfiguration alloc] init];
    config.ADFrame = nativeAdLayout.bounds;
    config.delegate = self;
    config.renderingViewClass = [ATNativeADView class];
    config.rootViewController = controller;
    self.nativeAdView = [[ATAdManager sharedManager] retriveAdViewWithPlacementID:self.adKey.key configuration:config];
//    if(mediaLayout!= NULL && self.nativeAdView.mediaView!=NULL){
//        [self.nativeAdView.videoAdView removeFromSuperview];
//        CGRect mediaViewBounds = CGRectMake(0,0, mediaLayout.frame.size.width, mediaLayout.frame.size.height);
//        self.nativeAdView.videoAdView.frame = mediaViewBounds;
//        [mediaLayout addSubview:self.nativeAdView.videoAdView];
//    }
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
        actBtn.hidden = false;
        if (self.nativeAdView.nativeAd.ctaText) {
            [actBtn setTitle:self.nativeAdView.nativeAd.ctaText forState:UIControlStateNormal];
        }
    }
//    [nativeAdLayout addSubview:self.nativeAdView];
    return true;
}

-(bool) isAdLoaded
{
    return [[ATAdManager sharedManager] nativeAdReadyForPlacementID:self.adKey.key];
}

- (void)unregisterView {
    if(self.nativeAdView != NULL ){
        NSLog(@"lwq, ATNativeAdAdapter self->nativeAdView.adChoicesView removeFromSuperview ");
        [self.nativeAdView removeFromSuperview];
        self.nativeAdView = NULL;
    }
}

#pragma mark - loading delegate
-(void) didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"lwq, AT didLoadAd adKey = %@", self.adKey);
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

-(void) didFailToLoadADWithPlacementID:(NSString* )placementID error:(NSError *)error {
    NSLog(@"lwq, AT reward didFailToLoadAdWithError: %d, adKey = %@", (int)error.code, self.adKey);
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}
@end

#endif
