//
//  EYBasicAdGroup.m
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/18.
//

#import "EYBasicAdGroup.h"
#import "EYBannerAdGroup.h"
#import "EYNativeAdGroup.h"
#import "EYSplashAdGroup.h"
#import "EYRewardAdGroup.h"
#import "EYInterstitialAdGroup.h"

@interface EYBasicAdGroup()
@property(nonatomic,assign)int currentLoadCount;
@end

@implementation EYBasicAdGroup

- (EYBasicAdGroup *)initInAdvanceWithGroup:(EYAdGroup *)adGroup adConfig:(EYAdConfig *)adConfig {
    self = [super init];
    if (self) {
        self.groupArray = [NSMutableArray array];
        self.priority = -1;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (EYAdSuite *suite in adGroup.suiteArray) {
            NSMutableArray *arr = dic[@(suite.priority)];
            if (arr == nil) {
                arr = [[NSMutableArray alloc]init];
                [arr addObject:suite];
                dic[@(suite.priority)] = arr;
            } else {
                [arr addObject:suite];
            }
        }
        NSArray *keyArr = [dic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSNumber   * _Nonnull obj1, NSNumber   * _Nonnull obj2) {
            if (obj1.intValue < obj2.intValue)  {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }];
        for (NSNumber *key in keyArr) {
            NSMutableArray *suiteArray = dic[key];
            EYAdGroup *group = [adGroup copy];
            group.suiteArray = suiteArray;
            EYBasicAdGroup *g;
            if ([self.adType isEqualToString: ADTypeBanner]) {
                g = [[EYBannerAdGroup alloc] initWithGroup:group adConfig:adConfig];
            } else if ([self.adType isEqualToString: ADTypeReward]) {
                g = [[EYRewardAdGroup alloc] initWithGroup:group adConfig:adConfig];
            }else if ([self.adType isEqualToString: ADTypeNative]) {
                g = [[EYNativeAdGroup alloc] initWithGroup:group adConfig:adConfig];
            }else if ([self.adType isEqualToString: ADTypeInterstitial]) {
                g = [[EYInterstitialAdGroup alloc] initWithGroup:group adConfig:adConfig];
            } else {
                g = [[EYSplashAdGroup alloc] initWithGroup:group adConfig:adConfig];
            }
            g.priority = key.intValue;
            [self.groupArray addObject:g];
        }
    }
    return self;
}

- (EYBasicAdGroup *)initWithGroup:(EYAdGroup *)adGroup adConfig:(EYAdConfig *)adConfig {
    self = [super init];
    if (self) {
        self.priority = -1;
        self.isNewJsonSetting = adConfig.isNewJsonSetting;
        self.adGroup = adGroup;
        self.adapterArray = [[NSMutableArray alloc] init];
        self.currentSuiteIndex = 0;
        self.currentAdValue = 0;
        self.currentAdpaterIndex = -1;
        self.tryLoadAdCount = 0;
        self.currentLoadCount = 2;
        self.reportEvent = adConfig.reportEvent;
    }
    return self;
}

- (void)setDelegate:(id<EYAdDelegate>)delegate {
    _delegate = delegate;
    if (self.groupArray) {
        for (EYBasicAdGroup *group in self.groupArray) {
            group.delegate = delegate;
        }
    }
}

- (void)loadAd:(NSString *)adPlaceId {
    if (self.groupArray != nil) {
        for (EYBasicAdGroup * group in self.groupArray) {
            [group loadAd:adPlaceId];
        }
        return;
    }
    self.adPlaceId = adPlaceId;
    if (self.isNewJsonSetting == false) {
        [self loadAdBySequence];
        return;
    }
    if (self.isCacheAvailable) {
        EYuAd *ad = [[EYuAd alloc]init];
        ad.adFormat = self.adType;
        ad.placeId = adPlaceId;
        [self.delegate onAdLoaded:ad];
        return;
    }
    if (self.adGroup.isAutoLoad) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    [self loadAdByValue:false];
}

- (void)loadAdBySequence {
    NSLog(@"加载旧版广告 adtype = %@", self.adType);
    if(self.adapterArray.count == 0) return;
    self.currentAdpaterIndex = (self.currentAdpaterIndex+1)%self.adapterArray.count;
    EYAdAdapter* adapter = self.adapterArray[self.currentAdpaterIndex];
    adapter.adKey.placementid = self.adPlaceId;
    [adapter loadAd];
    if (self.adGroup.isAutoLoad && self.adapterArray.count > 1) {
        self.currentAdpaterIndex = (self.currentAdpaterIndex+1)%self.adapterArray.count;
        EYAdAdapter* adp = self.adapterArray[self.currentAdpaterIndex];
        adp.adKey.placementid = self.adPlaceId;
        adp.tryLoadAdCount = 0;
        [adp loadAd];
    }
}

