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
    }
    return self;
}

- (void)loadAd:(NSString *)adPlaceId {
    
}
@end
