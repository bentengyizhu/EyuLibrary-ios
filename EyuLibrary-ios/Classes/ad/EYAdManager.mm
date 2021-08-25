//
//  AdPlayer-ios.m
//  ballzcpp-mobile
//
//  Created by Woo on 2017/12/19.
//

#import <Foundation/Foundation.h>
#import "EYAdManager.h"
#import "SVProgressHUD.h"
#import "EYRemoteConfigHelper.h"
#import "EYAdKey.h"
#import "EYAdGroup.h"
#import "EYAdPlace.h"
#import "EYAdSuite.h"
#import "EYInterstitialAdGroup.h"
#import "EYNativeAdGroup.h"
#import "EYRewardAdGroup.h"
#import "EYNativeAdAdapter.h"
#import "EYNativeAdView.h"
#import "EYBannerAdGroup.h"
#import "EYSplashAdGroup.h"
#import "EYAdConstants.h"
#import <CoreTelephony/CTCellularData.h>
#ifdef FB_ADS_ENABLED
#import "FBAdSettings.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#endif

#ifdef ADMOB_MEDIATION_ENABLED
#import "FBAdSettings.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#ifndef ADMOB_ADS_ENABLED
#define ADMOB_ADS_ENABLED
#endif
#endif

#ifdef BYTE_DANCE_ADS_ENABLED
#import <BUAdSDK/BUAdSDKManager.h>
#endif

#ifdef TRADPLUS_ENABLED
#import "FBAdSettings.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <TradPlusAds/MsSDKUtils.h>
#endif

#ifdef APPLOVIN_MAX_ENABLED
#ifndef APPLOVIN_ADS_ENABLED
#define APPLOVIN_ADS_ENABLED
#endif
#import "FBAdSettings.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#endif

#ifdef APPLOVIN_ADS_ENABLED
#import <AppLovinSDK/AppLovinSDK.h>
#endif

#ifdef MTG_ADS_ENABLED
#import <MTGSDK/MTGSDK.h>
#endif

#ifdef IRON_ADS_ENABLED
#import "IronSource/IronSource.h"
#endif

#ifdef ADMOB_ADS_ENABLED
#import "GoogleMobileAds/GoogleMobileAds.h"
#endif

#ifdef ABUADSDK_ENABLED
#import <ABUAdSDK/ABUAdSDK.h>
#endif

#ifdef MOPUB_ENABLED
#import "MoPub.h"
#import "PangleAdapterConfiguration.h"
#import <AppLovinSDK/AppLovinSDK.h>
#endif
//#ifndef BYTE_DANCE_ONLY
//@interface EYAdManager()<UnityAdsDelegate, VungleSDKDelegate, ISDemandOnlyInterstitialDelegate, ISDemandOnlyRewardedVideoDelegate>
//#else
@interface EYAdManager()<EYAdDelegate
#ifdef UNITY_ADS_ENABLED
    ,UnityAdsDelegate
#endif
#ifdef VUNGLE_ADS_ENABLED
    ,VungleSDKDelegate
#endif
#ifdef IRON_ADS_ENABLED
    ,ISDemandOnlyInterstitialDelegate,ISDemandOnlyRewardedVideoDelegate
#endif
>
//#endif
{

}

@property(nonatomic,assign) bool isInited;
@property(nonatomic,assign) bool canLoadAd;
@property(nonatomic,strong) NSMutableDictionary<NSString*,EYAdKey*>* adKeyDict;
@property(nonatomic,strong) NSMutableDictionary<NSString*,EYAdGroup*>* adGroupDict;
@property(nonatomic,strong) NSMutableDictionary<NSString*,EYAdPlace*>* adPlaceDict;
@property(nonatomic,strong) NSMutableDictionary<NSString*,EYInterstitialAdGroup*>* interstitialAdGroupDict;
@property(nonatomic,strong) NSMutableDictionary<NSString*,EYNativeAdGroup*>* nativeAdGroupDict;
@property(nonatomic,strong) NSMutableDictionary<NSString*,EYRewardAdGroup*>* rewardAdGroupDict;
@property(nonatomic,strong) NSMutableDictionary<NSString*,EYBannerAdGroup*>* bannerAdGroupDict;
@property(nonatomic,strong) NSMutableDictionary<NSString*,EYSplashAdGroup*>* splashAdGroupDict;
@property(nonatomic,strong) NSMutableDictionary<NSString*,EYBasicAdGroup*>* basicAdGroupDict;
@property(nonatomic,strong) NSMutableDictionary<NSString*,NSString*>*  nativeAdViewNibDict;
@property(nonatomic,strong) NSMutableDictionary<NSNumber*,NSMutableDictionary<NSString*,EYNativeAdView*>*>*  nativeAdViewDict;
@property(nonatomic,weak) UIViewController* nativeAdController;

@property(nonatomic, strong) Class nativeClass;

#ifdef UNITY_ADS_ENABLED
@property(nonatomic,strong) NSMutableDictionary<NSString*, id<UnityAdsDelegate>>* unityAdsDelegateDict;
#endif

#ifdef VUNGLE_ADS_ENABLED
@property(nonatomic,strong) NSMutableDictionary<NSString*, id<VungleSDKDelegate>>* vungleAdsDelegateDict;
#endif

#ifdef IRON_ADS_ENABLED
@property(nonatomic,strong) NSMutableDictionary<NSString*, id<ISDemandOnlyRewardedVideoDelegate>>* ironRewardDelegateDict;
@property(nonatomic,strong) NSMutableDictionary<NSString*, id<ISDemandOnlyInterstitialDelegate>>* ironInterDelegateDict;
#endif
@property(nonatomic,strong) CTCellularData* cellularData;

@end

static id s_sharedInstance;

@implementation EYAdManager

@synthesize adConfig = _adConfig;
@synthesize adKeyDict = _adKeyDict;
@synthesize adGroupDict = _adGroupDict;
@synthesize adPlaceDict = _adPlaceDict;

@synthesize interstitialAdGroupDict = _interstitialAdGroupDict;
@synthesize nativeAdGroupDict = _nativeAdGroupDict;
@synthesize rewardAdGroupDict = _rewardAdGroupDict;
@synthesize bannerAdGroupDict = _bannerAdGroupDict;
@synthesize splashAdGroupDict = _splashAdGroupDict;
@synthesize basicAdGroupDict = _basicAdGroupDict;
@synthesize nativeAdViewDict = _nativeAdViewDict;
@synthesize nativeAdViewNibDict = _nativeAdViewNibDict;
@synthesize nativeAdController = _nativeAdController;
#ifdef UNITY_ADS_ENABLED
@synthesize unityAdsDelegateDict = _unityAdsDelegateDict;
#endif
#ifdef ADMOB_MEDIATION_ENABLED
@synthesize vunglePlacementIds = _vunglePlacementIds;
#endif
#ifdef VUNGLE_ADS_ENABLED
@synthesize vungleAdsDelegateDict = _vungleAdsDelegateDict;
#endif

#ifdef IRON_ADS_ENABLED
@synthesize ironRewardDelegateDict = _ironRewardDelegateDict;
@synthesize ironInterDelegateDict = _ironInterDelegateDict;
#endif

@synthesize cellularData = _cellularData;

+(EYAdManager*) sharedInstance
{
    if (s_sharedInstance == nil)
    {
        s_sharedInstance = [[EYAdManager alloc] init];
    }

    return s_sharedInstance;
}

