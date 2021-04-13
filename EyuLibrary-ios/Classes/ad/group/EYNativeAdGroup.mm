//
//  NativeAdGroup.m
//  Freecell
//
//  Created by apple on 2018/7/13.
//

#import <Foundation/Foundation.h>
#import "EYNativeAdGroup.h"
#import "EYAdKey.h"
#import "EYEventUtils.h"

@interface EYNativeAdGroup ()
@property(nonatomic,strong)NSDictionary<NSString*, Class> *adapterClassDict;
@property(nonatomic,copy)NSString *adPlaceId;

@end

@implementation EYNativeAdGroup
@synthesize adapterClassDict = _adapterClassDict;

-(EYNativeAdGroup*) initWithGroup:(EYAdGroup*)group adConfig:(EYAdConfig*) adConfig
{
    self = [super init];
    if(self)
    {
        self.adapterClassDict = [[NSDictionary alloc] initWithObjectsAndKeys:
#ifdef FB_ADS_ENABLED
        NSClassFromString(@"EYFbNativeAdAdapter"), ADNetworkFacebook,
#endif
#ifdef ADMOB_ADS_ENABLED
        NSClassFromString(@"EYAdmobNativeAdAdapter"), ADNetworkAdmob,
#endif
#ifdef APPLOVIN_ADS_ENABLED
        NSClassFromString(@"EYApplovinNativeAdAdapter"), ADNetworkApplovin,
#endif
#ifdef BYTE_DANCE_ADS_ENABLED
        NSClassFromString(@"EYWMNativeAdAdapter"), ADNetworkWM,
#endif
#ifdef MTG_ADS_ENABLED
        NSClassFromString(@"EYMtgNativeAdAdapter"), ADNetworkMtg,
#endif
#ifdef ANYTHINK_ENABLED
        NSClassFromString(@"EYATNativeAdAdapter"), ADNetworkAnyThink,
#endif
#ifdef TRADPLUS_ENABLED
        NSClassFromString(@"EYTPNativeAdAdapter"), ADNetworkTradPlus,
#endif
#ifdef ABUADSDK_ENABLED
        NSClassFromString(@"EYABUNativeAdAdapter"), ADNetworkABU,
#endif
#ifdef MOPUB_ENABLED
        NSClassFromString(@"EYMopubNativeAdAdapter"), ADNetworkMopub,
#endif
        nil];
        self.adValueKey = @"currentNativeValue";
        self.adType = ADTypeNative;

//        self.maxTryLoadAd = adConfig.maxTryLoadNativeAd > 0 ? adConfig.maxTryLoadNativeAd : 7;
        [self initAdatperArray];
        self.maxTryLoadAd = ((int)self.adapterArray.count) * 2;
    }
    return self;
}

- (NSString *)adPlaceId {
    return self.adGroup.groupId;
}

//-(void) loadAd:(NSString*)placeId
//{
//    self.adPlaceId = placeId;
//    if(self.adapterArray.count == 0) return;
//    self.curLoadingIndex = 0;
//    self.tryLoadAdCounter = 1;
//
//    EYNativeAdAdapter* adapter = self.adapterArray[0];
//    [adapter loadAd];
//}

-(bool) isCacheAvailable
{
    for(EYNativeAdAdapter* adapter in self.adapterArray)
    {
        if([adapter isAdLoaded])
        {
            return true;
        }
    }
    return false;
}

