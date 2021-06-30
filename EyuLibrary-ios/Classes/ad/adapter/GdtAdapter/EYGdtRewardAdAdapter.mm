//
//  EYGdtRewardAdAdapter.mm
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef GDT_ADS_ENABLED

#include "EYGdtRewardAdAdapter.h"
#import "GDTRewardVideoAd.h"
#import "EYAdManager.h"


@interface EYGdtRewardAdAdapter()<GDTRewardedVideoAdDelegate>

@property(nonatomic,assign)bool isRewarded;
@property(nonatomic,strong)GDTRewardVideoAd* rewardAd;

@end

@implementation EYGdtRewardAdAdapter

@synthesize isRewarded = _isRewarded;
@synthesize rewardAd = _rewardAd;

-(void) loadAd
{
    NSLog(@"gdt EYGdtRewardAdAdapter loadAd isAdLoaded = %d", [self isAdLoaded]);
    if([self isShowing ]){
        EYuAd *ad = [self getEyuAd];
        ad.error = [[NSError alloc]initWithDomain:@"isshowingdomain" code:ERROR_AD_IS_SHOWING userInfo:nil];
        [self notifyOnAdLoadFailedWithError:ad];
    }else if([self isAdLoaded])
    {
        [self notifyOnAdLoaded:[self getEyuAd]];
    }else if(![self isLoading] )
    {
        if(self.rewardAd!=NULL)
        {
            self.rewardAd.delegate = nil;
        }
//        EYAdManager* manager = [EYAdManager sharedInstance];
//        NSString* appId = manager.adConfig.gdtAppId;
        self.isLoading = true;
        self.rewardAd =  [[GDTRewardVideoAd alloc] initWithPlacementId:self.adKey.key];
        self.rewardAd.delegate = self;
        [self startTimeoutTask];
        [self.rewardAd loadAd];
    }else{
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"gdt show reward Ad ");
    if([self isAdLoaded])
    {
        self.isShowing = true;
        return [self.rewardAd showAdFromRootViewController:controller];
    }
    return false;
}

-(EYuAd *) getEyuAd{
    EYuAd *ad = [EYuAd new];
    ad.unitId = self.adKey.key;
    ad.unitName = self.adKey.keyId;
    ad.placeId = self.adKey.placementid;
    ad.adFormat = ADTypeReward;
    ad.mediator = @"gdt";
    return ad;
}

-(bool) isAdLoaded
{
    bool isAdLoaded = self.rewardAd != NULL && [self.rewardAd isAdValid] && self.rewardAd.expiredTimestamp > [[NSDate date] timeIntervalSince1970];
    NSLog(@"gdt Reward video ad isAdLoaded = %d", isAdLoaded);
    return isAdLoaded;
}

#pragma mark - GDTRewardVideoAdDelegate
- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@" gdt gdt_rewardVideoAdDidLoad");
}

- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@" gdt gdt_rewardVideoAdVideoDidLoad");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded:[self getEyuAd]];
}

- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@" gdt 广告已曝光");
    [self notifyOnAdShowed:[self getEyuAd]];
    [self notifyOnAdImpression:[self getEyuAd]];
}

- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@" gdt 广告已关闭");
    if(self.rewardAd != NULL ){
        self.rewardAd.delegate = NULL;
        self.rewardAd = NULL;
    }
    
    if(self.isRewarded){
        [self notifyOnAdRewarded:[self getEyuAd]];
    }
    self.isRewarded = false;
    self.isShowing = false;
    [self notifyOnAdClosed:[self getEyuAd]];
}


- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@" gdt 广告已点击");
    [self notifyOnAdClicked:[self getEyuAd]];
}

- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    if (error.code == 4014) {
        NSLog(@" gdt 请拉取到广告后再调用展示接口");
    } else if (error.code == 4016) {
        NSLog(@" gdt 应用方向与广告位支持方向不一致");
    } else if (error.code == 5012) {
        NSLog(@" gdt 广告已过期");
    } else if (error.code == 4015) {
        NSLog(@" gdt 广告已经播放过，请重新拉取");
    } else if (error.code == 5002) {
        NSLog(@" gdt 视频下载失败");
    } else if (error.code == 5003) {
        NSLog(@" gdt 视频播放失败");
    } else if (error.code == 5004) {
        NSLog(@" gdt 没有合适的广告");
    }
    NSLog(@" gdt rewarded video load fail, error:%@",error);
    self.isLoading = false;
    if(self.rewardAd != NULL ){
        self.rewardAd.delegate = NULL;
        self.rewardAd = NULL;
    }
    [self cancelTimeoutTask];
    EYuAd *ad = [self getEyuAd];
    ad.error = error;
    [self notifyOnAdLoadFailedWithError:ad];
}

- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@" gdt 播放达到激励条件");
    self.isRewarded = true;
}

- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@" gdt 视频播放结束");
    self.isRewarded = true;
}

@end
#endif /*GDT_ADS_ENABLED*/
