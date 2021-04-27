//
//  FbInterstitialAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//

#include "EYInterstitialAdAdapter.h"


@implementation EYInterstitialAdAdapter
@synthesize adGroup = _adGroup;
@synthesize loadingTimer = _loadingTimer;
@synthesize isShowing = _isShowing;


-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group
{
    self = [super init];
    if(self)
    {
        self.adKey = adKey;
        self.adGroup = group;
        self.isShowing = false;
        self.isLoading = false;
    }
    return self;
}

-(void) loadAd
{
    NSAssert(true, @"子类中实现");
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSAssert(true, @"子类中实现");
    return false;
}

-(bool) isAdLoaded
{
    NSAssert(true, @"子类中实现");
    return false;
}

-(void) notifyOnAdLoaded
{
    self.isLoading = false;
    if(self.delegate!=NULL)
    {
        [self.delegate onAdLoaded:self];
    }
}

-(void) notifyOnAdLoadFailedWithError:(int)errorCode;
{
    self.isLoading = false;
    if(self.delegate!=NULL)
    {
        [self.delegate onAdLoadFailed:self withError:errorCode];
    }
}

-(void) notifyOnAdShowed
{
    if(self.delegate!=NULL)
    {
        [self.delegate onAdShowed:self];
    }
}

-(void) notifyOnAdClicked
{
    if(self.delegate!=NULL)
    {
        [self.delegate onAdClicked:self];
    }
}

- (void)notifyOnAdShowedData:(NSDictionary *)data {
    if(self.delegate!=NULL)
    {
        [self.delegate onAdShowed:self extraData:data];
    }
}

-(void) notifyOnAdClosed
{
    if(self.delegate!=NULL)
    {
        [self.delegate onAdClosed:self];
    }
}

-(void) notifyOnAdImpression
{
    if(self.delegate!=NULL)
    {
        [self.delegate onAdImpression:self];
    }
}

-(void) startTimeoutTask
{
    [self cancelTimeoutTask];
    self.loadingTimer = [NSTimer scheduledTimerWithTimeInterval:TIMEOUT_TIME target:self selector:@selector(timeout) userInfo:nil repeats:false];
    
}

- (void) timeout{
    NSLog(@" timeout");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:ERROR_TIMEOUT];
}


-(void) cancelTimeoutTask
{
    if (self.loadingTimer) {
        [self.loadingTimer invalidate];
        self.loadingTimer = nil;
    }
}

- (void)dealloc
{
    [self cancelTimeoutTask];
    self.delegate = NULL;
    self.adKey = NULL;
    self.adGroup = NULL;
}

@end