-(EYNativeAdAdapter*) getAvailableAdapter
{
    EYAdAdapter* loadAdapter = NULL;
    int index = 0;
    for(EYAdAdapter* adapter in self.adapterArray)
    {
        if([adapter isAdLoaded])
        {
            loadAdapter = adapter;
            break;
        }
        index++;
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
    if (index == self.adapterArray.count-1 || loadAdapter == NULL) {
        [self loadAd:@"auto"];
    }
    return (EYNativeAdAdapter *)loadAdapter;
}

-(EYNativeAdAdapter*) createAdAdapterWithKey:(EYAdKey*)adKey adGroup:(EYAdGroup*)group
{
    EYNativeAdAdapter* adapter = NULL;
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

//-(void) onAdLoaded:(EYNativeAdAdapter *)adapter
//{
//    if(self.curLoadingIndex>=0 && self.adapterArray[self.curLoadingIndex] == adapter)
//    {
//        self.curLoadingIndex = -1;
//    }
//    if(self.delegate)
//    {
//        [self.delegate onAdLoaded:self.adPlaceId type:ADTypeNative];
//    }
//
////    if(self.reportEvent){
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setObject:adapter.adKey.keyId forKey:@"type"];
//        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOAD_SUCCESS]  parameters:dic];
////    }
//}

//-(void) onAdLoadFailed:(EYNativeAdAdapter*)adapter withError:(int)errorCode
//{
//    EYAdKey* adKey = adapter.adKey;
//    NSLog(@"onAdLoadFailed adKey = %@, errorCode = %d", adKey.keyId, errorCode);
//
//    if(self.reportEvent){
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setObject:[[NSString alloc] initWithFormat:@"%d",errorCode] forKey:@"code"];
//        [dic setObject:adKey.keyId forKey:@"type"];
//        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOAD_FAILED]  parameters:dic];
//    }
//
//    if(self.curLoadingIndex>=0 && self.adapterArray[self.curLoadingIndex] == adapter)
//    {
//        if(self.tryLoadAdCounter >= self.maxTryLoadAd){
//            self.curLoadingIndex = -1;
//        }else{
//            self.tryLoadAdCounter++;
//            self.curLoadingIndex = (self.curLoadingIndex+1)%self.adapterArray.count;
//            EYNativeAdAdapter* adapter = self.adapterArray[self.curLoadingIndex];
//            [adapter loadAd];
//
//            if(self.reportEvent){
//                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//                [dic setObject:adapter.adKey.keyId forKey:@"type"];
//                [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOADING]  parameters:dic];
//            }
//        }
//    }
//    if(self.delegate)
//    {
//        [self.delegate onAdLoadFailed:self.adPlaceId key:adKey.keyId code:errorCode];
//    }
//}

-(void) onAdShowed:(EYNativeAdAdapter*)adapter
{
    if(self.delegate)
    {
        [self.delegate onAdShowed:self.adPlaceId type:ADTypeNative];
    }
    
//    if(self.reportEvent){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:adapter.adKey.keyId forKey:@"type"];
        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_SHOW]  parameters:dic];
//    }
}

- (void)onAdShowed:(EYNativeAdAdapter *)adapter extraData:(NSDictionary *)extraData {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onAdShowed:type:extraData:)])
    {
        [self.delegate onAdShowed:self.adPlaceId type:ADTypeNative extraData:extraData];
    }
}

-(void) onAdClicked:(EYNativeAdAdapter*)adapter
{
    if(self.delegate)
    {
        [self.delegate onAdClicked:self.adPlaceId type:ADTypeNative];
    }
    if(self.reportEvent){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:adapter.adKey.keyId forKey:@"type"];
        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_CLICKED]  parameters:dic];
    }
}

-(void) onAdImpression:(EYNativeAdAdapter*)adapter
{
    if(self.delegate)
    {
        [self.delegate onAdImpression:self.adPlaceId type:ADTypeNative];
    }
    EYAdKey *adKey = adapter.adKey;
    if(adKey){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:adKey.network forKey:@"network"];
        [dic setObject:adKey.key forKey:@"unit"];
        [dic setObject:ADTypeNative forKey:@"type"];
        [dic setObject:adKey.keyId forKey:@"keyId"];
        [EYEventUtils logEvent:EVENT_AD_IMPRESSION  parameters:dic];
    }
}

- (void)onAdClosed:(EYNativeAdAdapter *)adapter {
    if(self.delegate)
    {
        [self.delegate onAdClosed:self.adPlaceId type:ADTypeNative];
    }
}
@end
