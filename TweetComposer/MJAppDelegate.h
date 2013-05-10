//
//  MJAppDelegate.h
//  TweetComposer
//
//  Created by gimix on 5/9/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJTweetComposerViewController;

@interface MJAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MJTweetComposerViewController *viewController;

@end
