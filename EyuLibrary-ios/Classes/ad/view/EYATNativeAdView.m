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
//    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _mainImageView.frame = self.bounds;
}

- (void)layoutMediaView {
    self.mediaView.layer.zPosition = -1;
    self.mediaView.frame = self.bounds;
}

-(NSArray<UIView*>*)clickableViews {
    NSMutableArray<UIView*> *clickableViews = [NSMutableArray<UIView*> arrayWithObjects:_mainImageView, nil];
    if (self.mediaView != nil) { [clickableViews addObject:self.mediaView]; }
    return clickableViews;
}

@end
#endif
