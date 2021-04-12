//
//  EYMopubNativeAdView.h
//  EyuLibrary-ios
//
//  Created by eric on 2021/4/12.
//

#ifdef MOPUB_ENABLED
#import <UIKit/UIKit.h>
#import "MPNativeAdRendering.h"

@interface EYMopubNativeAdView : UIView <MPNativeAdRendering>
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *mainTextLabel;
@property (strong, nonatomic) UILabel *callToActionLabel;
@property (strong, nonatomic) UILabel *sponsoredByLabel;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UIImageView *mainImageView;
@property (strong, nonatomic) UIImageView *privacyInformationIconImageView;
@end

#endif
