//
//  EYMopubNativeAdView.m
//  EyuLibrary-ios
//
//  Created by eric on 2021/4/12.
//

#ifdef MOPUB_ENABLED
#import "EYMopubNativeAdView.h"

@implementation EYMopubNativeAdView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mainImageView = [UIImageView new];
        self.mainTextLabel = [UILabel new];
        self.titleLabel = [UILabel new];
        self.callToActionLabel = [UILabel new];
        self.sponsoredByLabel = [UILabel new];
        self.iconImageView = [UIImageView new];
        self.privacyInformationIconImageView = [UIImageView new];
        
        [self addSubview:self.mainImageView];
        [self addSubview:self.mainTextLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.callToActionLabel];
        [self addSubview:self.sponsoredByLabel];
        [self addSubview:self.iconImageView];
        [self addSubview:self.privacyInformationIconImageView];
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (UILabel *)nativeMainTextLabel
{
    return self.mainTextLabel;
}

- (UILabel *)nativeTitleTextLabel
{
    return self.titleLabel;
}

- (UILabel *)nativeCallToActionTextLabel
{
    return self.callToActionLabel;
}

- (UILabel *)nativeSponsoredByCompanyTextLabel
{
    return self.sponsoredByLabel;
}

- (UIImageView *)nativeIconImageView
{
    return self.iconImageView;
}

- (UIImageView *)nativeMainImageView
{
    return self.mainImageView;
}

- (UIImageView *)nativePrivacyInformationIconImageView
{
    return self.privacyInformationIconImageView;
}
@end
#endif
