//
//  EYBannerAdGroup.m
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/7.
//

#import <Foundation/Foundation.h>
#import "EYBannerAdGroup.h"
#import "EYBannerAdAdapter.h"
#import "EYAdKey.h"
#import "EYAdManager.h"
#import "EYABUBannerAdAdapter.h"

@interface EYBannerAdGroup()

@property(nonatomic,strong)NSDictionary<NSString*, Class> *adapterClassDict;
//@property(nonatomic,copy)NSString *adPlaceId;

//@property(nonatomic,assign)int tryLoadAdCounter;
//@property(nonatomic,assign)int curLoadingIndex;

@end

@implementation EYBannerAdGroup
@synthesize adapterClassDict = _adapterClassDict;
//@synthesize curLoadingIndex = _curLoadingIndex;
//@synthesize tryLoadAdCounter = _tryLoadAdCounter;

- (EYBannerAdGroup *)initInAdvanceWithGroup:(EYAdGroup *)adGroup adConfig:(EYAdConfig *)adConfig {
    if (adConfig.isNewJsonSetting == false) {
        return [self initWithGroup:adGroup adConfig:adConfig];
    }
    self.adType = ADTypeBanner;
    self = [super initInAdvanceWithGroup:adGroup adConfig:adConfig];
    return self;
}

- (EYBannerAdGroup *)initWithGroup:(EYAdGroup *)adGroup adConfig:(EYAdConfig *)adConfig {
    self = [super initWithGroup:adGroup adConfig:adConfig];
    if (self) {
        self.adapterClassDict = [[NSDictionary alloc] initWithObjectsAndKeys:
#ifdef FB_ADS_ENABLED
            NSClassFromString(@"EYFBBannerAdapter"), ADNetworkFacebook,
#endif
                                 
#ifdef ADMOB_ADS_ENABLED
            NSClassFromString(@"EYAdmobBannerAdapter"), ADNetworkAdmob,
#endif
                                 
#ifdef ANYTHINK_ENABLED
            NSClassFromString(@"EYATBannerAdAdapter"), ADNetworkAnyThink,
#endif
#ifdef TRADPLUS_ENABLED
            NSClassFromString(@"EYTPBannerAdAdapter"), ADNetworkTradPlus,
#endif
#ifdef APPLOVIN_MAX_ENABLED
            NSClassFromString(@"EYMaxBannerAdAdapter"), ADNetworkMAX,
#endif
#ifdef BYTE_DANCE_ADS_ENABLED
            NSClassFromString(@"EYWMBannerAdAdapter"), ADNetworkWM,
#endif
#ifdef ABUADSDK_ENABLED
            NSClassFromString(@"EYABUBannerAdAdapter"), ADNetworkABU,
#endif
#ifdef MOPUB_ENABLED
            NSClassFromString(@"EYMopubBannerAdAdapter"), ADNetworkMopub,
#endif
        nil];
        self.adValueKey = [NSString stringWithFormat:@"currentBannerValue%d", self.priority + 1];
        self.adType = ADTypeBanner;
//        self.curLoadingIndex = -1;
//        self.tryLoadAdCounter = 0;
        [self initAdatperArray];
        self.maxTryLoadAd = 3;
    }
    return self;
}

//- (NSString *)adPlaceId {
//    return self.adGroup.groupId;
//}

//-(void) loadAd:(NSString*)placeId
//{
//    self.adPlaceId = placeId;
//    if(self.adapterArray.count == 0) return;
//    EYAdAdapter* adapter = self.adapterArray[0];
//    [adapter loadAd];
//    if (self.adapterArray.count > 1 && self.adGroup.isAutoLoad) {
//        [self.adapterArray[1] loadAd];
//    }
////    self.curLoadingIndex = 0;
////    self.tryLoadAdCounter = 1;
//}

- (bool)showAdGroup:(UIView *)viewGroup{
    NSLog(@"showBannerAd placeId = %@", self.adPlaceId);
    if (self.groupArray != nil) {
        for (EYBannerAdGroup *group in self.groupArray) {
            if ([group showAdGroup:viewGroup]) {
                return true;
            }
        }
        return false;
    }
    EYBannerAdAdapter* loadAdapter = [self getAvailableAdapter];
    if (loadAdapter) {
        loadAdapter.adKey.placementid = self.adPlaceId;
        [loadAdapter showAdGroup:viewGroup];
        return true;
    }
    [self loadAd:self.adPlaceId];
    return false;
}

- (UIView *)getBannerView {
    NSLog(@"getBannerAd placeId = %@", self.adPlaceId);
    if (self.groupArray != nil) {
        for (EYBannerAdGroup *group in self.groupArray) {
            UIView *view = [group getBannerView];
            if (view) {
                return view;
            }
        }
        return nil;
    }
    EYBannerAdAdapter* loadAdapter = [self getAvailableAdapter];
    if (loadAdapter) {
        return [loadAdapter getBannerView];
    }
    return nil;
}