- (void)loadAdByValue: (bool)isCurrentIdnex {
    NSLog(@"加载新版价值广告 adtype = %@", self.adType);
    if (isCurrentIdnex == false && self.currentSuiteIndex > 0) {
        NSLog(@"加载上一组价值更高广告currentSuiteIndex = %d adtype = %@",self.currentSuiteIndex, self.adType);
        self.currentSuiteIndex -= 1;
        [self addAdatpers];
    } else {
        NSLog(@"已经是价值最高广告或者强制加载本组广告currentSuiteIndex = %d adtype = %@",self.currentSuiteIndex, self.adType);
        if (self.adapterArray.count == 0) {
            [self addAdatpers];
        }
    }
    for (EYAdAdapter* adapter in self.adapterArray) {
        adapter.tryLoadAdCount = 0;
        [adapter loadAd];
    }
}

-(bool) isCacheAvailable
{
    if (self.groupArray) {
        for (EYBasicAdGroup * group in self.groupArray) {
            if (group.isCacheAvailable) {
                return true;
            }
        }
        return false;
    }
    for(EYAdAdapter* adapter in self.adapterArray)
    {
        if([adapter isAdLoaded])
        {
            return true;
        }
    }
    return false;
}

-(bool) isHighPriorityCacheAvailable
{
    if (self.groupArray) {
        return [[self.groupArray firstObject] isCacheAvailable];
    }
    return [self isCacheAvailable];
}

-(EYAdAdapter*) createAdAdapterWithKey:(EYAdKey*)adKey adGroup:(EYAdGroup*)group {
    NSLog(@"子类实现");
    return nil;
}

- (bool)showAd:(NSString *)adPlaceId controller:(UIViewController *)controller {
    NSLog(@"子类实现");
    return false;
}

-(void)initAdatperArray {
    if (self.isNewJsonSetting) {
        NSInteger value = [[NSUserDefaults standardUserDefaults]integerForKey:self.adValueKey];
        self.currentAdValue = (int)value;
        if (value != 0) {
            for (int i = 0; i < self.adGroup.suiteArray.count; i++) {
                EYAdSuite *suite = self.adGroup.suiteArray[i];
                if (value >= suite.value) {
                    self.currentSuiteIndex = i;
                    break;
                }
            }
        }
    } else {
        NSMutableArray<EYAdKey*>* keyList = [[NSMutableArray alloc]init];
        for (EYAdSuite *suite in self.adGroup.suiteArray) {
            [keyList addObject:suite.keys.firstObject];
        }
        [self.adapterArray removeAllObjects];
        for(EYAdKey* adKey in keyList)
        {
            if(adKey){
                EYAdAdapter *adapter = [self createAdAdapterWithKey:adKey adGroup:self.adGroup];
                if(adapter){
                    [self.adapterArray addObject:adapter];
                }
            }
        }
    }
    NSLog(@"初始化adapter数组: %@ adtype = %@", self.adapterArray, self.adType);
}

-(void)addAdatpers {
    if (self.adGroup.suiteArray.count <= self.currentSuiteIndex) {
        return;
    }
    EYAdSuite *currentSuite = self.adGroup.suiteArray[self.currentSuiteIndex];
    NSArray<EYAdKey*>* keyList = currentSuite.keys;
    [self.adapterArray removeAllObjects];
    for(EYAdKey* adKey in keyList)
    {
        if(adKey){
            adKey.placementid = self.adPlaceId;
            EYAdAdapter *adapter = [self createAdAdapterWithKey:adKey adGroup:self.adGroup];
            if(adapter){
                [self.adapterArray addObject:adapter];
            }
        }
    }
    NSLog(@"添加adapter %@", self.adapterArray);
}