-(void) loadAdConfig:(EYAdConfig*)config
{
    self.adConfig = config;
    NSData* adKeySettingData = config.adKeyData;
    //NSLog(@"loadAdConfig adKeySettingData = %@", adKeySettingData);
//    NSString* keyStr = [[NSString alloc] initWithData:adKeySettingData encoding:NSASCIIStringEncoding];
    
    NSArray *adKeyArray = [NSJSONSerialization JSONObjectWithData:adKeySettingData options:kNilOptions error:nil];
    NSLog(@"loadAdConfig adKeySettingData = %@", adKeyArray);
    for(NSDictionary* adKeySetting:adKeyArray)
    {
        NSString *keyId = adKeySetting[@"id"];
        NSString *network = adKeySetting[@"network"];
        NSString *key = adKeySetting[@"key"];
        NSString *placementid = adKeySetting[@"placementid"];
        EYAdKey *adKey = [[EYAdKey alloc] initWithId:keyId network:network key:key placementid:placementid];
        [self.adKeyDict setObject:adKey forKey:keyId];
    }
    
    NSData *adSuiteData = config.adSuiteData;
    NSMutableDictionary *adSuiteDictionary = [[NSMutableDictionary alloc]init];
    extern int TIMEOUT_TIME;
    if (adSuiteData == NULL) {
        config.isNewJsonSetting = false;
        TIMEOUT_TIME = 16;
    } else {
        TIMEOUT_TIME = 8;
        config.isNewJsonSetting = true;
        NSArray *adSuiteArray = [NSJSONSerialization JSONObjectWithData:adSuiteData options:kNilOptions error:nil];
        adSuiteArray = [adSuiteArray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *  _Nonnull obj1, NSDictionary *  _Nonnull obj2) {
            if ([obj1[@"value"] intValue] > [obj2[@"value"] intValue]) {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }];
        NSLog(@"loadAdConfig adSuiteData = %@", adSuiteArray);
        for(NSDictionary* adSuiteDict:adSuiteArray) {
            NSString *suiteId = adSuiteDict[@"id"];
            NSNumber *value = adSuiteDict[@"value"];
            NSArray *keys = adSuiteDict[@"keys"];
            NSNumber *priority = adSuiteDict[@"priority"];
            EYAdSuite *suite = [[EYAdSuite alloc]init];
            suite.suiteId = suiteId;
            if (priority != nil) {
                suite.priority = priority.intValue;
            }
            suite.value = value.intValue;
            for (NSString *keyId in keys) {
                EYAdKey *adKey = self.adKeyDict[keyId];
                [suite.keys addObject:adKey];
            }
            [adSuiteDictionary setValue:suite forKey:suiteId];
        }
    }
    
    NSData* adGroupData = config.adGroupData;
    NSArray *adGroupArray = [NSJSONSerialization JSONObjectWithData:adGroupData options:kNilOptions error:nil];
    NSLog(@"loadAdConfig adGroupData = %@", adGroupArray);
    for(NSDictionary* adGroupDict:adGroupArray)
    {
        //NSLog(@"loadAdConfig adCacheDict = %@", adCacheDict);
        NSString *groupId = adGroupDict[@"id"];
        NSString *type = adGroupDict[@"type"];
        NSString *isAutoLoadStr = adGroupDict[@"isAutoLoad"];
        NSArray * keysArray;
        if (config.isNewJsonSetting == false) {
            NSString *keys = adGroupDict[@"keys"];
            NSData *data = [keys dataUsingEncoding:NSUTF8StringEncoding];
            keysArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
        } else {
            keysArray = adGroupDict[@"child"];
        }
        EYAdGroup *adGroup = [[EYAdGroup alloc] initWithId:groupId];
        //        EYAdPlace *place = self.adPlaceDict[groupId];
        for (NSString *suiteId in keysArray) {
            if (config.isNewJsonSetting == false) {
                EYAdKey *adKey = self.adKeyDict[suiteId];
                EYAdSuite *suite = [[EYAdSuite alloc]init];
                suite.suiteId = suiteId;
                [suite.keys addObject:adKey];
                [adGroup addAdSuite:suite];
            } else {
                EYAdSuite *suite = adSuiteDictionary[suiteId];
                [adGroup addAdSuite:suite];
            }
        }
        adGroup.isAutoLoad = [@"true" isEqualToString:isAutoLoadStr];
        adGroup.type = type;
        [self.adGroupDict setObject:adGroup forKey:groupId];
    }
    
    NSData* adSettingData = config.adPlaceData;
    NSArray *adArray = [NSJSONSerialization JSONObjectWithData:adSettingData options:kNilOptions error:nil];
    NSLog(@"loadAdConfig adSettingStr = %@", adArray);
    for(NSDictionary* adSetting:adArray)
    {
        NSString *placeId = adSetting[@"id"];
        NSString *groupId = adSetting[@"cacheGroup"];
        NSString *nibName = adSetting[@"nativeAdLayout"];
        EYAdGroup* group = self.adGroupDict[groupId];
        group.placeId = placeId;
        EYAdPlace *adPlace = [[EYAdPlace alloc] initWithId:placeId groupId:groupId];
        [self.adPlaceDict setObject:adPlace forKey:placeId];
        if(nibName){
            [self.nativeAdViewNibDict setObject:nibName forKey:placeId];
        }
    }
}

- (void) initAdGroup
{
    for(NSString* groupId in self.adGroupDict)
    {
        EYAdGroup* group = self.adGroupDict[groupId];
        if([ADTypeInterstitial isEqualToString:group.type])
        {
            EYInterstitialAdGroup* interstitialAdGroup = [[EYInterstitialAdGroup alloc] initInAdvanceWithGroup:group adConfig:self.adConfig];
            [interstitialAdGroup setDelegate:self];
            [self.interstitialAdGroupDict setObject:interstitialAdGroup forKey:group.groupId];
            [self.basicAdGroupDict setObject:interstitialAdGroup forKey:group.groupId];
            if(group.isAutoLoad && self.canLoadAd)
            {
                [interstitialAdGroup loadAd:@"auto"];
            }
        }else if([ADTypeNative isEqualToString:group.type])
        {
            EYNativeAdGroup* nativeAdGroup = [[EYNativeAdGroup alloc] initInAdvanceWithGroup:group adConfig:self.adConfig];
            [nativeAdGroup setDelegate:self];
            [self.nativeAdGroupDict setObject:nativeAdGroup forKey:group.groupId];
            [self.basicAdGroupDict setObject:nativeAdGroup forKey:group.groupId];
            if(group.isAutoLoad && self.canLoadAd)
            {
                [nativeAdGroup loadAd:@"auto"];
            }
        }else if([ADTypeReward isEqualToString:group.type])
        {
            EYRewardAdGroup* rewardAdGroup = [[EYRewardAdGroup alloc] initInAdvanceWithGroup:group adConfig:self.adConfig];
            [rewardAdGroup setDelegate:self];
            [self.rewardAdGroupDict setObject:rewardAdGroup forKey:group.groupId];
            [self.basicAdGroupDict setObject:rewardAdGroup forKey:group.groupId];
            if(group.isAutoLoad && self.canLoadAd)
            {
                [rewardAdGroup loadAd:@"auto"];
            }
        } else if ([ADTypeBanner isEqualToString:group.type]) {
            EYBannerAdGroup* bannerGroup = [[EYBannerAdGroup alloc]initInAdvanceWithGroup:group adConfig:self.adConfig];
            [bannerGroup setDelegate:self];
            [self.bannerAdGroupDict setObject:bannerGroup forKey:group.groupId];
            [self.basicAdGroupDict setObject:bannerGroup forKey:group.groupId];
            if (group.isAutoLoad && self.rootViewController && self.canLoadAd) {
                [bannerGroup loadAd:@"auto"];
            }
        } else if ([ADTypeSplash isEqualToString:group.type]) {
            EYSplashAdGroup* splashGroup = [[EYSplashAdGroup alloc]initInAdvanceWithGroup:group adConfig:self.adConfig];
            [splashGroup setDelegate:self];
            [self.splashAdGroupDict setObject:splashGroup forKey:group.groupId];
            [self.basicAdGroupDict setObject:splashGroup forKey:group.groupId];
            if (group.isAutoLoad && self.canLoadAd) {
                [splashGroup loadAd:@"auto"];
            }
        }
    }
}

