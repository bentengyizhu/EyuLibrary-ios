//
//  EYuAd.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/6/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EYuAd : NSObject
@property(nonatomic,copy) NSString* unitId;
@property(nonatomic,copy) NSString* unitName;
@property(nonatomic,copy) NSString* placeId;
@property(nonatomic,copy) NSString* adFormat;
@property(nonatomic,copy) NSString* adRevenue;
@property(nonatomic,copy) NSString* mediator;
@property(nonatomic,copy) NSString* networkName;
@property(nonatomic,strong) NSError* error;
@end

NS_ASSUME_NONNULL_END
