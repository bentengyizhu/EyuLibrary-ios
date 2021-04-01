//
//  EYAdSuite.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/4/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EYAdSuite : NSObject
@property(nonatomic,copy)NSString *suiteId;
@property(nonatomic,assign)int value;
@property(nonatomic,strong)NSMutableArray *keys;
@end

NS_ASSUME_NONNULL_END
