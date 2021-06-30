//
//  EYSplashAdGroup.m
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/5.
//

#import "EYSplashAdGroup.h"
#import "EYSplashAdAdapter.h"
#import "EYEventUtils.h"
#import "SVProgressHUD.h"
#import <FFToast/FFToast.h>
#import "EyAdManager.h"

@interface EYSplashAdGroup()
//@property(nonatomic,strong)NSMutableArray<EYSplashAdAdapter*> *adapterArray;
@property(nonatomic,strong)NSDictionary<NSString*, Class> *adapterClassDict;
//@property(nonatomic,assign)int  maxTryLoadAd;
//@property(nonatomic,assign)int tryLoadAdCounter;
//@property(nonatomic,assign)int curLoadingIndex;
@property(nonatomic,assign)bool isLoadingDialogShowed;
@property(nonatomic,strong)NSTimer *loadingTimer;
@end

@implementation EYSplashAdGroup
//@synthesize adGroup = _adGroup;
//@synthesize adapterArray = _adapterArray;
@synthesize adapterClassDict = _adapterClassDict;
//@synthesize maxTryLoadAd = _maxTryLoadAd;
//@synthesize curLoadingIndex = _curLoadingIndex;
//@synthesize tryLoadAdCounter = _tryLoadAdCounter;
@synthesize isLoadingDialogShowed = _isLoadingDialogShowed;
@synthesize loadingTimer = _loadingTimer;
//@synthesize delegate = _delegate;
//@synthesize reportEvent = _reportEvent;

- (EYSplashAdGroup *)initInAdvanceWithGroup:(EYAdGroup *)adGroup adConfig:(EYAdConfig *)adConfig {
    if (adConfig.isNewJsonSetting == false) {
        return [self initWithGroup:adGroup adConfig:adConfig];
    }
    self.adType = ADTypeSplash;
    self = [super initInAdvanceWithGroup:adGroup adConfig:adConfig];
    return self;
}

- (EYSplashAdGroup *)initWithGroup:(EYAdGroup *)group adConfig:(EYAdConfig *)adConfig {
    self = [super initWithGroup:group adConfig:adConfig];
    if(self)
    {
        self.adapterClassDict = [[NSDictionary alloc] initWithObjectsAndKeys:
#ifdef ABUADSDK_ENABLED
            NSClassFromString(@"EYABUSplashAdAdapter"), ADNetworkABU,
#endif
        nil];
        
        self.adValueKey = [NSString stringWithFormat:@"currentSplashValue%d", self.priority+1];
        self.adType = ADTypeSplash;
        [self initAdatperArray];
        self.maxTryLoadAd = ((int)self.adapterArray.count) * 2;
    }
    return self;
}

-(EYSplashAdAdapter*) createAdAdapterWithKey:(EYAdKey*)adKey adGroup:(EYAdGroup*)group
{
    EYSplashAdAdapter* adapter = NULL;
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

-(void) cacheAllAd
{
    for(EYSplashAdAdapter* adapter in self.adapterArray)
    {
        if(![adapter isAdLoaded])
        {
            [adapter loadAd];
        }
    }
}

- (bool)showAd:(NSString *)placeId withController:(UIViewController *)controller {
    NSLog(@"showAd adPlaceId = %@, self = %@", placeId, self);
    if (self.groupArray != nil) {
        for (EYSplashAdGroup *group in self.groupArray) {
            if ([group showAd:placeId withController:controller]) {
                return true;
            }
        }
        return false;
    }
    self.adPlaceId = placeId;
    EYSplashAdAdapter* loadedAdapter = NULL;
    for(EYSplashAdAdapter* adapter in self.adapterArray)
    {
        if([adapter isAdLoaded])
        {
            loadedAdapter = adapter;
            break;
        }
    }
    if(loadedAdapter != nil)
    {
        [loadedAdapter showAdWithController:controller];
        return true;
    }else{
        return false;
    }
}

//-(void) loadAd:(NSString*)adPlaceId
//{
//    NSLog(@"loadAd adPlaceId = %@, self = %@", adPlaceId, self);
//    self.adPlaceId = adPlaceId;
//    if(self.adapterArray.count == 0) return;
//    self.curLoadingIndex = 0;
//    self.tryLoadAdCounter = 1;
//
//    EYSplashAdAdapter* adapter = self.adapterArray[0];
//    [adapter loadAd];
//
//    if(self.adapterArray.count > 1)
//    {
//        EYSplashAdAdapter* adapter = self.adapterArray[1];
//        [adapter loadAd];
//        self.curLoadingIndex = 1;
//        self.tryLoadAdCounter = 2;
//    }
//
//    if(self.reportEvent){
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setObject:adapter.adKey.keyId forKey:@"type"];
//        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOADING]  parameters:dic];
//    }
//}

//-(void) onAdLoaded:(EYSplashAdAdapter *)adapter
//{
//    NSLog(@"onAdLoaded adPlaceId = %@, self = %@", self.adPlaceId, self);
//    if(self.curLoadingIndex>=0 && self.adapterArray[self.curLoadingIndex] == adapter)
//    {
//        self.curLoadingIndex = -1;
//    }
//    if(self.delegate)
//    {
//        [self.delegate onAdLoaded:self.adPlaceId type:ADTypeSplash];
//    }
//
////    if(self.reportEvent){
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setObject:adapter.adKey.keyId forKey:@"type"];
//        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOAD_SUCCESS]  parameters:dic];
////    }
//}

//-(void) onAdLoadFailed:(EYSplashAdAdapter*)adapter withError:(int)errorCode
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
//            EYSplashAdAdapter* adapter = self.adapterArray[self.curLoadingIndex];
//            [adapter loadAd];
//            if(self.reportEvent){
//                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//                [dic setObject:adapter.adKey.keyId forKey:@"type"];
//                [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOADING]  parameters:dic];
//            }
//        }
//    }
//
//    if(self.delegate)
//    {
//        [self.delegate onAdLoadFailed:self.adPlaceId key:adKey.keyId code:errorCode];
//    }
//}

- (void)onAdRevenue:(EYAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd {
    if(self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(onAdRevenue:)]) {
            [self.delegate onAdRevenue:eyuAd];
        }
    }
}

-(void) onAdClicked:(EYSplashAdAdapter*)adapter eyuAd:(EYuAd *)eyuAd
{
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
-(void) onAdClosed:(EYSplashAdAdapter*)adapter eyuAd:(EYuAd *)eyuAd
{
    if(self.delegate)
    {
        [self.delegate onAdClosed:eyuAd];
    }
    if (self.adGroup.isAutoLoad && !self.isCacheAvailable) {
        [self loadAd:self.adPlaceId];
    }
}

-(void) onAdImpression:(EYSplashAdAdapter*)adapter eyuAd:(EYuAd *)eyuAd
{
    if(self.delegate)
    {
        [self.delegate onAdImpression:eyuAd];
    }
    EYAdKey *adKey = adapter.adKey;
    if(adKey){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:adKey.network forKey:@"network"];
        [dic setObject:adKey.key forKey:@"unit"];
        [dic setObject:ADTypeSplash forKey:@"type"];
        [dic setObject:adKey.keyId forKey:@"keyId"];
        [EYEventUtils logEvent:EVENT_AD_IMPRESSION  parameters:dic];
    }
}

- (void)onAdShowed:(EYAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd {
    if(self.delegate)
    {
        [self.delegate onAdShowed:eyuAd];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:adapter.adKey.keyId forKey:@"type"];
    [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_SHOW]  parameters:dic];
}
@end
