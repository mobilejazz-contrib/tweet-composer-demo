//
//  MJTwitterText.m
//  TweetComposer
//
//  Created by gimix on 5/10/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJTwitterText.h"
#import <JavaScriptCore/JavaScriptCore.h>

// using this: http://www.phoboslab.org/log/2011/06/javascriptcore-project-files-for-ios
// documentation: http://developer.apple.com/library/mac/#documentation/Carbon/Reference/WebKit_JavaScriptCore_Ref/index.html

@interface MJTwitterText() {
    JSGlobalContextRef context;
    JSObjectRef lengthAferShorteningFn;
}
@end

@implementation MJTwitterText

-(id)init
{
    self = [super init];
    if(self != nil) {
        // load twitter-text.js to a string
        NSError * error = nil;
        NSURL* url = [[NSBundle mainBundle] URLForResource:@"twitter-text" withExtension:@"js"];
        NSString* source = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        if(error != nil) return nil;
        
        // create a JS context
        JSValueRef exception = NULL;
        context = JSGlobalContextCreate(NULL);
        // evaluate the string
        JSStringRef sourceJS = JSStringCreateWithUTF8CString([source UTF8String]);
        JSEvaluateScript(context, sourceJS, NULL, NULL, 0, &exception);
        if(exception != nil) return nil;
        
        // make lengthAferShorteningFn function
        {
            NSString * script =  @"var text = arguments[0];"
            @"var tcoLength = arguments[1];"
            @"var urls = twttr.txt.extractUrls(text);"
            @"var total = text.length;"
            @"for(var i=0; i<urls.length; i++) {"
            @"  var url = urls[i];"
            @"  total -= url.length;"
            @"  total += tcoLength;"
            @"  if(url.indexOf('https://') == 0)" // HTTPS URL case
            @"    total ++;"
            @"}"
            @"return total;";
            
            JSStringRef scriptJS = JSStringCreateWithUTF8CString([script UTF8String]);
            lengthAferShorteningFn = JSObjectMakeFunction(context, NULL, 0, NULL, scriptJS, NULL, 1, &exception);
            JSStringRelease(scriptJS);
            if(exception != nil) { [self logException:exception]; return 0; }
        }
    }
    return self;
}

-(UInt16)lengthAfterShortening:(NSString*)text tcoUrlLength:(int)tcoUrlLength
{
    JSValueRef exception = NULL;
    const int NARGS = 2;
    // arguments
    JSValueRef arguments[NARGS];
	arguments[0] = JSValueMakeString(context, JSStringCreateWithUTF8CString([text UTF8String])); // text, keeps ownership of the string
    arguments[1] = JSValueMakeNumber(context, tcoUrlLength); // tcoLength
    
    // run
	JSValueRef resultJS = JSObjectCallAsFunction(context, lengthAferShorteningFn, NULL, NARGS, arguments, &exception);
    if(exception != nil) { [self logException:exception]; return 0; }
    
	// get result
	double result = JSValueToNumber(context, resultJS, &exception);
    if(exception != nil) { [self logException:exception]; return 0; }
    
    return result;
}

#pragma mark - Helpers
-(void)logException:(JSValueRef)exception
{
    JSStringRef jstrArg = JSValueToStringCopy(context, exception, NULL); // make a string of the exception
    NSString * description = (__bridge NSString*)JSStringCopyCFString(kCFAllocatorDefault, jstrArg); // make an NSString
    JSStringRelease(jstrArg);
    NSLog(@"Exception while evaluating Javascript: %@", description);
}

@end
