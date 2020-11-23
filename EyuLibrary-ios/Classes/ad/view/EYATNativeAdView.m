//
//  EYATNativeAdView.m
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/23.
//

#ifdef ANYTHINK_ENABLED
#import "EYATNativeAdView.h"

@implementation EYATNativeAdView

- (void)initSubviews {
    [super initSubviews];
    _mainImageView = [[UIImageView alloc] init];
    _mainImageView.contentMode = UIViewContentModeScaleAspectFit;
//    if (self.mediaView) {
//        [self insertSubview:_mainImageView belowSubview:self.mediaView];
//    } else {
    [self addSubview:_mainImageView];
    _mainImageView.layer.zPosition = -2;
    self.mediaView.layer.zPosition = -1;
//    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _mainImageView.frame = self.bounds;
    if (self.mediaView) {
        self.mediaView.frame = self.bounds;
    }
}


@end
#endif
