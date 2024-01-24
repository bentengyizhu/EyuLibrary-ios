//
//  RemoteConfigHelper-ios.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/2/8.
//

#include <stdio.h>
#include "EYRemoteConfigHelper.h"

#ifdef FIREBASE_ENABLED
static id s_sharedRemoteConfigHelperIOS;

@interface EYRemoteConfigHelper()

//@property(nonatomic,strong)FIRRemoteConfig *remoteConfig;
//@property(nonatomic,strong)NSDictionary *defConfig;

@end


@implementation EYRemoteConfigHelper

//@synthesize remoteConfig = _remoteConfig;
//@synthesize defConfig = _defConfig;

+(id) sharedInstance
{
    if (s_sharedRemoteConfigHelperIOS == nil)
    {
        s_sharedRemoteConfigHelperIOS = [[EYRemoteConfigHelper alloc] init];
    }
    
    return s_sharedRemoteConfigHelperIOS;
}
//
//- (void) setupWithDefault:(NSDictionary *)defDict
//{
//    NSLog(@"-------------RemoteConfigHelperIOS setup----------------");
//    self.remoteConfig = [FIRRemoteConfig remoteConfig];
//    self.defConfig = defDict;
//    [self.remoteConfig setDefaults:defDict];
//    // TimeInterval is set to expirationDuration here, indicating the next fetch request will use
//    // data fetched from the Remote Config service, rather than cached parameter values, if cached
//    // parameter values are more than expirationDuration seconds old. See Best Practices in the
//    // README for more information.
//    [self.remoteConfig fetchWithExpirationDuration:0 completionHandler:^(FIRRemoteConfigFetchStatus status, NSError *error) {
//        if (status == FIRRemoteConfigFetchStatusSuccess) {
//            NSLog(@"Config fetched!");
//            [self.remoteConfig activateWithCompletion:^(BOOL changed, NSError * _Nullable error) {
//                NSLog(@"Config not activate");
//                NSLog(@"Error %@", error.localizedDescription);
//            }];
//        } else {
//            NSLog(@"Config not fetched");
//            NSLog(@"Error %@", error.localizedDescription);
//        }
//
//    }];
//}
//
//-(void)fetchRemoteConfig
//{
//    [self.remoteConfig fetchWithExpirationDuration:0 completionHandler:nil];
//}
//
//- (NSData*)getData:(NSString*) key
//{
//    if(self->_remoteConfig[key] != NULL){
//        return self->_remoteConfig[key].dataValue;
//    }else{
//        return self.defConfig[key];
//    }
//}
//
//-(NSString*)getString:(NSString*) key
//{
//    if(self->_remoteConfig[key] != NULL){
//        return self->_remoteConfig[key].stringValue;
//    }else{
//        return self.defConfig[key];
//    }
//}
//
//-(bool)getBoolean:(NSString*) key
//{
//    if(self->_remoteConfig[key] != NULL){
//        return self->_remoteConfig[key].boolValue;
//    }else{
//        return self.defConfig[key];
//    }
//}
//
//-(long)getLong:(NSString*) key
//{
//    if(self->_remoteConfig[key] != NULL){
//        return self->_remoteConfig[key].numberValue.longValue;
//    }else{
//        return self.defConfig[key]!=nil ? ((NSNumber*)self.defConfig[key]).longValue : 0;
//    }
//}
//
//-(double)getDouble:(NSString*) key
//{
//    if(self->_remoteConfig[key] != NULL){
//        return self->_remoteConfig[key].numberValue.doubleValue;
//    }else{
//        return self.defConfig[key]!=nil ? ((NSNumber*)self.defConfig[key]).doubleValue : 0;
//    }
//}
//
//+ (bool)getBoolean:(NSDictionary*) dict
//{
//    NSString *key = [dict objectForKey:@"key"];
//    if (key == nil) {
//        NSLog(@"getBoolean key is nil");
//        return false;
//    }
//    return [[EYRemoteConfigHelper sharedInstance] getBoolean:key];
//}
//
//+ (NSString*)getString:(NSDictionary*) dict
//{
//    NSString *key = [dict objectForKey:@"key"];
//    if (key == nil) {
//        NSLog(@"getBoolean key is nil");
//        return nil;
//    }
//    return [[EYRemoteConfigHelper sharedInstance] getString:key];
//}
//
//+ (long)getLong:(NSDictionary*) dict
//{
//    NSString *key = [dict objectForKey:@"key"];
//    if (key == nil) {
//        NSLog(@"getBoolean key is nil");
//        return 0;
//    }
//    return [[EYRemoteConfigHelper sharedInstance] getLong:key];
//}
//
//+ (double)getDouble:(NSDictionary*) dict
//{
//    NSString *key = [dict objectForKey:@"key"];
//    if (key == nil) {
//        NSLog(@"getBoolean key is nil");
//        return 0;
//    }
//    return [[EYRemoteConfigHelper sharedInstance] getDouble:key];
//}
@end

#endif