-(bool)loadNextSuite {
    NSLog(@"加载下一组广告currentSuiteIndex = %d, suiteArray = %@ adtype = %@", self.currentSuiteIndex, self.adGroup.suiteArray, self.adType);
    if (self.currentSuiteIndex >= self.adGroup.suiteArray.count-1) {
        NSLog(@"本组没有拉取到广告并且已经是价值最低的组 adtype = %@", self.adType);
        self.currentLoadCount -= 1;
        if (self.currentLoadCount > 0) {
            self.currentSuiteIndex = 0;
        } else {
            self.currentLoadCount = 2;
            if (self.adGroup.isAutoLoad) {
                [self performSelector:@selector(reloadAdGroup) withObject:NULL afterDelay:2];
            }
            return false;
        }
    } else {
        self.currentSuiteIndex++;
    }
    NSLog(@"本组没有拉取到广告放低价值加载下一组广告 adtype = %@", self.adType);
    EYAdSuite *currentSuite = self.adGroup.suiteArray[self.currentSuiteIndex];
    NSMutableArray<EYAdKey*> *keyList = currentSuite.keys;
    [self.adapterArray removeAllObjects];
    for(EYAdKey* adKey in keyList)
    {
        if(adKey){
            EYAdAdapter *adapter = [self createAdAdapterWithKey:adKey adGroup:self.adGroup];
            if(adapter){
                [self.adapterArray addObject:adapter];
            }
        }
    }
    return true;
}

-(void)reloadAdGroup {
    if ([self loadNextSuite]) {
        [self loadAdByValue:true];
    }
}

- (void)onAdLoaded:(EYAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd{
//    if(self.curLoadingIndex>=0 && self.adapterArray[self.curLoadingIndex] == adapter)
//    {
//        self.curLoadingIndex = -1;
//    }
    NSLog(@" basic onAdLoaded %d",self.currentAdValue);
    self.currentLoadCount = 2;
    adapter.tryLoadAdCount ++;
    if (self.isNewJsonSetting) {
        EYAdSuite *suite = self.adGroup.suiteArray[self.currentSuiteIndex];
        NSLog(@"%d-----%d",suite.value,self.currentAdValue);
        if (self.currentAdValue != suite.value) {
            self.currentAdValue = suite.value;
            [[NSUserDefaults standardUserDefaults]setInteger:suite.value forKey:self.adValueKey];
        }
    }
    
    if(self.delegate)
    {
        [self.delegate onAdLoaded:eyuAd];
    }
//    if(self.reportEvent){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:adapter.adKey.keyId forKey:@"type"];
        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOAD_SUCCESS]  parameters:dic];
//    }
}

- (void)onAdLoadFailed:(EYAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd {
    EYAdKey* adKey = adapter.adKey;
    NSLog(@"onAdLoadFailed adKey = %@, errorCode = %ld", adKey.keyId, eyuAd.error.code);
    EYAdSuite *suite = self.adGroup.suiteArray[self.currentSuiteIndex];
    NSLog(@"%d-----%d",suite.value,self.currentAdValue);
    if(self.reportEvent){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[[NSString alloc] initWithFormat:@"%ld",eyuAd.error.code] forKey:@"code"];
        [dic setObject:adKey.keyId forKey:@"type"];
        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOAD_FAILED]  parameters:dic];
    }
    adapter.tryLoadAdCount ++;
    if (self.isNewJsonSetting) {
        bool isAllLoaded = true;
        for (EYAdAdapter *adapter in self.adapterArray) {
            NSLog(@"%d", adapter.tryLoadAdCount);
            if ((adapter.tryLoadAdCount == 0 && adapter.isLoading) || [adapter isAdLoaded]) {
                isAllLoaded = false;
            }
        }
        if (isAllLoaded) {
            if ([self loadNextSuite]) {
                [self loadAdByValue:true];
            }
        }
    } else {
        [self tryAgain:adapter withError:(int)eyuAd.error.code];
    }
    if(self.delegate)
    {
        [self.delegate onAdLoadFailed:eyuAd];
    }
}

- (void)tryAgain:(EYAdAdapter *)adapter withError:(int)errorCode {
    if(self.tryLoadAdCount < self.maxTryLoadAd) {
        self.tryLoadAdCount++;
        if(self.reportEvent){
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:adapter.adKey.keyId forKey:@"type"];
            [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOADING]  parameters:dic];
        }
        int second = 0;
        if ([self.adType isEqualToString:ADTypeBanner]) {
            second = 10;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.currentAdpaterIndex = (self.currentAdpaterIndex+1)%self.adapterArray.count;
            EYAdAdapter *adp = self.adapterArray[self.currentAdpaterIndex];
            [adp loadAd];
         });
    }
}
@end