-(void) initSdk:(EYAdConfig*) config
{
#ifdef BYTE_DANCE_ADS_ENABLED
    NSString* wmAppKey = config.wmAppKey;
    if(wmAppKey == NULL || [wmAppKey isEqualToString:@""])
    {
        NSLog(@"setup wmAppKey ==  NULL");
    }else{
        NSLog(@"setup wmAppKey =  %@", wmAppKey);
        [BUAdSDKManager setAppID:wmAppKey];
        [BUAdSDKManager setIsPaidApp:config.isPaidApp];
    }
#endif
    
#ifdef MTG_ADS_ENABLED
    NSString* mtgAppId = config.mtgAppId;
    NSString* mtgAppKey = config.mtgAppKey;
    if(mtgAppId == NULL || [mtgAppId isEqualToString:@""] ||
       mtgAppKey == NULL || [mtgAppKey isEqualToString:@""])
    {
        NSLog(@"setup mtgAppId ==  NULL");
    }else{
        NSLog(@"setup mtgAppId =  %@, mtgAppKey = %@", mtgAppId, mtgAppKey);
        [[MTGSDK sharedInstance] setAppID:mtgAppId ApiKey:mtgAppKey];
    }
#endif
    
#ifdef ADMOB_ADS_ENABLED
    NSString* admobClientId = config.admobClientId;
    if(admobClientId == NULL || [admobClientId isEqualToString:@""])
    {
        NSLog(@"setup admobClientId ==  NULL");
    }else{
        NSLog(@"setup admobClientId =  %@", admobClientId);
        [[GADMobileAds sharedInstance] startWithCompletionHandler:^(GADInitializationStatus * _Nonnull status) {
            NSLog(@"setup admobClient status = %@", status);
        }];
    }
#endif


#ifdef APPLOVIN_ADS_ENABLED
    //init Applovin SDK
    /**
     *需要在info.plist里设置AppLovinSdkKey
     **/
#ifdef APPLOVIN_MAX_ENABLED
    [FBAdSettings setAdvertiserTrackingEnabled:YES];
//    [FBSDKSettings setAdvertiserIDCollectionEnabled:YES];
//    let settings = ALSdkSettings()
//    settings.consentFlowSettings.isEnabled = true
//    settings.consentFlowSettings.privacyPolicyURL = URL(string: "https://your_company_name.com/privacy_policy")
    [ALSdk shared].mediationProvider = @"max";
#endif
    [[ALSdk shared] initializeSdkWithCompletionHandler:^(ALSdkConfiguration *configuration) {
        // AppLovin SDK is initialized, start loading ads
        self.canLoadAd = true;
        [self loadAutoAd];
//        if(self.interstitialAdGroupDict)
//        {
//            for(NSString* groupName in self.interstitialAdGroupDict)
//            {
//                EYAdGroup* group = self.adGroupDict[groupName];
//                if(group && group.isAutoLoad){
//                    [self.interstitialAdGroupDict[groupName] loadAd:@"auto"];
//                }
//            }
//        }
//        if(self.rewardAdGroupDict){
//            for(NSString* groupName in self.rewardAdGroupDict)
//            {
//                EYAdGroup* group = self.adGroupDict[groupName];
//                if(group && group.isAutoLoad){
//                    [self.rewardAdGroupDict[groupName] loadAd:@"auto"];
//                }
//            }
//        }
    }];

#endif
    
#ifdef UNITY_ADS_ENABLED
        NSString* unityClientId = config.unityClientId;
        if(unityClientId == NULL || [unityClientId isEqualToString:@""])
        {
            NSLog(@"setup unityClientId ==  NULL");
        }else{
            NSLog(@"setup unityClientId =  %@", unityClientId);
            //[GADMobileAds configureWithApplicationID:unityClientId];
            [UnityAds initialize:unityClientId];
            [UnityAds addDelegate:self];
//            [UnityAds initialize:unityClientId delegate:self];
        }
#endif
      
#ifdef VUNGLE_ADS_ENABLED
        NSString* vungleClientId = config.vungleClientId;
        if(vungleClientId == NULL || [vungleClientId isEqualToString:@""])
        {
            NSLog(@"setup vungleClientId ==  NULL");
        }else{
            NSLog(@"setup vungleClientId =  %@", vungleClientId);
            NSError* error;
            VungleSDK* sdk = [VungleSDK sharedSDK];
            sdk.delegate = self;
            [sdk startWithAppId:vungleClientId error:&error];
            if(error){
                NSLog(@"setup VungleSDK error =  %@", error);
            }
        }
#endif
    
#ifdef TRADPLUS_ENABLED
    [FBAdSettings setAdvertiserTrackingEnabled:YES];
//    [FBSDKSettings setAdvertiserIDCollectionEnabled:YES];
    [MsSDKUtils msSDKInit:^(NSError * _Nonnull error) {
        NSLog(@"TPSDKInit %@", error);
    }];
#endif
    
#ifdef IRON_ADS_ENABLED
        NSString *ironSourceAppKey = config.ironSourceAppKey;
        if(ironSourceAppKey == NULL || [ironSourceAppKey isEqualToString:@""]) {
            NSLog(@"setup ironSourceAppKey ==  NULL");
        }
        else {
            NSLog(@"setup ironSourceAppKey ==  %@", ironSourceAppKey);
//            [IronSource setInterstitialDelegate:self];
//            [IronSource setRewardedVideoDelegate:self];
            [IronSource initISDemandOnly:ironSourceAppKey adUnits:@[IS_INTERSTITIAL]];
            [IronSource initISDemandOnly:ironSourceAppKey adUnits:@[IS_REWARDED_VIDEO]];

            [IronSource setISDemandOnlyInterstitialDelegate:self];
            [IronSource setISDemandOnlyRewardedVideoDelegate:self];
            [IronSource shouldTrackReachability:YES];
//            [IronSource initWithAppKey:ironSourceAppKey];
            [IronSource setAdaptersDebug:NO];
            [ISIntegrationHelper validateIntegration];
        }
#endif
    
#ifdef ABUADSDK_ENABLED
    [ABUAdSDKManager setAppID:config.abuAppId];
#endif
    
#ifdef MOPUB_ENABLED
    NSString *mopubAdId = config.mopubAdParams[@"mopubAdUnitId"];
    MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization:mopubAdId];
    
    [ALSdk initializeSdk];
    
    NSString *pangleId = config.mopubAdParams[@"pangleApp_id"];
    if (pangleId) {
        sdkConfig.additionalNetworks = @[PangleAdapterConfiguration.class];
        NSDictionary *pangleConfig = @{@"app_id": pangleId};
        sdkConfig.mediatedNetworkConfigurations = [@{@"PangleAdapterConfiguration":pangleConfig} mutableCopy];
    }

