//
//  NativeAdGroup.h
//  Freecell
//
//  Created by apple on 2018/7/13.
//

#import "EYNativeAdAdapter.h"
#import "EYBasicAdGroup.h"


@interface EYNativeAdGroup :EYBasicAdGroup

-(EYNativeAdGroup*) initWithGroup:(EYAdGroup*)group adConfig:(EYAdConfig*) adConfig;
-(EYNativeAdAdapter*) getAvailableAdapter;
@end
