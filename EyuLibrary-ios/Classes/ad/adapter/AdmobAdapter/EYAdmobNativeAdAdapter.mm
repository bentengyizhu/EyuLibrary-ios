//
//  AdmobNativeAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef ADMOB_ADS_ENABLED

#include "EYAdmobNativeAdAdapter.h"

@implementation EYAdmobNativeAdAdapter

@synthesize nativeAdLoader = _nativeAdLoader;
@synthesize nativeAdView = _nativeAdView;
@synthesize nativeAd = _nativeAd;

-(void) loadAd
{
    NSLog(@"admob nativeAd ");
    if([self isAdLoaded])
    {
        [self notifyOnAdLoaded: [self getEyuAd]];
        return;
    }
    if(self.nativeAdLoader == NULL)
    {
        GADNativeAdViewAdOptions *adsOptions = [[GADNativeAdViewAdOptions alloc] init];
        adsOptions.preferredAdChoicesPosition = GADAdChoicesPositionTopLeftCorner;
        self.nativeAdLoader = [[GADAdLoader alloc] initWithAdUnitID:self.adKey.key rootViewController:nil adTypes:@[kGADAdLoaderAdTypeNative] options:@[adsOptions]];
        self.nativeAdLoader.delegate = self;
        self.nativeAdView = [[GADNativeAdView alloc] init];
        self.isLoading = true;
    }
    if(self.nativeAd == NULL && ![self.nativeAdLoader isLoading]){
        GADRequest *request = [GADRequest request];
        //request.testDevices = @[ @"9b80927958fbfef89ca335966239ca9a",@"46fd4577df207ecb050bffa2948d5e52" ];
        [self.nativeAdLoader loadRequest:request];
        [self startTimeoutTask];
    }else if([self.nativeAdLoader isLoading]){
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
    ad.mediator = @"admob";
    return ad;
}

-(bool) showAdWithAdLayout:(UIView*)nativeAdLayout iconView:(UIImageView*)nativeAdIcon titleView:(UILabel*)nativeAdTitle
                  descView:(UILabel*)nativeAdDesc mediaLayout:(UIView*)mediaLayout actBtn:(UIButton*)actBtn controller:(UIViewController*)controller
{
    NSLog(@"admob nativeAd showAd");
    if (self.nativeAd == NULL) return false;

    self.nativeAd.rootViewController = controller;
    self.nativeAdView.nativeAd = self.nativeAd;
    self.nativeAd.delegate = self;
    // Some native ads will include a video asset, while others do not. Apps can
    // use the GADVideoController's hasVideoContent property to determine if one
    // is present, and adjust their UI accordingly.
    
    // The UI for this controller constrains the image view's height to match the
    // media view's height, so by changing the one here, the height of both views
    // are being adjusted.
    if(mediaLayout!= NULL){
//        if (self.nativeAd.videoController.hasVideoContent) {
            // By acting as the delegate to the GADVideoController, this ViewController
            // receives messages about events in the video lifecycle.
            self.nativeAd.mediaContent.videoController.delegate = self;
            self.mediaView = [[GADMediaView alloc] init];
            CGRect mediaViewBounds = CGRectMake(0,0, mediaLayout.frame.size.width, mediaLayout.frame.size.height);
            self.mediaView.frame = mediaViewBounds;
            [mediaLayout addSubview:self.mediaView];
            [self.nativeAdView setMediaView:self.mediaView];
//        } else {
//            // If the ad doesn't contain a video asset, the first image asset is shown
//            // in the image view. The existing lower priority height constraint is used.
//            GADNativeAdImage *firstImage = self.nativeAd.images.firstObject;
//            //((UIImageView *)nativeAdView.imageView).image = firstImage.image;
//            self.imageView = [[UIImageView alloc] init];
//            
//            CGRect mediaViewBounds = CGRectMake(0,0, mediaLayout.frame.size.width, mediaLayout.frame.size.height);
//            self.imageView.frame = mediaViewBounds;
//            [mediaLayout addSubview:self.imageView];
//            [self.nativeAdView setImageView:self.imageView];
//            self.imageView.image = firstImage.image;
//        }
    }
    
    // These assets are not guaranteed to be present, and should be checked first.
    if(nativeAdIcon != NULL)
    {
        if (self.nativeAd.icon != nil) {
            nativeAdIcon.image = self.nativeAd.icon.image;
            [self.nativeAdView setIconView:nativeAdIcon];
        } else {
            GADNativeAdImage *firstImage = self.nativeAd.images.firstObject;
            if( firstImage != NULL){
                nativeAdIcon.image = firstImage.image;
            }
            [self.nativeAdView setIconView:nativeAdIcon];
        }
        nativeAdIcon.userInteractionEnabled = NO;
    }
    
    if(nativeAdTitle!=NULL){
        nativeAdTitle.text = self.nativeAd.headline;
        [self.nativeAdView setHeadlineView:nativeAdTitle];
        
    }
    if(nativeAdDesc != NULL){
        nativeAdDesc.text = self.nativeAd.body;
        [self.nativeAdView setBodyView:nativeAdDesc];
        
    }
    
    if(actBtn != NULL){
        actBtn.hidden = false;
        [actBtn setTitle:self.nativeAd.callToAction forState:UIControlStateNormal];
        [self.nativeAdView setCallToActionView:actBtn];
    }
    
    // In order for the SDK to process touch events properly, user interaction
    // should be disabled.
    self.nativeAdView.callToActionView.userInteractionEnabled = NO;
    
    //if(
    
    CGRect bounds = CGRectMake(0,0, nativeAdLayout.frame.size.width, nativeAdLayout.frame.size.height);
    NSLog(@"nativeAdView witdh = %f, height = %f ", bounds.size.width, bounds.size.height);
    self.nativeAdView.frame = bounds;
    self.nativeAdView.userInteractionEnabled = YES;
    //[nativeAdLayout addSubview:nativeAdView];
//    if(mediaLayout!= NULL){
//        [nativeAdLayout insertSubview:self.nativeAdView belowSubview:mediaLayout];
//    }else{
        [nativeAdLayout addSubview:self.nativeAdView];
//    }
    return true;
}

-(bool) isAdLoaded
{
    NSLog(@"admob nativeAd isAdLoaded, self.nativeAd = %@", self.nativeAd);
    return self.nativeAd!=NULL;
}

- (void)unregisterView {
    if(self.nativeAd!=NULL)
    {
        self.nativeAd.delegate = NULL;
        self.nativeAd = NULL;
    }
    if(self.nativeAdView != NULL ){
        NSLog(@"AdmobNativeAdAdapter self->nativeAdView.adChoicesView removeFromSuperview ");
        [self.nativeAdView removeFromSuperview];
        self.nativeAdView = NULL;
    }
    if(self.mediaView != NULL)
    {
        [self.mediaView removeFromSuperview];
        self.mediaView = NULL;
    }
    if(self.imageView != NULL)
    {
        [self.imageView removeFromSuperview];
        self.imageView = NULL;
    }
}

#pragma mark GADAdLoaderDelegate implementation

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAd:(GADNativeAd *)nativeAd {
    NSLog(@"admob didReceiveUnifiedNativeAd, adLoader = :%@, nativeAd = %@", self, nativeAd);
    self.isLoading = false;
    self.nativeAd = nativeAd;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded: [self getEyuAd]];
}