//    sdkConfig.loggingLevel = MPBLogLevelDe bug;
//    sdkConfig.allowLegitimateInterest = YES;
    [[MoPub sharedInstance] initializeSdkWithConfiguration:sdkConfig completion:^{
        NSLog(@"SDK initialization complete");
        // SDK initialization complete. Ready to make ad requests.
        dispatch_async(dispatch_get_main_queue(), ^{
            self.canLoadAd = true;
            [self loadAutoAd];
        });
    }];
#endif
}

-(void) setupWithConfig:(EYAdConfig*) config
{
    //NSLog(@"setup 111111111 %@", [NSThread currentThread]);
    //self.interstitialViewController = [[UIViewController alloc] init];
    self.canLoadAd = true;
#ifdef MOPUB_ENABLED
    self.canLoadAd = false;
#endif
#ifdef APPLOVIN_ADS_ENABLED
    self.canLoadAd = false;
#endif
    if(self.isInited)
    {
        NSLog(@"setupWithViewController error,self.isInited = true");
        return;
    }
    if(config==nil)
    {
        NSLog(@"setupWithViewController error,config == nil");
        return;
    }
#ifdef FB_ADS_ENABLED
    [FBAdSettings setAdvertiserTrackingEnabled:YES];
//    [FBSDKSettings setAdvertiserIDCollectionEnabled:YES];
#endif
#ifdef ADMOB_MEDIATION_ENABLED
    [FBAdSettings setAdvertiserTrackingEnabled:YES];
//    [FBSDKSettings setAdvertiserIDCollectionEnabled:YES];
#endif
    [self initSdk:config];
    
    self.adKeyDict = [[NSMutableDictionary alloc] init];
    self.adGroupDict = [[NSMutableDictionary alloc] init];
    self.adPlaceDict = [[NSMutableDictionary alloc] init];
    
    self.interstitialAdGroupDict = [[NSMutableDictionary alloc] init];
    self.basicAdGroupDict = [[NSMutableDictionary alloc] init];
    self.nativeAdGroupDict = [[NSMutableDictionary alloc] init];
    self.rewardAdGroupDict = [[NSMutableDictionary alloc] init];
    self.nativeAdViewDict = [[NSMutableDictionary alloc] init];
    self.nativeAdViewNibDict = [[NSMutableDictionary alloc] init];
    self.bannerAdGroupDict = [[NSMutableDictionary alloc] init];
    self.splashAdGroupDict = [[NSMutableDictionary alloc] init];
    self.nativeAdController = nil;
    self.nativeClass = [EYNativeAdView class];
#ifdef UNITY_ADS_ENABLED
    self.unityAdsDelegateDict = [[NSMutableDictionary alloc] init];
#endif
#ifdef VUNGLE_ADS_ENABLED
    self.vungleAdsDelegateDict = [[NSMutableDictionary alloc] init];
#endif
#ifdef IRON_ADS_ENABLED
    self.ironInterDelegateDict = [[NSMutableDictionary alloc] init];
    self.ironRewardDelegateDict = [[NSMutableDictionary alloc] init];
#endif
    [self loadAdConfig:config];
    [self initAdGroup];
    self.isInited = true;
}

-(void) loadRewardVideoAd:(NSString*) placeId
{
    if(!self.isInited)
    {
        return;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYRewardAdGroup *group = self.rewardAdGroupDict[adPlace.groupId];
        if(group!=nil)
        {
            [group loadAd:placeId];
        }else{
            NSLog(@"loadRewardVideoAd error, group==nil, placeId = %@", placeId);
        }
    }else{
        NSLog(@"loadRewardVideoAd error, adPlace==nil, placeId = %@", placeId);
    }
}

-(void) showRewardVideoAd:(NSString*) placeId withViewController:(UIViewController*)controller
{
    if(!self.isInited)
    {
        return;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYRewardAdGroup *group = self.rewardAdGroupDict[adPlace.groupId];
        if(group!=nil)
        {
            if(![group showAd:placeId controller:controller]){
                [self checkNetworkStatus];
            }
        }else{
            NSLog(@"showRewardVideoAd error, group==nil, placeId = %@", placeId);
        }
    }else{
        NSLog(@"showRewardVideoAd error, adPlace==nil, placeId = %@", placeId);
    }
}

- (NSString *)getAdType:(NSString *)placeId {
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    EYAdGroup *group = self.adGroupDict[adPlace.groupId];
    return group.type;
}

-(void) loadInterstitialAd:(NSString*) placeId
{
    if(!self.isInited)
    {
        return;
    }
    NSLog(@"loadInterstitialAd placeId = %@", placeId);
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYInterstitialAdGroup *group = self.interstitialAdGroupDict[adPlace.groupId];
        if(group!=nil)
        {
            [group loadAd:placeId];
        }else{
            NSLog(@"loadInterstitialAd error, group==nil, placeId = %@", placeId);
        }
    }else{
        NSLog(@"loadInterstitialAd error, adPlace==nil, placeId = %@", placeId);
    }
}

- (void)loadSplashAd:(NSString *)placeId {
    if(!self.isInited)
    {
        return;
    }
    NSLog(@"loadSplashAd placeId = %@", placeId);
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYSplashAdGroup *group = self.splashAdGroupDict[adPlace.groupId];
        if(group!=nil)
        {
            [group loadAd:placeId];
        }else{
            NSLog(@"loadSplashAd error, group==nil, placeId = %@", placeId);
        }
    }else{
        NSLog(@"loadSplashAd error, adPlace==nil, placeId = %@", placeId);
    }
}

- (bool)showAd:(NSString *)placeId withViewController:(UIViewController *)controller {
    if(!self.isInited)
    {
        return false;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYBasicAdGroup *group = self.basicAdGroupDict[adPlace.groupId];
        if(group!=nil)
        {
            if(![group showAd:placeId controller:controller])
            {
                [self checkNetworkStatus];
                return false;
            } else {
                return true;
            }
        }else{
            NSLog(@"showAd error, group==nil, placeId = %@", placeId);
            return false;
        }
    }else{
        NSLog(@"showAd error, adPlace==nil, placeId = %@", placeId);
        return false;
    }
}

-(void) showInterstitialAd:(NSString*) placeId withViewController:(UIViewController*)controller
{
    if(!self.isInited)
    {
        return;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYInterstitialAdGroup *group = self.interstitialAdGroupDict[adPlace.groupId];
        if(group!=nil)
        {
            if(![group showAd:placeId controller:controller])
            {
                [self checkNetworkStatus];
            }
        }else{
            NSLog(@"showSplashAd error, group==nil, placeId = %@", placeId);
        }
    }else{
        NSLog(@"showSplashAd error, adPlace==nil, placeId = %@", placeId);
        
    }
}

- (void)showSplashAd:(NSString *)placeId withViewController:(UIViewController *)controller {
    if(!self.isInited)
    {
        return;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYSplashAdGroup *group = self.splashAdGroupDict[adPlace.groupId];
        if(group!=nil)
        {
            if(![group showAd:placeId controller:controller])
            {
                [self checkNetworkStatus];
            }
        }else{
            NSLog(@"showInterstitialAd error, group==nil, placeId = %@", placeId);
        }
    }else{
        NSLog(@"showInterstitialAd error, adPlace==nil, placeId = %@", placeId);
        
    }
}

