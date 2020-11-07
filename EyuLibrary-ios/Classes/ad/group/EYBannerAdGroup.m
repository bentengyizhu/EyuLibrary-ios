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
#import "EYEventUtils.h"
#import "EYAdManager.h"

@interface EYBannerAdGroup()<IBannerAdDelegate>

@property(nonatomic,strong)NSDictionary<NSString*, Class> *adapterClassDict;
@property(nonatomic,strong)NSMutableArray<EYBannerAdAdapter*> *adapterArray;
@property(nonatomic,copy)NSString *adPlaceId;
@property(nonatomic,assign)int  maxTryLoadAd;
@property(nonatomic,assign)int tryLoadAdCounter;
@property(nonatomic,assign)int curLoadingIndex;
@property(nonatomic,assign)bool reportEvent;

@end

@implementation EYBannerAdGroup
@synthesize adGroup = _adGroup;
@synthesize adapterArray = _adapterArray;
@synthesize adapterClassDict = _adapterClassDict;
@synthesize maxTryLoadAd = _maxTryLoadAd;
@synthesize curLoadingIndex = _curLoadingIndex;
@synthesize tryLoadAdCounter = _tryLoadAdCounter;
@synthesize reportEvent = _reportEvent;

- (EYBannerAdGroup *)initWithGroup:(EYAdGroup *)adGroup adConfig:(EYAdConfig *)adConfig {
    self = [super init];
    if (self) {
        self.adapterClassDict = [[NSDictionary alloc] initWithObjectsAndKeys:
#ifdef FB_ADS_ENABLED
            NSClassFromString(@"EYFbBannerAdapter"), ADNetworkFacebook,
#endif
                                 
#ifdef ADMOB_ADS_ENABLED
            NSClassFromString(@"EYAdmobBannerAdapter"), ADNetworkAdmob,
#endif
        nil];
        self.adGroup = adGroup;
        self.adapterArray = [[NSMutableArray alloc] init];

        self.curLoadingIndex = -1;
        self.tryLoadAdCounter = 0;
        self.reportEvent = adConfig.reportEvent;
        
        NSMutableArray<EYAdKey*>* keyList = adGroup.keyArray;
        for(EYAdKey* adKey in keyList)
        {
            if(adKey){
                EYBannerAdAdapter *adapter = [self createAdAdapterWithKey:adKey adGroup:adGroup];
                if(adapter){
                    [self.adapterArray addObject:adapter];
                }
            }
        }
        self.maxTryLoadAd = ((int)self.adapterArray.count) * 2;
    }
    return self;
}

-(EYBannerAdAdapter*) createAdAdapterWithKey:(EYAdKey*)adKey adGroup:(EYAdGroup*)group
{
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

-(bool) isCacheAvailable
{
    for(EYBannerAdAdapter* adapter in self.adapterArray)
    {
        if([adapter isAdLoaded])
        {
            return true;
        }
    }
    return false;
}
@end
