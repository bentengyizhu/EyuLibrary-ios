//
//  AdConfig.h
//  ballzcpp-mobile
//
//  Created by apple on 2018/5/2.
//

#ifndef AdConfig_h
#define AdConfig_h

@interface EYAdConfig : NSObject{

}

@property(nonatomic,strong)NSData *adPlaceData;
@property(nonatomic,strong)NSData *adKeyData;
@property(nonatomic,strong)NSData *adGroupData;
@property(nonatomic,strong)NSData *adSuiteData;

@property(nonatomic,assign)bool isNewJsonSetting;

#ifdef ADMOB_ADS_ENABLED
@property(nonatomic,copy)NSString *admobClientId;
#endif

#ifdef UNITY_ADS_ENABLED
@property(nonatomic,copy)NSString *unityClientId;
#endif

#ifdef VUNGLE_ADS_ENABLED
@property(nonatomic,copy)NSString *vungleClientId;
#endif

@property(nonatomic,assign)int reportEvent;

#ifdef BYTE_DANCE_ADS_ENABLED
@property(nonatomic,copy)NSString *wmAppKey;
#endif

@property(nonatomic,assign)bool isPaidApp;

#ifdef GDT_ADS_ENABLED
@property(nonatomic,copy)NSString *gdtAppId;
#endif

#ifdef MTG_ADS_ENABLED
@property(nonatomic,copy)NSString *mtgAppId;
@property(nonatomic,copy)NSString *mtgAppKey;
#endif

#ifdef IRON_ADS_ENABLED
@property(nonatomic,copy)NSString *ironSourceAppKey;
#endif

#ifdef ABUADSDK_ENABLED
@property(nonatomic,copy)NSString *abuAppId;
#endif

#ifdef MOPUB_ENABLED
@property(nonatomic,strong)NSDictionary *mopubAdParams;
#endif

#ifdef APPLOVIN_MAX_ENABLED
@property(nonatomic,copy)NSString *maxUserId;
#endif

-(instancetype) initWithPlace:(NSData*)adPlaceData  key: (NSData*) adKeyData group:(NSData*) adGroupData suite:(NSData*) adSuiteData;

@end

#endif /* AdConfig_h */
