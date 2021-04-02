//
//  EYAdAdapter.h
//  EyuLibrary-ios-EyuLibrary
//
//  Created by eric on 2021/4/1.
//

#import <UIKit/UIKit.h>
#import "EYAdKey.h"
#import "EYAdGroup.h"
#include "EYAdConstants.h"

NS_ASSUME_NONNULL_BEGIN
@protocol IAdDelegate;
@interface EYAdAdapter : NSObject
@property(nonatomic,weak)id<IAdDelegate> delegate;
@property(nonatomic,strong)EYAdKey *adKey;
@property(nonatomic,assign)int tryLoadAdCount;
-(void) loadAd;
-(bool) isAdLoaded;
@end

@protocol IAdDelegate <NSObject>
@optional
-(void) onAdLoaded:(EYAdAdapter *)adapter;
-(void) onAdLoadFailed:(EYAdAdapter *)adapter withError:(int)errorCode;
-(void) onAdShowed:(EYAdAdapter *)adapter;
-(void) onAdClicked:(EYAdAdapter *)adapter;
-(void) onAdClosed:(EYAdAdapter *)adapter;
-(void) onAdRewarded:(EYAdAdapter *)adapter;
-(void) onAdImpression:(EYAdAdapter *)adapter;
-(void) onAdShowed:(EYAdAdapter *)adapter extraData:(NSDictionary *)extraData;
@end
NS_ASSUME_NONNULL_END
