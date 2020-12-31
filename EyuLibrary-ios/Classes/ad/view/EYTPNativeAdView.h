//
//  EYTPNativeAdView.h
//  EyuLibrary-ios
//
//  Created by eric on 2020/12/31.
//
#ifdef TRADPLUS_ENABLED
#import <UIKit/UIKit.h>
#import <TradPlusAds/MSNativeAdRendering.h>

@interface EYTPNativeAdView : UIView <MSNativeAdRendering>
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UIImageView *mainImageView;
//@property (strong, nonatomic) UIImageView *privacyInformationIconImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *ctaLabel;
@property (strong, nonatomic) UILabel *mainTextLabel;
//@property (strong, nonatomic) UIView *videoView;
@end
#endif
