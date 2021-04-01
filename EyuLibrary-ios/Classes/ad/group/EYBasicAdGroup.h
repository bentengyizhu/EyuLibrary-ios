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

NS_ASSUME_NONNULL_BEGIN

@interface EYBasicAdGroup : NSObject
@property(nonatomic,weak) id<EYAdDelegate> delegate;
@property(nonatomic,strong)EYAdGroup *adGroup;
@property(nonatomic,strong)NSMutableArray<EYAdAdapter *> *adapterArray;
@property(nonatomic,copy)NSString *adType;
@property(nonatomic,assign)bool isNewJsonSetting;
@property(nonatomic,assign)int currentSuiteIndex;

- (EYBasicAdGroup *)initWithGroup:(EYAdGroup *)adGroup adConfig:(EYAdConfig *)adConfig;
-(void) loadAd:(NSString*)adPlaceId;
@end

NS_ASSUME_NONNULL_END
