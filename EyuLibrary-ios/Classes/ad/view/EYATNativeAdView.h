//
//  EYATNativeAdView.h
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/23.
//

#ifdef ANYTHINK_ENABLED
#import <AnyThinkNative/AnyThinkNative.h>

@interface EYATNativeAdView : ATNativeADView<ATNativeRendering>
@property(nonatomic, readonly) UILabel *advertiserLabel;
@property(nonatomic, readonly) UILabel *textLabel;
@property(nonatomic, readonly) UILabel *titleLabel;
@property(nonatomic, readonly) UILabel *ctaLabel;
@property(nonatomic, readonly) UILabel *ratingLabel;
@property(nonatomic, readonly) UIImageView *iconImageView;
@property(nonatomic, readonly) UIImageView *mainImageView;
@end
#endif
