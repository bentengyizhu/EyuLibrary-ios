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
    NSLog(@"加载旧版广告");
    if(self.adapterArray.count == 0) return;
    EYAdAdapter* adapter = self.adapterArray[self.currentAdpaterIndex];
    self.tryLoadAdCount = 1;
    [adapter loadAd];
    if (self.adGroup.isAutoLoad && self.adapterArray.count > 1) {
        self.currentAdpaterIndex = (self.currentAdpaterIndex+1)%self.adapterArray.count;
        EYAdAdapter* adp = self.adapterArray[self.currentAdpaterIndex];
        [adp loadAd];
    }
}

- (void)loadAdByValue: (bool)isCurrentIdnex {
    NSLog(@"加载新版价值广告");
    if (isCurrentIdnex == false && self.currentSuiteIndex > 0) {
        self.currentSuiteIndex -= 1;
        [self addAdatpers];
    } else {
        if (self.adapterArray.count == 0) {
            [self addAdatpers];
        }
    }
    for (EYAdAdapter* adapter in self.adapterArray) {
        adapter.tryLoadAdCount = 1;
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
}

-(void)addAdatpers {
    EYAdSuite *currentSuite = self.adGroup.suiteArray[self.currentSuiteIndex];
    NSArray<EYAdKey*>* keyList = currentSuite.keys;
    [self.adapterArray removeAllObjects];
    for(EYAdKey* adKey in keyList)
    {
        if(adKey){
            EYAdAdapter *adapter = [self createAdAdapterWithKey:adKey adGroup:self.adGroup];
            if(adapter){
                adapter.tryLoadAdCount = 1;
                [adapter loadAd];
                [self.adapterArray addObject:adapter];
            }
        }
    }
}

-(void)loadNextSuite {
    if (self.currentSuiteIndex >= self.adGroup.suiteArray.count-1) {
        NSLog(@"本组没有拉取到广告并且已经是价值最低的组");
        return;
    }
    NSLog(@"本组没有拉取到广告放低价值加载下一组广告");
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
    if (self.isNewJsonSetting) {
        EYAdSuite *suite = self.adGroup.suiteArray[self.currentSuiteIndex];
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
    NSLog(@"onAdLoadFailed adKey = %@, errorCode = %d", adKey.keyId, errorCode);
    if(self.reportEvent){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[[NSString alloc] initWithFormat:@"%d",errorCode] forKey:@"code"];
        [dic setObject:adKey.keyId forKey:@"type"];
        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOAD_FAILED]  parameters:dic];
    }
    if (self.isNewJsonSetting) {
        bool isAllLoaded = true;
        for (EYAdAdapter *adapter in self.adapterArray) {
            if (adapter.tryLoadAdCount == 0 && !adapter.isLoading) {
                isAllLoaded = false;
            }
        }
        if (isAllLoaded) {
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
