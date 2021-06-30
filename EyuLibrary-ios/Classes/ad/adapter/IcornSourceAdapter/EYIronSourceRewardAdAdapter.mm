//
//  EYIronSourceRewardAdAdapter.m
//  Bolts
//
//  Created by caochao on 2019/3/19.
//
#ifdef IRON_ADS_ENABLED

#import "EYIronSourceRewardAdAdapter.h"
#import "IronSource/IronSource.h"
#import "EYAdManager.h"

@interface EYIronSourceRewardAdAdapter()<ISDemandOnlyRewardedVideoDelegate>

@property(nonatomic,assign) bool isRewarded;
@property(nonatomic,assign) bool isClosed;

@end

@implementation EYIronSourceRewardAdAdapter

-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group
{
    self = [super initWithAdKey:adKey adGroup:group];
    if(self)
    {
        [[EYAdManager sharedInstance] addIronRewardDelegate:self withKey:adKey.key];
    }
    return self;
}

-(void) loadAd
{
    NSLog(@" EYIronSourceRewardAdAdapter loadAd #############. adId = #%@#", self.adKey.key);
    if([self isShowing ]){
        EYuAd *ad = [self getEyuAd];
        ad.error = [[NSError alloc]initWithDomain:@"isshowingdomain" code:ERROR_AD_IS_SHOWING userInfo:nil];
        [self notifyOnAdLoadFailedWithError:ad];
    }else if([self isAdLoaded]) {
        [self notifyOnAdLoaded: [self getEyuAd]];
    }
    else {
        [IronSource loadISDemandOnlyRewardedVideo:self.adKey.key];
    }
}

-(EYuAd *) getEyuAd{
    EYuAd *ad = [EYuAd new];
    ad.unitId = self.adKey.key;
    ad.unitName = self.adKey.keyId;
    ad.placeId = self.adKey.placementid;
    ad.adFormat = ADTypeReward;
    ad.mediator = @"icornsource";
    return ad;
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@" EYIronSourceRewardAdAdapter showAd #############.");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        self.isRewarded = false;
        self.isClosed = false;
        [IronSource showISDemandOnlyRewardedVideo:controller instanceId:self.adKey.key];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    bool result = [IronSource hasISDemandOnlyRewardedVideo:self.adKey.key];
    NSLog(@" EYIronSourceRewardAdAdapter hasISDemandOnlyRewardedVideo result = %d",result);
    return result;
}

#pragma mark - IronSource Rewarded Video Delegate Functions
- (void)rewardedVideoDidLoad:(NSString *)instanceId
{
    NSLog(@" EYIronSourceRewardAdAdapter rewardedVideoDidLoad key = %@", self.adKey.key);

    self.isLoading = false;
    [self notifyOnAdLoaded: [self getEyuAd]];
}

- (void)rewardedVideoDidFailToLoadWithError:(NSError *)error instanceId:(NSString *)instanceId
{
    NSLog(@" EYIronSourceRewardAdAdapter rewardedVideoDidFailToLoadWithError %@", error);
    self.isLoading = false;
    EYuAd *ad = [self getEyuAd];
    ad.error = error;
    [self notifyOnAdLoadFailedWithError:ad];
}

- (void)rewardedVideoDidOpen:(NSString *)instanceId
{
    NSLog(@" EYIronSourceRewardAdAdapter rewardedVideoDidOpen");
    [self notifyOnAdShowed: [self getEyuAd]];
    [self notifyOnAdImpression: [self getEyuAd]];
}

- (void)rewardedVideoDidClose:(NSString *)instanceId
{
    NSLog(@" EYIronSourceRewardAdAdapter rewardedVideoDidClose. self->isRewarded = %d", self.isRewarded);
    self.isClosed = true;
    self.isShowing = NO;
    if(self.isRewarded){
        [self notifyOnAdRewarded: [self getEyuAd]];
    }
    [self notifyOnAdClosed: [self getEyuAd]];
}

- (void)rewardedVideoDidFailToShowWithError:(NSError *)error instanceId:(NSString *)instanceId
{
    NSLog(@" EYIronSourceRewardAdAdapter rewardedVideoDidFailToShowWithError, error = %@", error);
    self.isShowing = NO;
}

- (void)rewardedVideoDidClick:(NSString *)instanceId
{
    NSLog(@" EYIronSourceRewardAdAdapter didClickRewardedVideo");
    [self notifyOnAdClicked: [self getEyuAd]];
}

- (void)rewardedVideoAdRewarded:(NSString *)instanceId
{
    self.isRewarded = true;
    if(self.isClosed) {
        [self notifyOnAdRewarded: [self getEyuAd]];
    }
}
    
@end
#endif /*IRON_ADS_ENABLED*/
