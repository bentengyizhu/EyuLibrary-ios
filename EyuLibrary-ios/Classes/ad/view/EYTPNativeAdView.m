//
//  EYTPNativeAdView.m
//  EyuLibrary-ios
//
//  Created by eric on 2020/12/31.
//

#import "EYTPNativeAdView.h"

@implementation EYTPNativeAdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mainTextLabel = [UILabel new];
        self.titleLabel = [UILabel new];
        self.ctaLabel = [UILabel new];
        self.iconImageView = [UIImageView new];
        self.mainImageView = [UIImageView new];
//        self.privacyInformationIconImageView = [UIImageView new];
        self.mainImageView.contentMode = UIViewContentModeScaleAspectFit;
        _mainImageView.layer.zPosition = -2;
    }
    return self;
}

- (void)layoutSubviews {
    [self addSubview:_mainImageView];
    _mainImageView.frame = self.bounds;
//    if (self.videoView) {
//        self.videoView.frame = self.bounds;
//    }
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
    return self.ctaLabel;
}

- (UIImageView *)nativeIconImageView
{
    return self.iconImageView;
}

- (UIImageView *)nativeMainImageView
{
    return self.mainImageView;
}

//- (UIView *)nativeVideoView {
//    if (!self.videoView) {
//        self.videoView = [UIView new];
//    }
//    return self.videoView;
//}

//- (UIImageView *)nativePrivacyInformationIconImageView
//{
//    return self.privacyInformationIconImageView;
//}

@end
