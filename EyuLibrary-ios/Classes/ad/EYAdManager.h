//
//  AdManager.h
//  ballzcpp-mobile
//
//  Created by Woo on 2017/12/19.
//

#ifndef AdManager_h
#define AdManager_h

#import "EYNativeAdAdapter.h"
#import "EYRewardAdAdapter.h"
#import "EYInterstitialAdAdapter.h"
#import "EYAdKey.h"
#import "EYAdConfig.h"
#import "EYAdDelegate.h"
#import "EYAdConstants.h"

#ifdef IRON_ADS_ENABLED
#import "IronSource/IronSource.h"
#endif

#ifdef UNITY_ADS_ENABLED
#import "UnityAds/UnityAds.h"
#endif

#ifdef VUNGLE_ADS_ENABLED
#import "VungleSDK/VungleSDK.h"
#endif /*VUNGLE_ADS_ENABLED*/



@interface EYAdManager : NSObject {
    
}

+(EYAdManager*) sharedInstance;

@property(nonatomic,weak) id<EYAdDelegate> delegate;
@property(nonatomic,strong) EYAdConfig* adConfig;
@property(nonatomic,weak) UIViewController *rootViewController;
#ifdef ADMOB_MEDIATION_ENABLED
@property(nonatomic,strong) NSMutableArray* vunglePlacementIds;
#endif

-(void) loadRewardVideoAd:(NSString*) placeId;
-(void) loadInterstitialAd:(NSString*) placeId;
-(void) loadNativeAd:(NSString*) placeId;
-(void) loadBannerAd:(NSString*) placeId;
-(void) loadSplashAd:(NSString*) placeId;

-(bool) showAd:(NSString*) placeId withViewController:(UIViewController*)controller;
-(void) showSplashAd:(NSString*) placeId withViewController:(UIViewController*)controller;
-(void) showRewardVideoAd:(NSString*) placeId withViewController:(UIViewController*)controller;
-(void) showInterstitialAd:(NSString*) placeId withViewController:(UIViewController*)controller;
-(EYNativeAdAdapter*) getNativeAdAdapter:(NSString*) adPlaceId;
-(void) showNativeAd:(NSString*) placeId withViewController:(UIViewController*)controller viewGroup:(UIView*)viewGroup;
-(bool) showBannerAd:(NSString*) placeId  viewGroup:(UIView*)viewGroup;
-(void) hideNativeAd:(NSString*) placeId forController:(UIViewController*)controller;
-(void) removeNativeAdViewCache:(UIViewController*)controller;

-(bool) isNativeAdLoaded:(NSString*) placeId;
-(bool) isBannerAdLoaded:(NSString*) placeId;
-(bool) isInterstitialAdLoaded:(NSString*) placeId;
-(bool) isRewardAdLoaded:(NSString*) placeId;
-(bool) isSplashAdLoaded:(NSString*) placeId;
-(bool) isAdLoaaded:(NSString*) placeId;

- (bool)isHighPriorityAdLoaded:(NSString *)placeId;
-(bool) isHighPriorityNativeAdLoaded:(NSString*) placeId;
-(bool) isHighPriorityBannerAdLoaded:(NSString*) placeId;
-(bool) isHighPriorityInterstitialAdLoaded:(NSString*) placeId;
-(bool) isHighPriorityRewardAdLoaded:(NSString*) placeId;
-(bool) isHighPrioritySplashAdLoaded:(NSString*) placeId;

-(void) setupWithConfig:(EYAdConfig*) config;
-(EYAdKey*) getAdKeyWithId:(NSString*) keyId;

-(void) registerNativeAdCustomClass:(Class) nativeClass;

#ifdef UNITY_ADS_ENABLED
-(void) addUnityAdsDelegate:(id<UnityAdsDelegate>) delegate withKey:(NSString*) adKey;
-(void) removeUnityAdsDelegate:(id<UnityAdsDelegate>) delegate forKey:(NSString *)adKey;
#endif

#ifdef VUNGLE_ADS_ENABLED
-(void) addVungleAdsDelegate:(id<VungleSDKDelegate>) delegate withKey:(NSString*) adKey;
-(void) removeVungleAdsDelegate:(id<VungleSDKDelegate>) delegate  forKey:(NSString *)adKey;
#endif

#ifdef IRON_ADS_ENABLED
-(void) addIronInterDelegate:(id<ISDemandOnlyInterstitialDelegate>) delegate withKey:(NSString*) adKey;
-(void) removeIronInterDelegate:(id<ISDemandOnlyInterstitialDelegate>) delegate  forKey:(NSString *)adKey;

-(void) addIronRewardDelegate:(id<ISDemandOnlyRewardedVideoDelegate>) delegate withKey:(NSString*) adKey;
-(void) removeIronRewardDelegate:(id<ISDemandOnlyRewardedVideoDelegate>) delegate  forKey:(NSString *)adKey;
#endif

-(void) onDefaultNativeAdClicked;

-(void) reset;

@end

#endif /* AdManager_h */


