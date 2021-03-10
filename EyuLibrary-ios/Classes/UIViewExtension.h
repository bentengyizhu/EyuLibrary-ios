//
//  UIControllerExtension.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/10.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@class EYBannerAdAdapter;

@interface UIView(ABUBanner)

@property (nonatomic, strong) EYBannerAdAdapter* bannerAdapter;

@end