- (void)adLoaderDidFinishLoading:(GADAdLoader *) adLoader {
    // The adLoader has finished loading ads, and a new request can be sent.
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"%@admob adLoader failed with error: %@", adLoader, error);
    self.isLoading = false;
    [self cancelTimeoutTask];
    EYuAd *ad = [self getEyuAd];
    ad.error = error;
    [self notifyOnAdLoadFailedWithError:ad];
}

#pragma mark GADVideoControllerDelegate implementation

- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController {
    NSLog(@"admob videoControllerDidEndVideoPlayback, adLoader = : %@", self);
}

#pragma mark GADUnifiedNativeAdDelegate

- (void)nativeAdDidRecordClick:(GADNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self notifyOnAdClicked: [self getEyuAd]];
}

- (void)nativeAdDidRecordImpression:(GADNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self notifyOnAdImpression: [self getEyuAd]];
}

- (void)nativeAdWillPresentScreen:(GADNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self notifyOnAdShowed: [self getEyuAd]];
}

- (void)nativeAdWillDismissScreen:(GADNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdDidDismissScreen:(GADNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillLeaveApplication:(GADNativeAd *)nativeAd {
  // The native ad will cause the application to become inactive and
  // open a new application.
}

- (void)dealloc
{
    NSLog(@"AdmobNativeAdAdapter dealloc ");
    if(self.nativeAdLoader != NULL){
        self.nativeAdLoader.delegate = NULL;
        self.nativeAdLoader = NULL;
    }
    
    [self unregisterView];
}

@end
#endif /*ADMOB_ADS_ENABLED*/