- (void)setRootViewController:(UIViewController *)rootViewController {
    _rootViewController = rootViewController;
    if (!self.isInited) {
        return;
    }
    for (EYBannerAdGroup *group in self.bannerAdGroupDict.allValues) {
        if (group.adGroup.isAutoLoad) {
            [group loadAd:@"auto"];
        }
    }
}

-(void)loadAutoAd {
    if(self.interstitialAdGroupDict)
    {
        for(NSString* groupName in self.interstitialAdGroupDict)
        {
            EYAdGroup* group = self.adGroupDict[groupName];
            if(group && group.isAutoLoad){
                [self.interstitialAdGroupDict[groupName] loadAd:@"auto"];
            }
        }
    }
    if(self.rewardAdGroupDict){
        for(NSString* groupName in self.rewardAdGroupDict)
        {
            EYAdGroup* group = self.adGroupDict[groupName];
            if(group && group.isAutoLoad){
                [self.rewardAdGroupDict[groupName] loadAd:@"auto"];
            }
        }
    }
    if(self.nativeAdGroupDict){
        for(NSString* groupName in self.nativeAdGroupDict)
        {
            EYAdGroup* group = self.adGroupDict[groupName];
            if(group && group.isAutoLoad){
                [self.nativeAdGroupDict[groupName] loadAd:@"auto"];
            }
        }
    }
    if(self.bannerAdGroupDict)
    {
        for(NSString* groupName in self.bannerAdGroupDict)
        {
            EYAdGroup* group = self.adGroupDict[groupName];
            if(group && group.isAutoLoad){
                [self.bannerAdGroupDict[groupName] loadAd:@"auto"];
            }
        }
    }
    if(self.splashAdGroupDict)
    {
        for(NSString* groupName in self.splashAdGroupDict)
        {
            EYAdGroup* group = self.adGroupDict[groupName];
            if(group && group.isAutoLoad){
                [self.splashAdGroupDict[groupName] loadAd:@"auto"];
            }
        }
    }
}

-(bool) isNativeAdLoaded:(NSString*) placeId
{
    if(!self.isInited)
    {
        return false;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYNativeAdGroup *group = self.nativeAdGroupDict[adPlace.groupId];
        return group!= nil && [group isCacheAvailable];
    }
    return false;
}

-(bool) isBannerAdLoaded:(NSString*) placeId
{
    if(!self.isInited)
    {
        return false;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYBannerAdGroup *group = self.bannerAdGroupDict[adPlace.groupId];
        return group!= nil && [group isCacheAvailable];
    }
    return false;
}

-(bool) isInterstitialAdLoaded:(NSString*) placeId
{
    if(!self.isInited)
    {
        return false;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYInterstitialAdGroup *group = self.interstitialAdGroupDict[adPlace.groupId];
        return group!= nil && [group isCacheAvailable];
    }
    return false;
}

-(bool) isAdLoaaded:(NSString*) placeId {
    if(!self.isInited)
    {
        return false;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYBasicAdGroup *group = self.basicAdGroupDict[adPlace.groupId];
        return group!= nil && [group isCacheAvailable];
    }
    return false;
}

-(bool) isRewardAdLoaded:(NSString*) placeId
{
    if(!self.isInited)
    {
        return false;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYRewardAdGroup *group = self.rewardAdGroupDict[adPlace.groupId];
        return group!= nil && [group isCacheAvailable];
    }
    return false;
}

- (bool)isSplashAdLoaded:(NSString *)placeId {
    if(!self.isInited)
    {
        return false;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYSplashAdGroup *group = self.splashAdGroupDict[adPlace.groupId];
        return group!= nil && [group isCacheAvailable];
    }
    return false;
}

- (bool)isHighPriorityAdLoaded:(NSString *)placeId {
    if(!self.isInited)
    {
        return false;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYBasicAdGroup *group = self.basicAdGroupDict[adPlace.groupId];
        return group!= nil && [group isHighPriorityCacheAvailable];
    }
    return false;
}

- (bool)isHighPriorityBannerAdLoaded:(NSString *)placeId {
    if(!self.isInited)
    {
        return false;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYBannerAdGroup *group = self.bannerAdGroupDict[adPlace.groupId];
        return group!= nil && [group isHighPriorityCacheAvailable];
    }
    return false;
}

- (bool)isHighPriorityNativeAdLoaded:(NSString *)placeId {
    if(!self.isInited)
    {
        return false;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYNativeAdGroup *group = self.nativeAdGroupDict[adPlace.groupId];
        return group!= nil && [group isHighPriorityCacheAvailable];
    }
    return false;
}

- (bool)isHighPriorityRewardAdLoaded:(NSString *)placeId {
    if(!self.isInited)
    {
        return false;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYRewardAdGroup *group = self.rewardAdGroupDict[adPlace.groupId];
        return group!= nil && [group isHighPriorityCacheAvailable];
    }
    return false;
}

- (bool)isHighPrioritySplashAdLoaded:(NSString *)placeId {
    if(!self.isInited)
    {
        return false;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYSplashAdGroup *group = self.splashAdGroupDict[adPlace.groupId];
        return group!= nil && [group isHighPriorityCacheAvailable];
    }
    return false;
}

- (bool)isHighPriorityInterstitialAdLoaded:(NSString *)placeId {
    if(!self.isInited)
    {
        return false;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYInterstitialAdGroup *group = self.interstitialAdGroupDict[adPlace.groupId];
        return group!= nil && [group isHighPriorityCacheAvailable];
    }
    return false;
}

-(void)loadNativeAd:(NSString*) placeId
{
    if(!self.isInited)
    {
        return;
    }
    NSLog(@"loadNativeAd start placeId = %@", placeId);
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYNativeAdGroup *group = self.nativeAdGroupDict[adPlace.groupId];
        if(group!=nil)
        {
            [group loadAd:placeId];
        }else{
            NSLog(@"loadNativeAd error, group==nil, placeId = %@", placeId);
        }
    }else{
        NSLog(@"loadNativeAd error, adPlace==nil, placeId = %@", placeId);
    }
}

-(void)loadBannerAd:(NSString*) placeId {
    if(!self.isInited)
    {
        return;
    }
    NSLog(@"loadBannerAd start placeId = %@", placeId);
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYBannerAdGroup *group = self.bannerAdGroupDict[adPlace.groupId];
        if(group!=nil)
        {
            [group loadAd:placeId];
        }else{
            NSLog(@"loadBannerAd error, group==nil, placeId = %@", placeId);
        }
    }else{
        NSLog(@"loadBannerAd error, adPlace==nil, placeId = %@", placeId);
    }
}

- (void)registerNativeAdCustomClass:(Class)nativeClass {
    self.nativeClass = nativeClass;
}

-(EYNativeAdView*) getNativeAdViewFromCache:(NSString* )placeId withViewController:(UIViewController*)controller
{
    EYNativeAdView* view = nil;
    auto viewDict = self.nativeAdViewDict[@((long)controller)];
    if(viewDict && viewDict[placeId]){
        view = viewDict[placeId];
    }
    return view;
}

