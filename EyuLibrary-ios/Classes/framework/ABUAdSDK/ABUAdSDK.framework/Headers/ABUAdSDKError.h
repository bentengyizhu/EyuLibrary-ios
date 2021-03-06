//
//  ABUAdSDKError.h
//  BUAdSDK
//
//  Copyright © 2017年 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSErrorDomain ABUErrorDomain;

typedef NS_ENUM (NSInteger, ABUErrorCode) {
    ABUErrorCodeTempError                   = -6, // native template is invalid
    ABUErrorCodeTempAddationError           = -5, // native template addation is invalid
    ABUErrorCodeOpenAPPStoreFail            = -4, // failed to open appstore
    ABUErrorCodeNOAdError                   = -3, // parsed data has no ads
    ABUErrorCodeNetError                    = -2, // network request failed
    ABUErrorCodeParseError                  = -1, // parsing failed

    ABUErrorCodePlayableError_ERR_HAS_CACHE = -702,    // has cache
    ABUErrorCodePlayableError_ERR_UNZIP     = -704,    // unzip error

    ABUErrorCodeNERenderResultError         = 101, // native Express ad, render result parse fail
    ABUErrorCodeNETempError                 = 102, // native Express ad, template is invalid
    ABUErrorCodeNETempPluginError           = 103, // native Express ad, template plugin is invalid
    ABUErrorCodeNEDataError                 = 104, // native Express ad, data is invalid
    ABUErrorCodeNEParseError                = 105, // native Express ad, parse fail
    ABUErrorCodeNERenderError               = 106, // native Express ad, render fail
    ABUErrorCodeNERenderTimoutError         = 107, // native Express ad, render timeout

    ABUErrorCodeSDKStop                     = 1000, // SDK stop forcely

    ABUErrorCodeParamError                  = 10001, // parameter error
    ABUErrorCodeTimeout                     = 10002,

    ABUErrorCodeSuccess                     = 20000,
    ABUErrorCodeNOAD                        = 20001, // no ads

    ABUErrorCodeContentType                 = 40000, // http conent_type error
    ABUErrorCodeRequestPBError              = 40001, // http request pb error
    ABUErrorCodeAppEmpty                    = 40002, // request app can't be empty
    ABUErrorCodeWapEMpty                    = 40003, // request wap can't be empty
    ABUErrorCodeAdSlotEmpty                 = 40004, // missing ad slot description
    ABUErrorCodeAdSlotSizeEmpty             = 40005, // the ad slot size is invalid
    ABUErrorCodeAdSlotIDError               = 40006, // the ad slot ID is invalid
    ABUErrorCodeAdCountError                = 40007, // request the wrong number of ads
    ABUUnionAdImageSizeError                = 40008, // wrong image size
    ABUUnionAdSiteIdError                   = 40009, // Media ID is illegal
    ABUUnionAdSiteMeiaTypeError             = 40010, // Media type is illegal
    ABUUnionAdSiteAdTypeError               = 40011, // Ad type is illegal
    ABUUnionAdSiteAccessMethodError         = 40012,// Media access type is illegal and has been deprecated
    ABUUnionSplashAdTypeError               = 40013, // Code bit id is less than 900 million, but adType is not splash ad
    ABUUnionRedirectError                   = 40014, // The redirect parameter is incorrect
    ABUUnionRequestInvalidError             = 40015, // Media rectification exceeds deadline, request illegal
    ABUUnionAppSiteRelError                 = 40016, // The relationship between slot_id and app_id is invalid.
    ABUUnionAccessMethodError               = 40017, // Media access type is not legal API/SDK
    ABUUnionPackageNameError                = 40018, // Media package name is inconsistent with entry
    ABUUnionConfigurationError              = 40019, // Media configuration ad type is inconsistent with request
    ABUUnionRequestLimitError               = 40020, // The ad space registered by developers exceeds daily request limit
    ABUUnionSignatureError                  = 40021, // Apk signature sha1 value is inconsistent with media platform entry
    ABUUnionIncompleteError                 = 40022, // Whether the media request material is inconsistent with the media platform entry
    ABUUnionOSError                         = 40023, // The OS field is incorrectly filled
    ABUUnionLowVersion                      = 40024, // The SDK version is too low to return ads
    ABUErrorCodeAdPackageIncomplete         = 40025,// the SDK package is incomplete. It is recommended to verify the integrity of SDK package or contact technical support.
    ABUUnionMedialCheckError                = 40026, // Non-international account request for overseas delivery system
    ABUUnionSlotIDRenderMthodNoMatch        = 40029,// The rendering method for slot ID does not match.

    ABUErrorCodeSysError                    = 50001 // ad server error
};
