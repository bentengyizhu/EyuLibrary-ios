//
//  EYBannerAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/7.
//

#import "EYAdAdapter.h"
#import "UIViewExtension.h"

@protocol IBannerAdDelegate;
@interface EYBannerAdAdapter : EYAdAdapter

@property(nonatomic,weak)id<IBannerAdDelegate> delegate;
@property(nonatomic,strong)EYAdKey *adKey;
@property(nonatomic,strong)EYAdGroup *adGroup;
@property(nonatomic,assign)bool isLoading;
@property(nonatomic,assign)bool isShowing;
@property(nonatomic,assign)int tryLoadAdCount;
@property(nonatomic,strong)NSTimer *loadingTimer;

-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group;

-(void) loadAd;
-(bool) isAdLoaded;
-(bool) showAdGroup:(UIView *)viewGroup;
-(void) notifyOnAdLoaded;
-(void) notifyOnAdLoadFailedWithError:(int)errorCode;
-(void) notifyOnAdShowed;
-(void) notifyOnAdClicked;
-(void) notifyOnAdRewarded;
-(void) notifyOnAdClosed;
-(void) notifyOnAdImpression;
-(void) notifyOnAdShowedData:(NSDictionary *)data;
-(UIView *) getBannerView;

-(void) startTimeoutTask;
-(void) cancelTimeoutTask;
@end

@protocol IBannerAdDelegate <NSObject>

@optional
-(void) onAdLoaded:(EYBannerAdAdapter *)adapter;
-(void) onAdLoadFailed:(EYBannerAdAdapter *)adapter withError:(int)errorCode;
-(void) onAdShowed:(EYBannerAdAdapter *)adapter;
-(void) onAdClicked:(EYBannerAdAdapter *)adapter;
-(void) onAdClosed:(EYBannerAdAdapter *)adapter;
-(void) onAdRewarded:(EYBannerAdAdapter *)adapter;
-(void) onAdImpression:(EYBannerAdAdapter *)adapter;
-(void) onAdShowed:(EYBannerAdAdapter *)adapter extraData:(NSDictionary *)extraData;
@end