-(EYBannerAdAdapter*) getAvailableAdapter
{
    EYAdAdapter* loadAdapter = NULL;
    int index = 0;
    bool hasLoadedAdapter = false;
    for (int i = 0; i < self.adapterArray.count; i++) {
        EYAdAdapter* adapter = self.adapterArray[i];
        if([adapter isAdLoaded])
        {
            if (loadAdapter == NULL) {
                loadAdapter = adapter;
                index = i;
            } else {
                hasLoadedAdapter = true;
            }
        }
    }
    if(loadAdapter != NULL)
    {
        [self.adapterArray removeObject:loadAdapter];
        EYAdKey* adKey = loadAdapter.adKey;
        EYAdAdapter* newAdapter = [self createAdAdapterWithKey:adKey adGroup:self.adGroup];
//        if(newAdapter && self.adGroup.isAutoLoad)
//        {
//            [newAdapter loadAd];
//        }
        [self.adapterArray insertObject:newAdapter atIndex:index];
    }
    if (hasLoadedAdapter == false || loadAdapter == NULL) {
        [self loadAd:self.adPlaceId];
    }
    return (EYBannerAdAdapter *)loadAdapter;
}

- (EYAdAdapter *)createAdAdapterWithKey:(EYAdKey *)adKey adGroup:(EYAdGroup *)group {
    EYBannerAdAdapter* adapter = NULL;
    NSString* network = adKey.network;
    Class adapterClass = self.adapterClassDict[network];
    if(adapterClass!= NULL){
        adapter = [[adapterClass alloc] initWithAdKey:adKey adGroup:group];
    }
    if(adapter != NULL)
    {
        adapter.delegate = self;
    }
    return adapter;
}


//- (void)onAdLoaded:(EYBannerAdAdapter *)adapter {
////    if(self.curLoadingIndex>=0 && self.adapterArray[self.curLoadingIndex] == adapter)
////    {
////        self.curLoadingIndex = -1;
////    }
//    if(self.delegate)
//    {
//        [self.delegate onAdLoaded:self.adPlaceId type:ADTypeBanner];
//    }
////    if(self.reportEvent){
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setObject:adapter.adKey.keyId forKey:@"type"];
//        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOAD_SUCCESS]  parameters:dic];
////    }
//}
//
//- (void)onAdLoadFailed:(EYBannerAdAdapter *)adapter withError:(int)errorCode {
//    EYAdKey* adKey = adapter.adKey;
//    NSLog(@"onAdLoadFailed adKey = %@, errorCode = %d", adKey.keyId, errorCode);
//
//    if(self.reportEvent){
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setObject:[[NSString alloc] initWithFormat:@"%d",errorCode] forKey:@"code"];
//        [dic setObject:adKey.keyId forKey:@"type"];
//        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOAD_FAILED]  parameters:dic];
//    }
//    if(adapter.tryLoadAdCount >= self.maxTryLoadAd){
//
//    }else{
//        adapter.tryLoadAdCount++;
//        if(self.reportEvent){
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//            [dic setObject:adapter.adKey.keyId forKey:@"type"];
//            [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOADING]  parameters:dic];
//        }
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [adapter loadAd];
//         });
//    }
//    if(self.delegate)
//    {
//        [self.delegate onAdLoadFailed:self.adPlaceId key:adKey.keyId code:errorCode];
//    }
//}

- (void)onAdShowed:(EYBannerAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd {
    if(self.delegate)
    {
        [self.delegate onAdShowed:eyuAd];
    }
//    if(self.reportEvent){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:adapter.adKey.keyId forKey:@"type"];
        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_SHOW]  parameters:dic];
//    }
}

- (void)onAdRevenue:(EYAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onAdRevenue:)])
    {
        [self.delegate onAdRevenue:eyuAd];
    }
}

- (void)onAdClicked:(EYBannerAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd {
    if(self.delegate)
    {
        [self.delegate onAdClicked:eyuAd];
    }
    if(self.reportEvent){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:adapter.adKey.keyId forKey:@"type"];
        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_CLICKED]  parameters:dic];
    }
}

- (void)onAdImpression:(EYBannerAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd {
    if(self.delegate)
    {
        [self.delegate onAdImpression:eyuAd];
    }
    EYAdKey *adKey = adapter.adKey;
    if(adKey){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:adKey.network forKey:@"network"];
        [dic setObject:adKey.key forKey:@"unit"];
        [dic setObject:ADTypeBanner forKey:@"type"];
        [dic setObject:adKey.keyId forKey:@"keyId"];
        [EYEventUtils logEvent:EVENT_AD_IMPRESSION  parameters:dic];
    }
}

-(void) onAdClosed:(EYInterstitialAdAdapter*)adapter eyuAd:(EYuAd *)eyuAd
{
    if(self.delegate)
    {
        [self.delegate onAdClosed:eyuAd];
    }
}
@end
