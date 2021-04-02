//
//  EYAdAdapter.m
//  EyuLibrary-ios-EyuLibrary
//
//  Created by eric on 2021/4/1.
//

#import "EYAdAdapter.h"

@implementation EYAdAdapter


- (void)loadAd {
    NSLog(@"子类实现");
}

-(bool) isAdLoaded
{
    NSAssert(true, @"子类中实现");
    return false;
}
@end
