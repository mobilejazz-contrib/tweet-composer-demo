//
//  MJTwitterText.h
//  TweetComposer
//
//  Created by gimix on 5/10/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Wrapper for the twitter-text.js library
 @see https://github.com/twitter/twitter-text-js
 */
@interface MJTwitterText : NSObject

/** Uses twttr.txt.extractUrls to get the URLs in the text and computes the
 * resulting length after shortening.
 */
-(UInt16)lengthAfterShortening:(NSString*)text tcoUrlLength:(int)tcoUrlLength;

@end
