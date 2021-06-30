//
//  EYTPNativeAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2020/12/30.
//

#ifdef TRADPLUS_ENABLED

#import "EYTPNativeAdAdapter.h"

@implementation EYTPNativeAdAdapter
-(void) loadAd
{
    NSLog(@"tp load at nativeAd ");
    if([self isAdLoaded])
    {
        [self notifyOnAdLoaded: [self getEyuAd]];
    }else if (!self.isLoading){
        self.isLoading = true;
        _adsLoader = [[MsNativeAdsLoader alloc] init];
        _adsLoader.delegate = self;
        _adsLoader.defaultRenderingViewClass = [EYTPNativeAdView class];
        [self startTimeoutTask];
        [_adsLoader setAdUnitID:self.adKey.key];
            //设置想获得的原生广告个数
        [_adsLoader loadAds:1];
    }else{
        if(self.loadingTimer == nil)
        {
            [self startTimeoutTask];
        }
    }
}

-(EYuAd *) getEyuAd{
    EYuAd *ad = [EYuAd new];
    ad.unitId = self.adKey.key;
    ad.unitName = self.adKey.keyId;
    ad.placeId = self.adKey.placementid;
    ad.adFormat = ADTypeNative;
    ad.mediator = @"tradplus";
    return ad;
}

-(bool)showAdWithAdLayout:(UIView *)nativeAdLayout iconView:(UIImageView *)nativeAdIcon titleView:(UILabel *)nativeAdTitle descView:(UILabel *)nativeAdDesc mediaLayout:(UIView *)mediaLayout actBtn:(UIButton *)actBtn controller:(UIViewController *)controller {
    if (![self isAdLoaded]) {
        return false;
    }
    if(nativeAdIcon != NULL)
    {
        nativeAdIcon.image = self.nativeAdView.iconImageView.image;
        nativeAdIcon.userInteractionEnabled = NO;
    }
    if(nativeAdTitle!=NULL){
        nativeAdTitle.text = self.nativeAdView.titleLabel.text;
    }
    if(nativeAdDesc != NULL){
        nativeAdDesc.text = self.nativeAdView.mainTextLabel.text;
    }
    if(actBtn != NULL){
        if (self.nativeAdView.ctaLabel.text) {
            actBtn.hidden = false;
            [actBtn setTitle:self.nativeAdView.ctaLabel.text forState:UIControlStateNormal];
        } else {
            actBtn.hidden = true;
        }
    }
    _adView.frame = mediaLayout.bounds;
    [mediaLayout addSubview:self.adView];
    return true;
}

-(bool) isAdLoaded
{
    return self.nativeAdView != NULL;
}

- (void)unregisterView {
    if(self.nativeAdView != NULL ){
        NSLog(@" TPNativeAdAdapter self->nativeAdView.adChoicesView removeFromSuperview ");
        [self.nativeAdView removeFromSuperview];
        self.nativeAdView = NULL;
        self.adView = NULL;
    }
}

- (void)nativeAdsAllLoaded:(BOOL)isAdReady readyAds:(NSArray *)readyAds error:(NSError *)error {
    self.isLoading = false;
    [self cancelTimeoutTask];
    if (!error && readyAds.count > 0) {
        MSNativeAd *nativeAd = readyAds[0];
        self.adView = [nativeAd retrieveAdViewWithError:[EYTPNativeAdView class] error:nil];
        self.nativeAdView = (EYTPNativeAdView *)self.adView.subviews.firstObject;
        [self notifyOnAdLoaded: [self getEyuAd]];
    } else {
        EYuAd *ad = [self getEyuAd];
        ad.error = error;
        [self notifyOnAdLoadFailedWithError:ad];
    }
}
@end
#endif
