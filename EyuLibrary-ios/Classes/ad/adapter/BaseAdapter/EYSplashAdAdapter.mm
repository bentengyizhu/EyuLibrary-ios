//
//  EYSplashAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/5.
//

#import "EYSplashAdAdapter.h"

@implementation EYSplashAdAdapter
@synthesize adGroup = _adGroup;
@synthesize isShowing = _isShowing;
@synthesize loadingTimer = _loadingTimer;

-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group
{
    self = [super init];
    if(self)
    {
        self.adKey = adKey;
        self.adGroup = group;
        self.isLoading = false;
        self.isShowing = false;
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

- (void)notifyOnAdLoaded:(EYuAd *)eyuAd {
    self.isLoading = false;
    [self cancelTimeoutTask];
    if(self.delegate!=NULL)
    {
        [self.delegate onAdLoaded:self eyuAd:eyuAd];
    }
}

-(void) notifyOnAdLoadFailedWithError:(EYuAd *)eyuAd;
{
    self.isLoading = false;
    [self cancelTimeoutTask];
    if(self.delegate!=NULL)
    {
        [self.delegate onAdLoadFailed:self eyuAd:eyuAd];
    }
}
-(void) notifyOnAdShowed:(EYuAd *)eyuAd
{
    if(self.delegate!=NULL)
    {
        [self.delegate onAdShowed:self eyuAd:eyuAd];
    }
}


-(void) notifyOnAdClicked:(EYuAd *)eyuAd
{
    if(self.delegate!=NULL)
    {
        [self.delegate onAdClicked:self eyuAd:eyuAd];
    }
}

- (void)notifyOnAdRevenue:(EYuAd *)eyuAd {
    self.isLoading = false;
    if(self.delegate!=NULL)
    {
        [self.delegate onAdRevenue:self eyuAd:eyuAd];
//        [self.delegate onAdShowed:self eyuAd:eyuAd];
    }
}

-(void) notifyOnAdClosed:(EYuAd *)eyuAd
{
    self.isLoading = false;
    self.isShowing = false;
    if(self.delegate!=NULL)
    {
        [self.delegate onAdClosed:self eyuAd:eyuAd];
    }
}

-(void) notifyOnAdImpression:(EYuAd *)eyuAd
{
    if(self.delegate!=NULL)
    {
        [self.delegate onAdImpression:self eyuAd:eyuAd];
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
    EYuAd *eyuAd = [EYuAd new];
    eyuAd.adFormat = ADTypeSplash;
    eyuAd.unitId = self.adKey.key;
    eyuAd.unitName = self.adKey.keyId;
    eyuAd.error = [[NSError alloc]initWithDomain:@"timeoutDomian" code:ERROR_TIMEOUT userInfo:nil];
    [self notifyOnAdLoadFailedWithError:eyuAd];
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
