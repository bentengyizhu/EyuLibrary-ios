//
//  ABUSplashZoomOutView.h
//  ABUAdSDK
//
//  Created by CHAORS on 2021/4/22.
//

#import <UIKit/UIKit.h>

#import "ABUZoomOutSplashAdDelegate.h"


@interface ABUSplashZoomOutView : UIView

/**
 The delegate for receiving state change messages When it is a zoom out advertisement.
 */
@property (nonatomic, weak, nullable) id<ABUZoomOutSplashAdDelegate> delegate;

/*
Root view controller for handling ad actions.
*/
@property (nonatomic, strong, nullable) UIViewController *rootViewController;

/**
Suggested size for show.
*/
@property (nonatomic, assign, readonly) CGSize suggestedSize;

@end

