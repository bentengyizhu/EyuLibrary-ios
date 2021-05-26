//
//  EYBasicAdGroup.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/18.
//

#import <UIKit/UIKit.h>
#import "EYAdAdapter.h"
#import "EYAdDelegate.h"
#import "EYAdConstants.h"
#import "EYAdConfig.h"
#import "EYAdGroup.h"
#import "EYEventUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface EYBasicAdGroup : NSObject <IAdDelegate>
@property(nonatomic,weak) id<EYAdDelegate> delegate;
@property(nonatomic,strong)EYAdGroup *adGroup;
@property(nonatomic,strong)NSMutableArray<EYAdAdapter *> *adapterArray;
@property(nonatomic,copy)NSString *adType;
@property(nonatomic,copy)NSString *adValueKey;
@property(nonatomic,assign)bool isNewJsonSetting;
@property(nonatomic,assign)int currentSuiteIndex;
@property(nonatomic,assign)int currentAdpaterIndex;
@property(nonatomic,assign)int currentAdValue;
@property(nonatomic,assign)bool reportEvent;
@property(nonatomic,assign)int  maxTryLoadAd;
@property(nonatomic,assign)int tryLoadAdCount;
@property(nonatomic,copy)NSString *adPlaceId;
@property(nonatomic,strong)NSMutableArray *groupArray;
@property(nonatomic,assign)int priority;

- (EYBasicAdGroup *)initInAdvanceWithGroup:(EYAdGroup *)adGroup adConfig:(EYAdConfig *)adConfig;
-(EYBasicAdGroup *)initWithGroup:(EYAdGroup *)adGroup adConfig:(EYAdConfig *)adConfig;
-(void)loadAd:(NSString*)adPlaceId;
-(EYAdAdapter*) createAdAdapterWithKey:(EYAdKey*)adKey adGroup:(EYAdGroup*)group;
-(void)initAdatperArray;
-(bool)loadNextSuite;
-(bool) isCacheAvailable;
-(bool) isHighPriorityCacheAvailable;
@end

NS_ASSUME_NONNULL_END
