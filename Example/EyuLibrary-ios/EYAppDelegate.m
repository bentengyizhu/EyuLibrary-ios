//
//  EYAppDelegate.m
//  EyuLibrary-ios
//
//  Created by WeiqiangLuo on 09/28/2018.
//  Copyright (c) 2018 WeiqiangLuo. All rights reserved.
//

#import "EYAppDelegate.h"
//#import "EYAdManager.h"
#import "EYAdConfig.h"
#import "EYRemoteConfigHelper.h"
#import "EYSdkUtils.h"
#import "EYCustomNativeView.h"
//#import <FBSDKLoginKit/FBSDKLoginKit.h>


@implementation EYAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [EYSdkUtils initUMMobSdk:@"test" channel:@"eyu"];
//    [EYSdkUtils initAppFlyer:@"test" appId:@"test"];
//    [EYSdkUtils initGDTActionSdk:@"test" secretkey:@"test"];
//    [EYSdkUtils initFirebaseSdk];
//    [EYSdkUtils initTrackingWithAppKey:@"475938c702f7451a88eaffb524962649"];
//    [EYSdkUtils initThinkWithAppID:@"your_think_id" isInCN:YES];
//    [EYSdkUtils initFacebookSdkWithApplication:application options:launchOptions];
//    [EYSdkUtils initAnyThinkWithAppID:@"a5b0e8491845b3" AppKey:@"7eae0567827cfe2b22874061763f30c9"];
    // Override point for customization after application launch.
//    EYAdConfig* adConfig2 = [[EYAdConfig alloc] init];
    EYAdConfig* adConfig = [[EYAdConfig alloc] init];
    //[[EYRemoteConfigHelper sharedInstance] setDefaults:dict];
//    [[EYRemoteConfigHelper sharedInstance] getString:@"ios_ad_key_setting"];
    adConfig.adKeyData =  [EYSdkUtils readFileWithName:@"ios_ad_key_setting2"];
    adConfig.adGroupData = [EYSdkUtils readFileWithName:@"ios_ad_cache_setting2"];
    adConfig.adPlaceData = [EYSdkUtils readFileWithName:@"ios_ad_setting2"];
//    adConfig.adKeyData =  [EYSdkUtils readFileWithName:@"ios_ad_key_setting"];
//    adConfig.adGroupData = [EYSdkUtils readFileWithName:@"ios_ad_cache_setting"];
//    adConfig.adPlaceData = [EYSdkUtils readFileWithName:@"ios_ad_setting"];
//    adConfig.adSuiteData = [EYSdkUtils readFileWithName:@"ios_ad_group_setting"];
//    adConfig.mopubAdParams = @{@"mopubAdUnitId": @"faeaaa4fbbc944919b38e8308eb08ab", @"pangleApp_id": @"5023932"};
    adConfig.abuAppId = @"5149732";
//    adConfig.mtgAppId = @"142996";
//    adConfig.mtgAppKey = @"a339a16bbaca844012276afad6f59eaa";
//    adConfig.admobClientId = @"ca-app-pub-1111111111111111~1111111111";
//    adConfig.wmAppKey = @"5126512";
//    adConfig.gdtAppId = @"1108127036";
//    adConfig.unityClientId = @"2340038";
//    adConfig.vungleClientId = @"5bdbc67a6d9d2200139056f9";
//    adConfig.ironSourceAppKey = @"cceee1bd";//@"a78e7db5";
    [[EYAdManager sharedInstance] setupWithConfig:adConfig];
    [[EYAdManager sharedInstance] registerNativeAdCustomClass:[EYCustomNativeView class]];
    [[EYAdManager sharedInstance] setDelegate:self];
//    [EYSdkUtils initFacebookSdkWithApplication:application options:launchOptions];
    adConfig.maxUserId = @"xx";
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)onAdLoaded:(EYuAd *)eyuAd {
    NSLog(@"lw, onAdLoaded adPlaceId = %@, type = %@", eyuAd.placeId, eyuAd.adFormat);
}

-(void) onAdReward:(EYuAd *)eyuAd
{
    NSLog(@"lw, onAdReward adPlaceId = %@, type = %@", eyuAd.placeId, eyuAd.adFormat);

}
-(void) onAdShowed:(EYuAd *)eyuAd
{
    NSLog(@"lw, onAdShowed adPlaceId = %@, type = %@", eyuAd.placeId, eyuAd.adFormat);
}
-(void) onAdClosed:(EYuAd *)eyuAd
{
    NSLog(@"lw, onAdClosed adPlaceId = %@, type = %@", eyuAd.placeId, eyuAd.adFormat);
}
-(void) onAdClicked:(EYuAd *)eyuAd
{
    NSLog(@"lw, onAdClicked adPlaceId = %@, type = %@", eyuAd.placeId, eyuAd.adFormat);

}

- (void)onAdRevenue:(EYuAd *)eyuAd {
    NSLog(@"广告展示数据 extraData = %@", eyuAd.adRevenue);
}

- (void)onDefaultNativeAdClicked {

}

- (void)onAdLoadFailed:(EYuAd *)eyuAd {
    NSLog(@"lw, onAdLoadFailed adPlaceId = %@, key = %@, code = %ld", eyuAd.placeId, eyuAd.unitId, eyuAd.error.code);
}

//- (void)onAdLoadFailed:(nonnull NSString *)adPlaceId key:(nonnull NSString *)key code:(int)code {
//    NSLog(@"lw, onAdLoadFailed adPlaceId = %@, key = %@, code = %d", adPlaceId, key, code);
//}

-(void) onAdImpression:(EYuAd *)eyuAd
{
    NSLog(@"lw, onAdImpression adPlaceId = %@, type = %@", eyuAd.placeId, eyuAd.adFormat);
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url  options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
//    return [EYSdkUtils application:app openURL:url options:options];
    return false;
}

@end
