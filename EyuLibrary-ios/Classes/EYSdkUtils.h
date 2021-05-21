//
//  EYSdkUtils.h
//  ballzcpp-mobile
//
//  Created by qianyuan on 2017/12/19.
//

#ifndef EYSdkUtils_h
#define EYSdkUtils_h

#import <Foundation/Foundation.h>
#import "EYAdConstants.h"

@interface EYSdkUtils : NSObject {
    
}

#ifdef FACEBOOK_ENABLED
/**
 *需要再info.plist里设置FacebookAppID
 **/
+(void) initFacebookSdkWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions;
    
+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;
+(bool) isFBInited;

#endif

#ifdef FIREBASE_ENABLED
+(void) initFirebaseSdk;
#endif

#ifdef AF_ENABLED
+(void) initAppFlyer:(NSString*) devKey appId:(NSString*)appId;
+ (void)appFlyerStart;
+ (void)appFlyerHandleNotification:(NSDictionary *)userInfo;
+ (BOOL)appFlyerContinueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler;
+ (void)appFlyerhandleOpenURL:(NSURL *)url options:(NSDictionary *) options;
#endif

#ifdef UM_ENABLED
+(void) initUMMobSdk:(NSString*) appKey channel:(NSString*) channel;
+(bool) isUMInited;
#endif

#ifdef GDT_ACTION_ENABLED
+(void) initGDTActionSdk:(NSString*) setid secretkey:(NSString*)secretkey;
+(void) doGDTSDKActionStartApp;
+(bool) isGDTInited;
#endif

#ifdef TRACKING_ENABLED
+ (void)initTrackingWithAppKey:(NSString *)appKey;
+ (void)initTrackingWithAppKey:(NSString *)appKey withChannelId:(NSString *)channelId;
#endif

#ifdef ANYTHINK_ENABLED
+ (void)initAnyThinkWithAppID:(NSString *)appId AppKey:(NSString *)appKey;
#endif

#ifdef THINKING_ENABLED
+ (void)initThinkWithAppID:(NSString *)appId Url:(NSString *)url;
+ (void)initThinkWithAppID:(NSString *)appId isInCN:(BOOL)isInCN;
#endif

//#ifdef MTG_ADS_ENABLED
//+ (void)initMTGWithAppID:(NSString *)appId AppKey:(NSString *)appKey;
//#endif

+ (NSData *)readFileWithName:(NSString *)name;
+ (NSDictionary *)readJsonFileWithName:(NSString *)name;

@end


#endif /* EYSdkUtils_h */



