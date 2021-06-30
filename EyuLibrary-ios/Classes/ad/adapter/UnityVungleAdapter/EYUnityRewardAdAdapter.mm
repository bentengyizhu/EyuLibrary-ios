//
//  UnityRewardAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef UNITY_ADS_ENABLED

#include "EYUnityRewardAdAdapter.h"
//#import "UnityAds/UnityAds.h"
#import "EYAdManager.h"

@interface EYUnityRewardAdAdapter()<UnityAdsDelegate>

//@property(nonatomic,copy)NSString *adId;

@end

@implementation EYUnityRewardAdAdapter

-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group
{
    self = [super initWithAdKey:adKey adGroup:group];
    if(self)
    {
        [[EYAdManager sharedInstance] addUnityAdsDelegate:self withKey:adKey.key];
    }
    return self;
}

-(EYuAd *) getEyuAd{
    EYuAd *ad = [EYuAd new];
    ad.unitId = self.adKey.key;
    ad.unitName = self.adKey.keyId;
    ad.placeId = self.adKey.placementid;
    ad.adFormat = ADTypeReward;
    ad.mediator = @"unity";
    return ad;
}

-(void) loadAd
{
    NSLog(@"unity loadAd isAdLoaded = %d", [self isAdLoaded]);
    if([self isShowing ]){
        EYuAd *ad = [self getEyuAd];
        ad.error = [[NSError alloc]initWithDomain:@"isshowingdomain" code:ERROR_AD_IS_SHOWING userInfo:nil];
        [self notifyOnAdLoadFailedWithError:ad];
    }else if([UnityAds isReady:self.adKey.key])
    {
        [self notifyOnAdLoaded: [self getEyuAd]];
    }else{
        EYuAd *ad = [self getEyuAd];
        ad.error = [[NSError alloc]initWithDomain:@"loadaderrordomain" code:ERROR_UNITY_AD_NOT_LOADED userInfo:nil];
        [self notifyOnAdLoadFailedWithError:ad];
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"unity showAd ");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        [UnityAds show:controller placementId:self.adKey.key];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    bool isAdLoaded = [UnityAds isInitialized] && [UnityAds isReady:self.adKey.key];
    NSLog(@"unity Reward video ad isAdLoaded = %d", isAdLoaded);
    return isAdLoaded;
}

- (void)unityAdsReady:(NSString *)placementId{
    [self notifyOnAdLoaded: [self getEyuAd]];
}

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message{
    EYuAd *ad = [self getEyuAd];
    ad.error = error;
    [self notifyOnAdLoadFailedWithError:ad];
}

- (void)unityAdsDidStart:(NSString *)placementId{
    [self notifyOnAdShowed: [self getEyuAd]];
    [self notifyOnAdImpression: [self getEyuAd]];
}

- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state{
    if(state == UnityAdsFinishState::kUnityAdsFinishStateCompleted){
        [self notifyOnAdRewarded: [self getEyuAd]];
    }
    self.isShowing = NO;
    [self notifyOnAdClosed: [self getEyuAd]];
}

- (void)dealloc
{
    [[EYAdManager sharedInstance] removeUnityAdsDelegate:self forKey:self.adKey.key];
}

@end
#endif /*UNITY_ADS_ENABLED*/
