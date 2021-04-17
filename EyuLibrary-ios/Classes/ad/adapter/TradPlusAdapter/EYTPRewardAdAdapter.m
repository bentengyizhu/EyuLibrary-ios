//
//  EYTPRewardAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2020/12/29.
//

#ifdef TRADPLUS_ENABLED
#import "EYTPRewardAdAdapter.h"

@implementation EYTPRewardAdAdapter
@synthesize isRewarded = _isRewarded;
@synthesize rewardedVideoAd = _rewardedVideoAd;

-(void) loadAd
{
    NSLog(@"tp loadAd isAdLoaded = %d", [self isAdLoaded]);
    if([self isShowing]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
    }else if([self isAdLoaded])
    {
        [self notifyOnAdLoaded];
    }else if(![self isLoading] )
    {
        if(self.rewardedVideoAd!=NULL)
        {
            self.rewardedVideoAd.delegate = nil;
        }
        self.isLoading = true;
        self.rewardedVideoAd = [[MsRewardedVideoAd alloc] init];
        self.rewardedVideoAd.delegate = self;
        [self.rewardedVideoAd setAdUnitID:self.adKey.key isAutoLoad:NO];
        [self startTimeoutTask];
        [self.rewardedVideoAd loadAd];
    }else{
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"tp showAd ");
    if([self isAdLoaded])
    {
        bool result = [self.rewardedVideoAd showAdFromRootViewController:controller];
        if(result)
        {
            self.isShowing = YES;
            [self notifyOnAdShowed];
        }
        return result;
    }
    return false;
}

-(bool) isAdLoaded
{
    bool isAdLoaded = self.rewardedVideoAd != NULL && self.rewardedVideoAd.isAdReady;
    NSLog(@"tp Reward video ad isAdLoaded = %d", isAdLoaded);
    return isAdLoaded;
}

//单个广告源加载成功
-(void)rewardedVideoAdLoaded:(MsRewardedVideoAd *)rewardedVideoAd
{
    NSLog(@"tp Reward video ad is loaded.");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

//单个广告源加载失败
-(void)rewardedVideoAd:(MsRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    NSLog(@"tp Reward video ad is failed to load. error = %d", (int)error.code);
    self.isLoading = false;
    if(self.rewardedVideoAd != NULL ){
        self.rewardedVideoAd.delegate = NULL;
        self.rewardedVideoAd = NULL;
    }
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

//开始播放视频后回调
-(void)rewardedVideoAdShown:(MsRewardedVideoAd *)rewardedVideoAd
{
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

//视频播放结束后，关闭落地页
-(void)rewardedVideoAdDismissed:(MsRewardedVideoAd *)rewardedVideoAd
{
    NSLog(@"tp Reward video ad is closed.");
    if(self.rewardedVideoAd != NULL ){
        self.rewardedVideoAd.delegate = NULL;
        self.rewardedVideoAd = NULL;
    }
    if(self.isRewarded){
        [self notifyOnAdRewarded];
    }
    self.isShowing = NO;
    self.isRewarded = NO;
    [self notifyOnAdClosed];
}

//点击广告后回调。
-(void)rewardedVideoAdClicked:(MsRewardedVideoAd *)rewardedVideoAd
{
    
}

//播放完成获得奖励后回调 reward为TradPlus后台设置的奖励 通过reward.currencyType reward.amount访问
-(void)rewardedVideoAdShouldReward:(MsRewardedVideoAd *)rewardedVideoAd reward:(MSRewardedVideoReward *)reward
{
    self.isRewarded = true;
}

//load 完成
- (void)rewardedVideoAdAllLoaded:(MsRewardedVideoAd *)rewardedVideoAd readyCount:(int)readyCount
{
    if (readyCount > 0)
    {
        //加载成功，有可供展示的插屏广告。
    }
    else {
        //加载失败，如果没有设置isAutoLoad为YES，需要在30秒后重新load一次。
    }
}
@end
#endif

