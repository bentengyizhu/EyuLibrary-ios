//
//  EYABUNativeAdView.m
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/6.
//
#ifdef ABUADSDK_ENABLED
#import "EYABUNativeAdView.h"

@implementation EYABUNativeAdView
-(void) loadAd
{
    NSLog(@" lwq, abu nativeAd loadAd admanager = %@, key = %@.", self.adManager, self.adKey.key);
    if([self isAdLoaded]){
        [self notifyOnAdLoaded];
    }else if(self.adManager == NULL)
    {
        ABUAdUnit *slot1 = [[ABUAdUnit alloc] init];
        ABUSize *imgSize1 = [[ABUSize alloc] init];
        imgSize1.width = 1080;
        imgSize1.height = 1920;
        slot1.ID = self.adKey.key;
        slot1.AdType = ABUAdSlotAdTypeFeed;
        slot1.position = ABUAdSlotPositionFeed;
        slot1.imgSize = imgSize1;
        slot1.isSupportDeepLink = YES;
        slot1.adSize = CGSizeMake(414, 300);
        self.adManager = [[ABUNativeAdsManager alloc] initWithSlot:slot1];
        self.adManager.startMutedIfCan = NO;
        self.adManager.delegate = self;
        __weak typeof(self) weakself = self;
            if(self.adManager.hasAdConfig){
                [self.adManager loadAdDataWithCount:1];
            }else{
                [self.adManager setConfigSuccessCallback:^{
                    [weakself.adManager loadAdDataWithCount:1];
                }];
            }
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
    NSLog(@" lwq, abu nativeAd showAd self.admanager = %@.", self.adManager);
    if (!self.isLoaded) {
        return false;
    }
    NSMutableArray<UIView*>* clickViews = [[NSMutableArray alloc] init];
    if (mediaLayout != NULL) {
        CGRect mediaViewBounds = CGRectMake(0,0, mediaLayout.frame.size.width, mediaLayout.frame.size.height);
        if ((self.nativeAdView.data.imageMode == ABUFeedVideoAdModeImage || self.nativeAdView.data.imageMode == ABUFeedVideoAdModePortrait)) {
            self.nativeAdView.mediaView.frame = mediaViewBounds;
            [mediaLayout addSubview:self.nativeAdView.mediaView];
        } else {
            ABUImage *image = self.nativeAdView.data.imageAry.firstObject;
            self.imageView = [[UIImageView alloc] init];
            self.imageView.hidden = false;
            self.imageView.userInteractionEnabled = YES;
            self.imageView.frame = mediaViewBounds;
            [mediaLayout addSubview:self.imageView];
            NSLog(@"lwq, showAdWithAdLayout image strUrl = %@", image.imageURL);
            if (image.imageURL) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSData *imageData = [NSData dataWithContentsOfURL:image.imageURL];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.imageView.image = [UIImage imageWithData:imageData];
                    });
                });
            }
        }
    }
    if(self.nativeAdView.adLogoView){
        CGRect iconViewBounds = CGRectMake(0,0, 26, 14);
        self.nativeAdView.adLogoView.frame = iconViewBounds;
        [nativeAdLayout addSubview:self.nativeAdView.adLogoView];
    }
    if(nativeAdIcon!=NULL){
        [clickViews addObject:nativeAdIcon];
        
        NSURL *url = self.nativeAdView.data.icon.imageURL;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                nativeAdIcon.image = [UIImage imageWithData:imageData];
            });
        });
    }
    
    if(nativeAdTitle!=NULL){
        nativeAdTitle.text = self.nativeAdView.data.AdTitle;
        [clickViews addObject:nativeAdTitle];
    }
    
    if(nativeAdDesc != NULL){
        nativeAdDesc.text = self.nativeAdView.data.AdDescription;
        [clickViews addObject:nativeAdDesc];
    }
    
    if(actBtn != NULL){
        actBtn.hidden = false;
        [actBtn setTitle:self.nativeAdView.data.buttonText forState:UIControlStateNormal];
        [clickViews addObject:actBtn];
    }
    // 注册点击事件
    [self.nativeAdView registerClickableViews:clickViews];
    return true;
}

-(bool) isAdLoaded
{
    NSLog(@" lwq, wm nativeAd isAdLoaded ? = %d", self.isLoaded);
    return self.isLoaded;
}

- (void)unregisterView {
    if(self.adManager != NULL)
    {
        self.adManager.delegate = NULL;
        self.adManager = NULL;
    }
    if(self.nativeAdView != NULL)
    {
        [self.nativeAdView removeFromSuperview];
        self.nativeAdView = NULL;
    }
}

# pragma mark ---<ABUNativeAdsManagerDelegate>---
- (void)nativeAdsManagerSuccessToLoad:(ABUNativeAdsManager *_Nonnull)adsManager nativeAds:(NSArray<ABUNativeAdView *> *_Nullable)nativeAdViewArray {
    NSLog(@"lwq, abu nativeAdDidLoad");
    self.nativeAdView = nativeAdViewArray.firstObject;
    self.nativeAdView.delegate = self;
    self.nativeAdView.videoDelegate = self;
    self.isLoading = false;
    self.isLoaded = true;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

- (void)nativeAdsManager:(ABUNativeAdsManager *_Nonnull)adsManager didFailWithError:(NSError *_Nullable)error {
    NSLog(@"lwq,abu Native ad failed to load with error: %@", error);
    self.isLoading = false;
    self.isLoaded = false;
    if(self.adManager != NULL)
    {
        self.adManager.delegate = NULL;
        self.adManager = NULL;
    }
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

# pragma mark ---<ABUNativeAdViewDelegate>---
- (void)nativeAdExpressViewRenderSuccess:(ABUNativeAdView *_Nonnull)nativeExpressAdView {
    
    
}

/**
 * This method is called when a nativeExpressAdView failed to render
 */
- (void)nativeAdExpressViewRenderFail:(ABUNativeAdView *_Nonnull)nativeExpressAdView error:(NSError *_Nullable)error {
    
}

/**
 This method is called when native ad slot has been shown.
 */
- (void)nativeAdDidBecomeVisible:(ABUNativeAdView *_Nonnull)nativeAdView {
    
}

/**
 This method is called when native ad is clicked.
 */
- (void)nativeAdDidClick:(ABUNativeAdView *_Nonnull)nativeAdView withView:(UIView *_Nullable)view {
   
}

/**
 * Sent after an ad view is clicked, a ad landscape view will present modal content
 */
- (void)nativeAdViewWillPresentFullScreenModal:(ABUNativeAdView *_Nonnull)nativeAdView {
   
}

# pragma mark ---<ABUNativeAdVideoDelegate>---
/**
 This method is called when videoadview playback status changed.
 @param playerState : player state after changed
 */
- (void)nativeAdVideo:(ABUNativeAdView *_Nullable)nativeAdView stateDidChanged:(ABUPlayerPlayState)playerState {
    
}

/**
 This method is called when videoadview's finish view is clicked.
 */
- (void)nativeAdVideoDidClick:(ABUNativeAdView *_Nullable)nativeAdView {
    
}

/**
 This method is called when videoadview end of play.
 */
- (void)nativeAdVideoDidPlayFinish:(ABUNativeAdView *_Nullable)nativeAdView {
   
}

@end
#endif
