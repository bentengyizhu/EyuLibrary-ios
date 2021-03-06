//
//  ABUAdSDKDefines.h
//  BUAdSDK
//
//  Copyright © 2017年 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>


FOUNDATION_EXPORT void abu_safe_dispatch_sync_main_queue(void (^block)(void));
FOUNDATION_EXPORT void abu_safe_dispatch_async_main_queue(void (^block)(void));


typedef NS_ENUM (NSInteger, ABUOfflineType) {
    ABUOfflineTypeNone,  // Do not set offline
    ABUOfflineTypeProtocol, // Offline dependence NSURLProtcol
    ABUOfflineTypeWebview, // Offline dependence WKWebview
};

typedef NS_ENUM (NSInteger, ABUAdSDKLogLevel) {
    ABUAdSDKLogLevelNone,
    ABUAdSDKLogLevelError,
    ABUAdSDKLogLevelDebug
};

typedef NS_ENUM (NSInteger, ABUAdSDKLogLanguage) {
    ABUAdSDKLogLanguageCH,
    ABUAdSDKLogLanguageEN
};

typedef NS_ENUM (NSInteger, ABURitSceneType) {
    ABURitSceneType_custom                  = 0,//custom
    ABURitSceneType_home_open_bonus         = 1,//Login/open rewards (login, sign-in, offline rewards doubling, etc.)
    ABURitSceneType_home_svip_bonus         = 2,//Special privileges (VIP privileges, daily rewards, etc.)
    ABURitSceneType_home_get_props          = 3,//Watch rewarded video ad to gain skin, props, levels, skills, etc
    ABURitSceneType_home_try_props          = 4,//Watch rewarded video ad to try out skins, props, levels, skills, etc
    ABURitSceneType_home_get_bonus          = 5,//Watch rewarded video ad to get gold COINS, diamonds, etc
    ABURitSceneType_home_gift_bonus         = 6,//Sweepstakes, turntables, gift boxes, etc
    ABURitSceneType_game_start_bonus        = 7,//Before the opening to obtain physical strength, opening to strengthen, opening buff, task props
    ABURitSceneType_game_reduce_waiting     = 8,//Reduce wait and cooldown on skill CD, building CD, quest CD, etc
    ABURitSceneType_game_more_opportunities = 9,//More chances (resurrect death, extra game time, decrypt tips, etc.)
    ABURitSceneType_game_finish_rewards     = 10,//Settlement multiple times/extra bonus (completion of chapter, victory over boss, first place, etc.)
    ABURitSceneType_game_gift_bonus         = 11//The game dropped treasure box, treasures and so on
};

// 三方Adn枚举
typedef NS_ENUM (NSInteger, ABUAdnType) {
    ABUAdnNoPermission = -3,    // 无权限访问
    ABUAdnNoData = -2,  // 暂时无真实数据，未获取到最佳广告，一般在未展示之前提前调用
    ABUAdnNone = 0,     // 未知adn
    ABUAdnPangle = 1,   // 穿山甲adn
    ABUAdnAdmob = 2,    // 谷歌Admob
    ABUAdnGDT = 3,      // 腾讯广点通adn
    ABUAdnBaidu = 4,    // 百度adn
    ABUAdnUnity = 5,    // unity adn
    ABUAdnSigmob = 6,   // Sigmob adn
    ABUAdnKs = 7,       // 快手Adn
    ABUAdnMTG = 8,      // Mintegral adn
};

@protocol ABUToDictionary <NSObject>
- (NSDictionary *)dictionaryValue;
@end

#if defined(__has_attribute)
#if __has_attribute(deprecated)
#define ABU_DEPRECATED_MSG_ATTRIBUTE(s) __attribute__((deprecated(s)))
#define ABU_DEPRECATED_ATTRIBUTE __attribute__((deprecated))
#else
#define ABU_DEPRECATED_MSG_ATTRIBUTE(s)
#define ABU_DEPRECATED_ATTRIBUTE
#endif
#else
#define ABU_DEPRECATED_MSG_ATTRIBUTE(s)
#define ABU_DEPRECATED_ATTRIBUTE
#endif
