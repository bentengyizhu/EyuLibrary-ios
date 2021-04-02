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
        self.reportEvent = adConfig.reportEvent;
    }
    return self;
}

- (void)loadAd:(NSString *)adPlaceId {
    if (self.isNewJsonSetting == false) {
        [self loadAdBySequence];
        return;
    }
    [self loadAdByValue];
}

- (void)loadAdBySequence {
    if(self.adapterArray.count == 0) return;
    EYAdAdapter* adapter = self.adapterArray[0];
    [adapter loadAd];
    if (self.adapterArray.count > 1 && self.adGroup.isAutoLoad) {
        [self.adapterArray[1] loadAd];
    }
}

- (void)loadAdByValue {
    for (EYAdAdapter* adapter in self.adapterArray) {
        [adapter loadAd];
    }
}

-(EYAdAdapter*) createAdAdapterWithKey:(EYAdKey*)adKey adGroup:(EYAdGroup*)group {
    NSLog(@"子类实现");
    return nil;
}

-(void)initAdatperArray {
    NSMutableArray<EYAdKey*>* keyList = [[NSMutableArray alloc]init];
    if (self.isNewJsonSetting) {
        NSInteger value = [[NSUserDefaults standardUserDefaults]integerForKey:self.adValueKey];
        if (value != 0) {
            for (int i = 0; i < self.adGroup.suiteArray.count; i++) {
                EYAdSuite *suite = self.adGroup.suiteArray[i];
                if (value >= suite.value) {
                    self.currentSuiteIndex = suite.value;
                    break;
                }
            }
        }
        EYAdSuite *currentSuite = self.adGroup.suiteArray[self.currentSuiteIndex];
        keyList = currentSuite.keys;
    } else {
        for (EYAdSuite *suite in self.adGroup.suiteArray) {
            [keyList addObject:suite.keys.firstObject];
        }
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


- (void)onAdLoaded:(EYAdAdapter *)adapter {
//    if(self.curLoadingIndex>=0 && self.adapterArray[self.curLoadingIndex] == adapter)
//    {
//        self.curLoadingIndex = -1;
//    }
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
        
    } else {
        [self tryAgain:adapter withError:errorCode];
    }
    if(self.delegate)
    {
        [self.delegate onAdLoadFailed:self.adGroup.groupId key:adKey.keyId code:errorCode];
    }
}

- (void)tryAgain:(EYAdAdapter *)adapter withError:(int)errorCode {
    if(adapter.tryLoadAdCount < self.maxTryLoadAd) {
        adapter.tryLoadAdCount++;
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
            [adapter loadAd];
         });
    }
}
@end
