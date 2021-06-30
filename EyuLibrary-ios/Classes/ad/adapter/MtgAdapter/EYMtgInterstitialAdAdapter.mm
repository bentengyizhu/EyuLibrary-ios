//
//  EYMtgInterstitialAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef MTG_ADS_ENABLED

#include "EYMtgInterstitialAdAdapter.h"
#import <MTGSDK/MTGSDK.h>
#import <MTGSDKInterstitialVideo/MTGInterstitialVideoAdManager.h>



@interface EYMtgInterstitialAdAdapter()<MTGInterstitialVideoDelegate>

@property(nonatomic,strong)MTGInterstitialVideoAdManager *interstitialAd;
@property(nonatomic,assign)bool isLoaded;


@end


@implementation EYMtgInterstitialAdAdapter

@synthesize interstitialAd = _interstitialAd;
@synthesize isLoaded = _isLoaded;

-(void) loadAd
{
    NSLog(@"mtg interstitialAd loadAd ");
    if([self isShowing ]){
        EYuAd *ad = [self getEyuAd];
        ad.error = [[NSError alloc]initWithDomain:@"isshowingdomain" code:ERROR_AD_IS_SHOWING userInfo:nil];
        [self notifyOnAdLoadFailedWithError:ad];
    }else if(self.interstitialAd == NULL)
    {
        self.interstitialAd = [[MTGInterstitialVideoAdManager alloc]initWithPlacementId:self.adKey.placementid unitId:self.adKey.key delegate:self];
//        self.interstitialAd = [[MTGInterstitialVideoAdManager alloc] initWithUnitID:self.adKey.key delegate:self];

        self.interstitialAd.delegate = self;
        self.isLoading = true;
        [self.interstitialAd loadAd];
        [self startTimeoutTask];
    }else if([self isAdLoaded]){
        [self notifyOnAdLoaded: [self getEyuAd]];
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
    ad.adFormat = ADTypeInterstitial;
    ad.mediator = @"mtg";
    return ad;
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"mtg interstitialAd showAd ");
    if([self isAdLoaded])
    {
        self.isLoaded = NO;
        self.isShowing = YES;
        [self.interstitialAd showFromViewController:controller];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    NSLog(@"mtg interstitialAd isAdLoaded , interstitialAd = %@", self.interstitialAd);
    return self.interstitialAd != NULL && self.isLoaded;
}

#pragma mark - Interstitial Delegate Methods

- (void) onInterstitialAdLoadSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSLog(@"mtg onInterstitialAdLoadSuccess");
}

- (void) onInterstitialVideoLoadSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSLog(@" mtg interstitialAd fullscreenVideoAdDidVisible");
    self.isLoading = false;
    self.isLoaded = true;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded: [self getEyuAd]];
}

- (void) onInterstitialVideoLoadFail:(nonnull NSError *)error adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSLog(@" mtg onInterstitialVideoLoadFail error = %@", error);
    self.isLoading = false;
    self.isLoaded = false;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self cancelTimeoutTask];
    EYuAd *ad = [self getEyuAd];
    ad.error = error;
    [self notifyOnAdLoadFailedWithError:ad];
}

- (void) onInterstitialVideoShowSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSLog(@" mtg onInterstitialVideoShowSuccess");
    [self notifyOnAdShowed: [self getEyuAd]];
    [self notifyOnAdImpression: [self getEyuAd]];
}

- (void) onInterstitialVideoShowFail:(nonnull NSError *)error adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSLog(@" mtg onInterstitialVideoShowFail error = %@", error);

}

- (void) onInterstitialVideoAdClick:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSLog(@" wm interstitialAd fullscreenVideoAdDidClick");
    [self notifyOnAdClicked: [self getEyuAd]];
}

- (void)onInterstitialVideoAdDismissedWithConverted:(BOOL)converted adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSLog(@" mtg ionInterstitialVideoAdDismissedWithConverted converted = %d", converted);
    self.isShowing = NO;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self notifyOnAdClosed: [self getEyuAd]];
}

- (void)dealloc
{
    if(self.interstitialAd!= NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
}

@end
#endif /*MTG_ADS_ENABLED*/
