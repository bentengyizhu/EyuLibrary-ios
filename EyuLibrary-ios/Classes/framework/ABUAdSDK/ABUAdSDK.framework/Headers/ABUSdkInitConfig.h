//
//  ABUSdkInitConfig.h
//  ABUAdSDK
//
//  Created by wangchao on 2020/2/24.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABUSdkInitConfig : NSObject

@property (nonatomic, copy) NSString *appID;
@property (nonatomic, copy) NSString *appKey;

@property (nonatomic, assign) BOOL testUnityAd; // 设置unityAdSDK测试模式；无配置默认为NO

@end

NS_ASSUME_NONNULL_END
