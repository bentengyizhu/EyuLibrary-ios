//
//  EYBannerAdAdapter.h
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/7.
//

#import "EYAdAdapter.h"
#import "UIViewExtension.h"

@interface EYBannerAdAdapter : EYAdAdapter

@property(nonatomic,strong)EYAdGroup *adGroup;
@property(nonatomic,assign)bool isShowing;
@property(nonatomic,strong)NSTimer *loadingTimer;

-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group;

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

