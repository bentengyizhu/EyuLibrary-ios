//
//  EYIronSourceInterstitialAdAdapter.m
//  Bolts
//
//  Created by caochao on 2019/3/19.
//
#ifdef IRON_ADS_ENABLED

#import "EYIronSourceInterstitialAdAdapter.h"
#import "IronSource/IronSource.h"
#import "EYAdManager.h"

@interface EYIronSourceInterstitialAdAdapter()<ISDemandOnlyInterstitialDelegate>

@end

@implementation EYIronSourceInterstitialAdAdapter

-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group
{
    self = [super initWithAdKey:adKey adGroup:group];
    if(self)
    {
        [[EYAdManager sharedInstance] addIronInterDelegate:self withKey:adKey.key];
    }
    return self;
}

-(void) loadAd
{
    NSLog(@" EYIronSourceInterstitialAdAdapter loadAd key = %@", self.adKey.key);
    if([self isShowing ]){
        EYuAd *ad = [self getEyuAd];
        ad.error = [[NSError alloc]initWithDomain:@"isshowingdomain" code:ERROR_AD_IS_SHOWING userInfo:nil];
        [self notifyOnAdLoadFailedWithError:ad];
    }else if([self isAdLoaded]) {
        [self notifyOnAdLoaded: [self getEyuAd]];
    }
    else if(!self.isLoading) {
        self.isLoading = true;
//        [IronSource loadInterstitial];
        [IronSource loadISDemandOnlyInterstitial:self.adKey.key];
    }
}

-(EYuAd *) getEyuAd{
    EYuAd *ad = [EYuAd new];
    ad.unitId = self.adKey.key;
    ad.unitName = self.adKey.keyId;
    ad.placeId = self.adKey.placementid;
    ad.adFormat = ADTypeInterstitial;
    ad.mediator = @"icornsource";
    return ad;
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@" EYIronSourceInterstitialAdAdapter showAd");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        [IronSource showISDemandOnlyInterstitial:controller instanceId:self.adKey.key];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    bool result = [IronSource hasISDemandOnlyInterstitial:self.adKey.key];
    NSLog(@" EYIronSourceInterstitialAdAdapter hasISDemandOnlyInterstitial result = %d, key = %@",result, self.adKey.key);
    return result;
}

#pragma mark - IronSource Interstitial Delegate Functions

/**
 Called after an interstitial has been loaded
 */
- (void)interstitialDidLoad:(NSString *)instanceId
{
    NSLog(@" EYIronSourceInterstitialAdAdapter interstitialDidLoad, instance id = %@", instanceId);
    self.isLoading = false;
    [self notifyOnAdLoaded: [self getEyuAd]];
}

/**
 Called after an interstitial has attempted to load but failed.

 @param error The reason for the error
 */
- (void)interstitialDidFailToLoadWithError:(NSError *)error instanceId:(NSString *)instanceId
{
    NSLog(@" EYIronSourceInterstitialAdAdapter interstitialDidFailToLoadWithError, error = %@", error);
    self.isLoading = false;
    EYuAd *ad = [self getEyuAd];
    ad.error = error;
    [self notifyOnAdLoadFailedWithError:ad];
}

/**
 Called after an interstitial has been opened.
 */
- (void)interstitialDidOpen:(NSString *)instanceId
{
    NSLog(@" EYIronSourceInterstitialAdAdapter interstitialDidOpen");
    [self notifyOnAdShowed: [self getEyuAd]];
    [self notifyOnAdImpression: [self getEyuAd]];
}

/**
  Called after an interstitial has been dismissed.
 */
- (void)interstitialDidClose:(NSString *)instanceId
{
    NSLog(@" EYIronSourceInterstitialAdAdapter interstitialDidClose");
    self.isShowing = NO;
    [self notifyOnAdClosed: [self getEyuAd]];
}

/**
 Called after an interstitial has attempted to show but failed.
 @param error The reason for the error
 */
- (void)interstitialDidFailToShowWithError:(NSError *)error instanceId:(NSString *)instanceId
{
    NSLog(@" EYIronSourceInterstitialAdAdapter interstitialDidFailToShowWithError, error = %@", error);
}

/**
 Called after an interstitial has been clicked.
 */
- (void)didClickInterstitial:(NSString *)instanceId
{
    NSLog(@" EYIronSourceInterstitialAdAdapter didClickInterstitial");
    [self notifyOnAdClicked: [self getEyuAd]];
}

@end
#endif /*IRON_ADS_ENABLED*/
