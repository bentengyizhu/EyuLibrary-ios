//
//  ABUMaterialMeta.h
//  BUAdSDK
//
//  Copyright © 2017 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ABUDislikeWords.h"
#import "ABUImage.h"

typedef NS_ENUM (NSInteger, ABUInteractionType) {
    ABUInteractionTypeCustorm        = 0,
    ABUInteractionTypeNO_INTERACTION = 1,  // pure ad display
    ABUInteractionTypeURL            = 2,  // open the webpage using a browser
    ABUInteractionTypePage           = 3,  // open the webpage within the app
    ABUInteractionTypeDownload       = 4,  // download the app
    ABUInteractionTypePhone          = 5,  // make a call
    ABUInteractionTypeMessage        = 6,  // send messages
    ABUInteractionTypeEmail          = 7,  // send email
    ABUInteractionTypeVideoAdDetail  = 8,   // video ad details page
    ABUInteractionTypeOthers         = 100 //其他广告sdk返回的类型
};

typedef NS_ENUM (NSInteger, ABUFeedADMode) {
    ABUFeedADModeSmallImage    = 2,
    ABUFeedADModeLargeImage    = 3,
    ABUFeedADModeGroupImage    = 4,
    ABUFeedVideoAdModeImage    = 5, // video ad || rewarded video ad horizontal screen
    ABUFeedVideoAdModePortrait = 15, // rewarded video ad vertical screen
    ABUFeedADModeImagePortrait = 16
};

@interface ABUMaterialMeta : NSObject <NSCoding>

/// interaction types supported by ads.
@property (nonatomic, assign) ABUInteractionType interactionType;

/// material pictures.
@property (nonatomic, strong) NSArray<ABUImage *> *imageAry;

/// ad logo icon.
@property (nonatomic, strong) ABUImage *icon;

/// ad headline.
@property (nonatomic, copy) NSString *AdTitle;

/// ad description.
@property (nonatomic, copy) NSString *AdDescription;

/// ad source.
@property (nonatomic, copy) NSString *source;

/// text displayed on the creative button.
@property (nonatomic, copy) NSString *buttonText;

/// display format of the in-feed ad, other ads ignores it.
@property (nonatomic, assign) ABUFeedADMode imageMode;

/// Star rating, range from 1 to 5.
@property (nonatomic, assign) NSInteger score;

/// Number of comments.
@property (nonatomic, assign) NSInteger commentNum;

/// ad installation package size, unit byte.
@property (nonatomic, assign) NSInteger appSize;

/// video duration
@property (nonatomic, assign) NSInteger videoDuration;

/// media configuration parameters.
@property (nonatomic, copy) NSDictionary *mediaExt;

/// String representation of the app's price
@property (nonatomic, strong) NSString *appPrice;

/// Identifies the advertiser. For example, the advertiser’s name or visible URL.
@property (nonatomic, copy) NSString *advertiser;

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)error;

@end
