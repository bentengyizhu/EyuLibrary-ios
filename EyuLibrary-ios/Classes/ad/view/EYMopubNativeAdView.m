//
//  EYMopubNativeAdView.m
//  EyuLibrary-ios
//
//  Created by eric on 2021/4/12.
//

#ifdef MOPUB_ENABLED
#import "EYMopubNativeAdView.h"

@implementation EYMopubNativeAdView

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
