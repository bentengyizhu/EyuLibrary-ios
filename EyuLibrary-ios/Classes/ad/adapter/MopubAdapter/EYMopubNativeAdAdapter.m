//
//  EYMopubNativeAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2021/4/12.
//
#ifdef MOPUB_ENABLED
#import "EYMopubNativeAdAdapter.h"
#import "EYMopubNativeAdView.h"

@implementation EYMopubNativeAdAdapter
-(void) loadAd
{
    NSLog(@"mopub nativeAd loadAd key = %@.", self.adKey.key);
    if([self isAdLoaded]){
        [self notifyOnAdLoaded];
    }else if(self.nativeAd == NULL)
    {
        MPStaticNativeAdRendererSettings *settings = [[MPStaticNativeAdRendererSettings alloc] init];
        settings.renderingViewClass = [EYMopubNativeAdView class];
        MPNativeAdRendererConfiguration *config = [MPStaticNativeAdRenderer rendererConfigurationWithRendererSettings:settings];
        MPNativeAdRequest *adRequest = [MPNativeAdRequest requestWithAdUnitIdentifier:self.adKey.key rendererConfigurations:@[config]];
        MPNativeAdRequestTargeting *targeting = [MPNativeAdRequestTargeting targeting];
        targeting.desiredAssets = [NSSet setWithObjects:kAdTitleKey, kAdTextKey, kAdCTATextKey, kAdIconImageKey, kAdMainImageKey, kAdStarRatingKey, nil]; //The constants correspond to the 6 elements of MoPub native ads
//        targeting.location
        adRequest.targeting = targeting;
        [adRequest startWithCompletionHandler:^(MPNativeAdRequest *request, MPNativeAd *response, NSError *error) {
             if (error) {
                 // Handle error.
                 self.isLoading = false;
                 if(self.nativeAd != NULL)
                 {
                     self.nativeAd.delegate = NULL;
                     self.nativeAd = NULL;
                 }
                 [self cancelTimeoutTask];
                 [self notifyOnAdLoadFailedWithError:(int)error.code];
             } else {
                 self.isLoading = false;
                 self.nativeAd = response;
                 self.nativeAd.delegate = self;
                 [self cancelTimeoutTask];
                 [self notifyOnAdLoaded];
//                 nativeAdView.frame = self.yourNativeAdViewContainer.bounds;
//                 [self.yourNativeAdViewContainer addSubview:nativeAdView];
             }
         }];
        self.isLoading = true;
        [self startTimeoutTask];
    }else{
        if(self.loadingTimer==nil){
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithAdLayout:(UIView*)nativeAdLayout iconView:(UIImageView*)nativeAdIcon titleView:(UILabel*)nativeAdTitle
                  descView:(UILabel*)nativeAdDesc mediaLayout:(UIView*)mediaLayout actBtn:(UIButton*)actBtn controller:(UIViewController*)controller
{
    NSLog(@"mopub nativeAd showAd self.nativeAd = %@.", self.nativeAd);
    if (![self isAdLoaded]) {
        return false;
    }
    UIView *view = [self.nativeAd retrieveAdViewWithError:nil];
    if (view == NULL) {
        return false;
    }
    if (view.subviews.count == 0) {
        return false;
    }
    self.controller = controller;
    EYMopubNativeAdView *nativeAdView = (EYMopubNativeAdView *)view.subviews[0];
    if(mediaLayout!= NULL) {
        CGRect mediaViewBounds = CGRectMake(0,mediaLayout.frame.origin.y, mediaLayout.frame.size.width, mediaLayout.frame.size.height);
//        self.nativeAdImgView = [[UIImageView alloc] initWithFrame:mediaViewBounds];
//        self.nativeAdImgView.image = nativeAdView.mainImageView.image;
//        [mediaLayout addSubview:self.nativeAdImgView];
        nativeAdView.mainImageView.frame = mediaViewBounds;
    }
    nativeAdView.iconImageView.frame = CGRectMake(nativeAdIcon.frame.origin.x, nativeAdIcon.frame.origin.y, nativeAdView.iconImageView.image.size.width, nativeAdView.iconImageView.image.size.height);
    nativeAdView.titleLabel.frame = CGRectMake(nativeAdTitle.frame.origin.x, nativeAdTitle.frame.origin.y, nativeAdView.titleLabel.frame.size.width, nativeAdView.titleLabel.frame.size.height);
    [nativeAdView.titleLabel sizeToFit];
    [nativeAdView.mainTextLabel sizeToFit];
    nativeAdView.mainTextLabel.frame = CGRectMake(nativeAdDesc.frame.origin.x, nativeAdDesc.frame.origin.y, [UIScreen mainScreen].bounds.size.width - nativeAdDesc.frame.origin.x - 15, nativeAdView.mainTextLabel.frame.size.height);
    [nativeAdView.callToActionLabel setHidden:YES];
//    nativeAdView.callToActionLabel.frame = CGRectMake(actBtn.frame.origin.x, actBtn.frame.origin.y, nativeAdView.callToActionLabel.frame.size.width, nativeAdView.callToActionLabel.frame.size.height);
//    [nativeAdView.callToActionLabel sizeToFit];
    view.frame = nativeAdLayout.bounds;
    [nativeAdLayout addSubview:view];
    
//    if(nativeAdIcon!=NULL){
//        nativeAdIcon.image = nativeAdView.iconImageView.image;
//    }
//    if(nativeAdTitle!=NULL){
//        nativeAdTitle.text = nativeAdView.titleLabel.text;
//    }
//    if(nativeAdDesc != NULL){
//        nativeAdDesc.text = nativeAdView.mainTextLabel.text;
//    }
//    if(actBtn != NULL){
//        actBtn.hidden = false;
//        actBtn.userInteractionEnabled = false;
//        [actBtn setTitle:nativeAdView.callToActionLabel.text forState:UIControlStateNormal];
//    }
    return true;
}

-(bool) isAdLoaded
{
    return self.nativeAd != NULL;
}

- (void)unregisterView {
    if(self.nativeAd != NULL)
    {
        self.nativeAd.delegate = NULL;
        self.nativeAd = NULL;
    }
    if(self.nativeAdImgView)
    {
        [self.nativeAdImgView removeFromSuperview];
        self.nativeAdImgView = nil;
    }
}

- (UIViewController *)viewControllerForPresentingModalView {
    return self.controller;
}

- (void)willPresentModalForNativeAd:(MPNativeAd *)nativeAd {
    
}

- (void)willLeaveApplicationFromNativeAd:(MPNativeAd *)nativeAd {
    
}

- (void)didDismissModalForNativeAd:(MPNativeAd *)nativeAd {
    
}

- (void)dealloc
{
    [self unregisterView];
}
@end
#endif