-(void) putNativeAdViewToCache:(EYNativeAdView*) adView placeId:(NSString* )placeId withViewController:(UIViewController*)controller
{
    auto viewDict = self.nativeAdViewDict[@((long)controller)];
    if(viewDict==nil){
        viewDict = [[NSMutableDictionary alloc] init];
        [self.nativeAdViewDict setObject:viewDict forKey:@((long)controller)];
    }
    viewDict[placeId] = adView;
}

-(void) removeNativeAdViewCache:(UIViewController*) controller
{
    auto viewDict = self.nativeAdViewDict[@((long)controller)];
    if(viewDict){
        for(EYNativeAdView* view:[viewDict allValues])
        {
            [view removeFromSuperview];
            [view unregisterView];
        }
        [self.nativeAdViewDict removeObjectForKey:@((long)controller)];
    }
}

-(EYNativeAdView*) getNativeAdView:(NSString* )placeId withViewController:(UIViewController*)controller viewGroup:(UIView*)viewGroup
{
    EYNativeAdView* view = [self getNativeAdViewFromCache:placeId withViewController:controller];
    if(view == nil){
        auto nativeAdViewNib = self.nativeAdViewNibDict[placeId];
        /*NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:nativeAdViewNib owner:controller options:nil];
        view = [nibView firstObject];
        CGRect viewRect = viewGroup.frame;
        view.frame = viewRect;*/
        CGRect rect;
        if (viewGroup) {
            rect = viewGroup.frame;
        } else {
            rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
        }
        rect.origin.x = 0;
        rect.origin.y = 0;
        view = [[_nativeClass alloc] initWithFrame:rect nibName:nativeAdViewNib];
        [self putNativeAdViewToCache:view placeId:placeId withViewController:controller];
    }
    return view;
}

- (UIView *)getNativeView:(NSString *)placeId controller: (UIViewController *)controller {
    EYNativeAdView* view = [self getNativeAdView:placeId withViewController:controller viewGroup:nil];
    if(view){
        view.isNeedUpdate = false;
        view.isCanShow = true;
        EYNativeAdAdapter* adapter = [self getNativeAdAdapter:placeId];
        if (adapter) {
            [view updateNativeAdAdapter:adapter controller:controller];
        } else {
            [self loadNativeAd:placeId];
        }
    }
    return view;
}

-(void) showNativeAd:(NSString*) placeId withViewController:(UIViewController*)controller viewGroup:(UIView*)viewGroup
{
    if(!self.isInited)
    {
        return;
    }
    EYNativeAdView* view = [self getNativeAdView:placeId withViewController:controller viewGroup:viewGroup];
    if(view){
        self.nativeAdController = controller;
        EYNativeAdAdapter* adapter = [view getAdapter];
//        if(adapter){
//            [view setHidden:false];
//        }
        view.isNeedUpdate = false;
        view.isCanShow = true;
        adapter = [self getNativeAdAdapter:placeId];
        if(adapter){
            [viewGroup addSubview:view];
            [view updateNativeAdAdapter:adapter controller:controller];
        }else{
            [self loadNativeAd:placeId];
        }
    }
}

- (UIView *)getBannerView:(NSString *)placeId {
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYBannerAdGroup *group = self.bannerAdGroupDict[adPlace.groupId];
        if(group!=nil)
        {
            group.adPlaceId = placeId;
            return [group getBannerView];
        }else{
            NSLog(@"getbannerview error, group==nil, placeId = %@", placeId);
            return nil;
        }
    }
    return nil;
}

- (bool)showBannerAd:(NSString *)placeId viewGroup:(UIView *)viewGroup {
    if(!self.isInited)
    {
        return false;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYBannerAdGroup *group = self.bannerAdGroupDict[adPlace.groupId];
        if(group!=nil)
        {
            group.adPlaceId = placeId;
            return [group showAdGroup:viewGroup];
        }else{
            NSLog(@"showbannerAd error, group==nil, placeId = %@", placeId);
            return false;
        }
    }else{
        NSLog(@"showBannerAd error, adPlace==nil, placeId = %@", placeId);
        return false;
    }
}

-(void) hideNativeAd:(NSString*) placeId forController:(UIViewController*)controller
{
    EYNativeAdView* view = [self getNativeAdViewFromCache:placeId withViewController:controller];
    if(view){
//        [view setHidden:true];
        view.isCanShow = false;
    }
}

-(EYNativeAdAdapter*) getNativeAdAdapter:(NSString*) adPlaceId
{
    EYNativeAdAdapter* adapter = nil;
    EYAdPlace* adPlace = self.adPlaceDict[adPlaceId];
    if(adPlace != nil)
    {
        EYNativeAdGroup *group = self.nativeAdGroupDict[adPlace.groupId];
        if(group!=nil && [group isCacheAvailable])
        {
            group.adPlaceId = adPlaceId;
            adapter = [group getAvailableAdapter];
        }
    }
    return adapter;
}

-(void) onNativeAdLoaded:(NSString*) adPlaceId
{
    NSLog(@"AdPlayer onNativeAdLoaded , adPlaceId = %@", adPlaceId);
    EYNativeAdView* view = [self getNativeAdViewFromCache:adPlaceId withViewController:self.nativeAdController];
    if(view && view.isCanShow && view.isNeedUpdate)
    {
        EYNativeAdAdapter* adapter = [self getNativeAdAdapter:adPlaceId];
        if(adapter)
        {
            [view updateNativeAdAdapter:adapter controller:self.nativeAdController];
        }
    }
}

- (void)onAdLoaded:(EYuAd *)eyuAd {
    NSLog(@"AdPlayer onAdLoaded , adPlaceId = %@, type = %@", eyuAd.placeId, eyuAd.adFormat);
    if(self.delegate)
    {
        [self.delegate onAdLoaded:eyuAd];
    }
    
    if([ADTypeNative isEqualToString:eyuAd.adFormat])
    {
        [self onNativeAdLoaded:eyuAd.placeId];
    }
}

- (void)onAdReward:(EYuAd *)eyuAd {
    NSLog(@"AdPlayer onAdReward , adPlaceId = %@, type = %@", eyuAd.placeId, eyuAd.adFormat);
    if(self.delegate)
    {
        [self.delegate onAdReward:eyuAd];
    }
}

- (void)onAdShowed:(EYuAd *)eyuAd {
    NSLog(@"AdPlayer onAdShowed , adPlaceId = %@, type = %@", eyuAd.placeId, eyuAd.adFormat);
    if(self.delegate)
    {
        [self.delegate onAdShowed:eyuAd];
    }
}

- (void)onAdRevenue:(EYuAd *)eyuAd {
    NSLog(@"AdPlayer onAdShowedData , adPlaceId = %@, type = %@", eyuAd.placeId, eyuAd.adFormat);
    if(self.delegate && [self.delegate respondsToSelector:@selector(onAdRevenue:)])
    {
        [self.delegate onAdRevenue:eyuAd];
    }
}

- (void)onAdClosed:(EYuAd *)eyuAd {
    NSLog(@"AdPlayer onAdClosed , adPlaceId = %@, type = %@", eyuAd.placeId, eyuAd.adFormat);
    if(self.delegate)
    {
        [self.delegate onAdClosed:eyuAd];
    }
}

- (void)onAdClicked:(EYuAd *)eyuAd {
    NSLog(@"AdPlayer onAdClicked , adPlaceId = %@, type = %@", eyuAd.placeId, eyuAd.adFormat);
    if(self.delegate)
    {
        [self.delegate onAdClicked:eyuAd];
    }
}

