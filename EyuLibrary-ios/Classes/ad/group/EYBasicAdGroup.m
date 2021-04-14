//
//  EYBasicAdGroup.m
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/18.
//

#import "EYBasicAdGroup.h"

@implementation EYBasicAdGroup
- (EYBasicAdGroup *)initWithGroup:(EYAdGroup *)adGroup adConfig:(EYAdConfig *)adConfig {
    self = [super init];
    if (self) {
        self.isNewJsonSetting = adConfig.isNewJsonSetting;
        self.adGroup = adGroup;
        self.adapterArray = [[NSMutableArray alloc] init];
        self.currentSuiteIndex = 0;
        self.currentAdValue = 0;
        self.currentAdpaterIndex = 0;
        self.tryLoadAdCount = 0;
        self.reportEvent = adConfig.reportEvent;
    }
    return self;
}

- (void)loadAd:(NSString *)adPlaceId {
    if (self.isNewJsonSetting == false) {
        [self loadAdBySequence];
        return;
    }
    [self loadAdByValue:false];
}

- (void)loadAdBySequence {
    NSLog(@"lwq,加载旧版广告 adtype = %@", self.adType);
    if(self.adapterArray.count == 0) return;
    EYAdAdapter* adapter = self.adapterArray[self.currentAdpaterIndex];
    [adapter loadAd];
    if (self.adGroup.isAutoLoad && self.adapterArray.count > 1) {
        self.currentAdpaterIndex = (self.currentAdpaterIndex+1)%self.adapterArray.count;
        EYAdAdapter* adp = self.adapterArray[self.currentAdpaterIndex];
        adp.tryLoadAdCount = 0;
        [adp loadAd];
    }
}

- (void)loadAdByValue: (bool)isCurrentIdnex {
    NSLog(@"lwq,加载新版价值广告 adtype = %@", self.adType);
    if (isCurrentIdnex == false && self.currentSuiteIndex > 0) {
        NSLog(@"lwq,加载上一组价值更高广告currentSuiteIndex = %d adtype = %@",self.currentSuiteIndex, self.adType);
        self.currentSuiteIndex -= 1;
        [self addAdatpers];
    } else {
        NSLog(@"lwq,已经是价值最高广告或者强制加载本组广告currentSuiteIndex = %d adtype = %@",self.currentSuiteIndex, self.adType);
        if (self.adapterArray.count == 0) {
            [self addAdatpers];
        }
    }
    for (EYAdAdapter* adapter in self.adapterArray) {
        adapter.tryLoadAdCount = 0;
        [adapter loadAd];
    }
}

-(EYAdAdapter*) createAdAdapterWithKey:(EYAdKey*)adKey adGroup:(EYAdGroup*)group {
    NSLog(@"子类实现");
    return nil;
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
    NSLog(@"lwq,初始化adapter数组: %@ adtype = %@", self.adapterArray, self.adType);
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
            EYAdAdapter *adapter = [self createAdAdapterWithKey:adKey adGroup:self.adGroup];
            if(adapter){
//                adapter.tryLoadAdCount = 0;
//                [adapter loadAd];
                [self.adapterArray addObject:adapter];
            }
        }
    }
    NSLog(@"lwq 添加adapter %@", self.adapterArray);
}

-(void)loadNextSuite {
    NSLog(@"lwq,加载下一组广告currentSuiteIndex = %d, suiteArray = %@ adtype = %@", self.currentSuiteIndex, self.adGroup.suiteArray, self.adType);
    if (self.currentSuiteIndex >= self.adGroup.suiteArray.count-1) {
        NSLog(@"lwq,本组没有拉取到广告并且已经是价值最低的组 adtype = %@", self.adType);
        return;
    }
    NSLog(@"lwq,本组没有拉取到广告放低价值加载下一组广告 adtype = %@", self.adType);
    self.currentSuiteIndex++;
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
}


- (void)onAdLoaded:(EYAdAdapter *)adapter {
//    if(self.curLoadingIndex>=0 && self.adapterArray[self.curLoadingIndex] == adapter)
//    {
//        self.curLoadingIndex = -1;
//    }
    NSLog(@"lwq, basic onAdLoaded %d",self.currentAdValue);
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
        [self.delegate onAdLoaded:self.adGroup.groupId type:self.adType];
    }
//    if(self.reportEvent){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:adapter.adKey.keyId forKey:@"type"];
        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOAD_SUCCESS]  parameters:dic];
//    }
}

- (void)onAdLoadFailed:(EYAdAdapter *)adapter withError:(int)errorCode {
    EYAdKey* adKey = adapter.adKey;
    NSLog(@"lwq,onAdLoadFailed adKey = %@, errorCode = %d", adKey.keyId, errorCode);
    EYAdSuite *suite = self.adGroup.suiteArray[self.currentSuiteIndex];
    NSLog(@"%d-----%d",suite.value,self.currentAdValue);
    if(self.reportEvent){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[[NSString alloc] initWithFormat:@"%d",errorCode] forKey:@"code"];
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
            for (EYAdAdapter *adapter in self.adapterArray) {
                NSLog(@"%d----%d", adapter.isAdLoaded, adapter.tryLoadAdCount);
            }
            [self loadNextSuite];
            [self loadAdByValue:true];
        }
    } else {
        [self tryAgain:adapter withError:errorCode];
    }
    if(self.delegate)
    {
        [self.delegate onAdLoadFailed:self.adGroup.groupId key:adKey.keyId code:errorCode];
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