- (void)onAdLoadFailed:(EYuAd *)eyuAd {
    NSLog(@"AdPlayer onAdLoadFailed , adPlaceId = %@, key = %@, code = %ld",  eyuAd.placeId, eyuAd.unitId, eyuAd.error.code);
}

- (void)onAdImpression:(EYuAd *)eyuAd {
    NSLog(@"AdPlayer onAdImpression , adPlaceId = %@, type = %@", eyuAd.placeId, eyuAd.adFormat);
    if(self.delegate)
    {
        [self.delegate onAdImpression:eyuAd];
    }
}

-(EYAdKey*) getAdKeyWithId:(NSString*) keyId
{
     return self.adKeyDict[keyId];
}

#ifdef UNITY_ADS_ENABLED

-(void) addUnityAdsDelegate:(id<UnityAdsDelegate>) delegate withKey:(NSString*) adKey
{
    [self.unityAdsDelegateDict setObject:delegate forKey:adKey];
}

-(void) removeUnityAdsDelegate:(id<UnityAdsDelegate>) delegate forKey:(NSString *)adKey
{
    if(self.unityAdsDelegateDict[adKey] == delegate){
        self.unityAdsDelegateDict[adKey] = nil;
    }
}

- (void)unityAdsReady:(NSString *)placementId{
    NSLog(@"unityAdsReady , placementId = %@", placementId);
    id<UnityAdsDelegate> delegate = self.unityAdsDelegateDict[placementId];
    if(delegate){
        [delegate unityAdsReady:placementId];
    }
}

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message{
    NSLog(@"unityAdsDidError , message = %@, error = %d", message, (int)error);
//    id<UnityAdsDelegate> delegate = self.unityAdsDelegateDict[placementId];
//    if(delegate){
//        [delegate unityAdsDidError:error :placementId];
//    }
}

- (void)unityAdsDidStart:(NSString *)placementId{
    NSLog(@"unityAdsDidStart , placementId = %@", placementId);
    id<UnityAdsDelegate> delegate = self.unityAdsDelegateDict[placementId];
    if(delegate){
        [delegate unityAdsDidStart:placementId];
    }
}

- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state{
    NSLog(@"unityAdsDidFinish , placementId = %@, withFinishState = %d", placementId, (int)state);
    id<UnityAdsDelegate> delegate = self.unityAdsDelegateDict[placementId];
    if(delegate){
        [delegate unityAdsDidFinish:placementId withFinishState:state];
    }
}
#endif /**UNITY_ADS_ENABLED*/

#ifdef VUNGLE_ADS_ENABLED
-(void) addVungleAdsDelegate:(id<VungleSDKDelegate>) delegate withKey:(NSString*) adKey
{
    [self.vungleAdsDelegateDict setObject:delegate forKey:adKey];
}
    
-(void) removeVungleAdsDelegate:(id<VungleSDKDelegate>) delegate forKey:(NSString *)adKey
{
    if(self.vungleAdsDelegateDict[adKey] == delegate){
        self.vungleAdsDelegateDict[adKey] = nil;
    }
}

/**
 * If implemented, this will get called when the SDK has an ad ready to be displayed. Also it will
 * get called with an argument `NO` for `isAdPlayable` when for some reason, there is
 * no ad available, for instance there is a corrupt ad or the OS wiped the cache.
 * Please note that receiving a `NO` here does not mean that you can't play an Ad: if you haven't
 * opted-out of our Exchange, you might be able to get a streaming ad if you call `play`.
 * @param isAdPlayable A boolean indicating if an ad is currently in a playable state
 * @param placementID The ID of a placement which is ready to be played
 * @param error The error that was encountered.  This is only sent when the placementID is nil.
 */
- (void)vungleAdPlayabilityUpdate:(BOOL)isAdPlayable placementID:(nullable NSString *)placementID error:(nullable NSError *)error
{
    NSLog(@"vungleAdPlayabilityUpdate , placementId = %@, isAdPlayable = %d, error = %@", placementID, isAdPlayable, error);
    id<VungleSDKDelegate> delegate = self.vungleAdsDelegateDict[placementID];
    if(delegate){
        [delegate vungleAdPlayabilityUpdate:isAdPlayable placementID:placementID error:error];
    }
}

/**
 * If implemented, this will get called when the SDK is about to show an ad. This point
 * might be a good time to pause your game, and turn off any sound you might be playing.
 * @param placementID The placement which is about to be shown.
 */
- (void)vungleWillShowAdForPlacementID:(nullable NSString *)placementID
{
    NSLog(@"vungleWillShowAdForPlacementID , placementId = %@", placementID);
    id<VungleSDKDelegate> delegate = self.vungleAdsDelegateDict[placementID];
    if(delegate){
        [delegate vungleWillShowAdForPlacementID:placementID];
    }
}

/**
 * If implemented, this method gets called when a Vungle Ad Unit has been completely dismissed.
 * At this point, you can load another ad for non-auto-cahced placement if necessary.
 */
- (void)vungleDidCloseAdWithViewInfo:(nonnull VungleViewInfo *)info placementID:(nonnull NSString *)placementID
{
    NSLog(@"vungleDidCloseAdWithViewInfo , placementId = %@, info = %@", placementID, info);
    id<VungleSDKDelegate> delegate = self.vungleAdsDelegateDict[placementID];
    if(delegate){
        [delegate vungleDidCloseAdWithViewInfo:info placementID:placementID];
    }
}

/**
 * If implemented, this will get called when VungleSDK has finished initialization.
 * It's only at this point that one can call `playAd:options:placementID:error`
 * and `loadPlacementWithID:` without getting initialization errors
 */
- (void)vungleSDKDidInitialize
{
    NSLog(@"vungleSDKDidInitialize");
}

/**
 * If implemented, this will get called if the VungleSDK fails to initialize.
 * The included NSError object should give some information as to the failure reason.
 * @note If initialization fails, you will need to restart the VungleSDK.
 */
- (void)vungleSDKFailedToInitializeWithError:(NSError *)error
{
    NSLog(@"vungleSDKFailedToInitializeWithError , error = %@", error);
}
#endif /**VUNGLE_ADS_ENABLED*/

#ifdef IRON_ADS_ENABLED
#pragma mark - ISDemandOnlyInterstitialDelegate
//Invoked when Interstitial Ad is ready to be shown after the load function was called.
- (void)interstitialDidLoad:(NSString *)instanceId {
    if(self.ironInterDelegateDict[instanceId])
    {
        [self.ironInterDelegateDict[instanceId] interstitialDidLoad:instanceId];
    }
}
//Called if showing the Interstitial for the user has failed.
//You can learn about the reason by examining the ‘error’ value
- (void)interstitialDidFailToShowWithError:(NSError *)error instanceId:(NSString *)instanceId {
    if(self.ironInterDelegateDict[instanceId])
    {
        [self.ironInterDelegateDict[instanceId] interstitialDidFailToShowWithError:error instanceId:instanceId];
    }
}
//Called each time the end user has clicked on the Interstitial ad.
- (void)didClickInterstitial:(NSString *)instanceId {
    if(self.ironInterDelegateDict[instanceId])
    {
        [self.ironInterDelegateDict[instanceId] didClickInterstitial:instanceId];
    }
}
//Called each time the Interstitial window is about to close
- (void)interstitialDidClose:(NSString *)instanceId {
    if(self.ironInterDelegateDict[instanceId])
    {
        [self.ironInterDelegateDict[instanceId] interstitialDidClose:instanceId];
    }
}
//Called each time the Interstitial window is about to open
- (void)interstitialDidOpen:(NSString *)instanceId {
    if(self.ironInterDelegateDict[instanceId])
    {
        [self.ironInterDelegateDict[instanceId] interstitialDidOpen:instanceId];
    }
}
//Invoked when there is no Interstitial Ad available after calling the load function.
//@param error - will contain the failure code and description.
- (void)interstitialDidFailToLoadWithError:(NSError *)error instanceId:(NSString *)instanceId {
    if(self.ironInterDelegateDict[instanceId])
    {
        [self.ironInterDelegateDict[instanceId] interstitialDidFailToLoadWithError:error instanceId:instanceId];
    }
}

#pragma mark - ISDemandOnlyRewardedVideoDelegate
//Called after a rewarded video has been requested and load succeed.
- (void)rewardedVideoDidLoad:(NSString *)instanceId{
    if(self.ironRewardDelegateDict[instanceId]){
        [self.ironRewardDelegateDict[instanceId] rewardedVideoDidLoad:instanceId];
    }
}
//Called after a rewarded video has attempted to load but failed.
//@param error The reason for the error
- (void)rewardedVideoDidFailToLoadWithError:(NSError *)error instanceId:(NSString* )instanceId{
    if(self.ironRewardDelegateDict[instanceId]){
        [self.ironRewardDelegateDict[instanceId] rewardedVideoDidFailToLoadWithError:error instanceId:instanceId];
    }
}
//Called after a rewarded video has been viewed completely and the user is //eligible for reward.
- (void)rewardedVideoAdRewarded:(NSString *)instanceId{
    if(self.ironRewardDelegateDict[instanceId]){
        [self.ironRewardDelegateDict[instanceId] rewardedVideoAdRewarded:instanceId];
    }
}
//Called after a rewarded video has attempted to show but failed.
//@param error The reason for the error
- (void)rewardedVideoDidFailToShowWithError:(NSError *)error instanceId:(NSString *)instanceId {
    if(self.ironRewardDelegateDict[instanceId]){
        [self.ironRewardDelegateDict[instanceId] rewardedVideoDidFailToShowWithError:error instanceId:instanceId];
    }
}
//Called after a rewarded video has been opened.
- (void)rewardedVideoDidOpen:(NSString *)instanceId {
    if(self.ironRewardDelegateDict[instanceId]){
        [self.ironRewardDelegateDict[instanceId] rewardedVideoDidOpen:instanceId];
    }
}
//Called after a rewarded video has been dismissed.
- (void)rewardedVideoDidClose:(NSString *)instanceId {
    if(self.ironRewardDelegateDict[instanceId]){
        [self.ironRewardDelegateDict[instanceId] rewardedVideoDidClose:instanceId];
    }
}
//Invoked when the end user clicked on the RewardedVideo ad
- (void)rewardedVideoDidClick:(NSString *)instanceId
{
    if(self.ironRewardDelegateDict[instanceId]){
        [self.ironRewardDelegateDict[instanceId] rewardedVideoDidClick:instanceId];
    }
}


-(void) addIronInterDelegate:(id<ISDemandOnlyInterstitialDelegate>) delegate withKey:(NSString*) adKey
{
    self.ironInterDelegateDict[adKey] = delegate;
}

-(void) removeIronInterDelegate:(id<ISDemandOnlyInterstitialDelegate>) delegate  forKey:(NSString *)adKey
{
    if(self.ironInterDelegateDict[adKey] == delegate){
        self.ironInterDelegateDict[adKey] = nil;
    }
}

-(void) addIronRewardDelegate:(id<ISDemandOnlyRewardedVideoDelegate>) delegate withKey:(NSString*) adKey
{
    self.ironRewardDelegateDict[adKey] = delegate;
}

-(void) removeIronRewardDelegate:(id<ISDemandOnlyRewardedVideoDelegate>) delegate  forKey:(NSString *)adKey
{
    if(self.ironRewardDelegateDict[adKey] == delegate){
        self.ironRewardDelegateDict[adKey] = nil;
    }
}

#endif /**IRON_ADS_ENABLED*/
-(void) onDefaultNativeAdClicked
{
    if(self.delegate!= nil && [self.delegate respondsToSelector:@selector(onDefaultNativeAdClicked)])
    {
        [self.delegate onDefaultNativeAdClicked];
    }
}

-(void) reset
{
#ifdef VUNGLE_ADS_ENABLED
    [self.vungleAdsDelegateDict removeAllObjects];
#endif

#ifdef UNITY_ADS_ENABLED
    [self.unityAdsDelegateDict removeAllObjects];
#endif

#ifdef IRON_ADS_ENABLED
    [self.ironRewardDelegateDict removeAllObjects];
    [self.ironInterDelegateDict removeAllObjects];
#endif
    [self.rewardAdGroupDict removeAllObjects];
    [self.interstitialAdGroupDict removeAllObjects];
    [self.basicAdGroupDict removeAllObjects];
    [self.nativeAdGroupDict removeAllObjects];
    [self.bannerAdGroupDict removeAllObjects];
    [self.nativeAdViewDict removeAllObjects];
    [self.nativeAdViewNibDict removeAllObjects];
    [self.adKeyDict removeAllObjects];
    [self.adGroupDict removeAllObjects];
    [self.adPlaceDict removeAllObjects];
    self.isInited = NO;
}

-(void) checkNetworkStatus
{
    bool showNetworkAlert = [[NSUserDefaults standardUserDefaults] boolForKey:@"SHOW_NETWORK_ALERT"];
    if(!showNetworkAlert){
        if(self->_cellularData == nil){
            self->_cellularData = [[CTCellularData alloc] init];
            __block EYAdManager *blockSelf = self;

            self->_cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state)
            {
                switch (state)
                {
                case kCTCellularDataRestricted: NSLog(@"Restricrted");
                        [blockSelf showNetworkAlert];
                        break;
                case kCTCellularDataNotRestricted: NSLog(@"Not Restricted"); break;
                    //未知，第一次请求
                case kCTCellularDataRestrictedStateUnknown: NSLog(@"Unknown"); break;
                default: break;
                };
            };
        }else{
            CTCellularDataRestrictedState state = self.cellularData.restrictedState;
            if(state == kCTCellularDataRestricted)
            {
                [self showNetworkAlert];
            }
        }
    }
}

-(void) showNetworkAlert
{
    dispatch_async(dispatch_get_main_queue(), ^{
        bool showNetworkAlert = [[NSUserDefaults standardUserDefaults] boolForKey:@"SHOW_NETWORK_ALERT"];
            if(!showNetworkAlert){
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"SHOW_NETWORK_ALERT"];
                UIAlertController* networkAlertController = [UIAlertController alertControllerWithTitle:@"Network connection failed" message:@"Your device is not connected. Please check your cellular data setting." preferredStyle:UIAlertControllerStyleAlert];
        //        __block UIAlertController *blockAlertController = networkAlertController;
                [networkAlertController addAction:[UIAlertAction actionWithTitle:@"Cannel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //            if(blockAlertController){
        //                [blockAlertController dismissViewControllerAnimated:YES completion:nil];
        //            }
                }]];
                
                [networkAlertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                            [[UIApplication sharedApplication] openURL:settingsURL];
                        }
                }]];
                [SVProgressHUD dismiss];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:networkAlertController animated:YES completion:nil];

            }
    });
}

@end
