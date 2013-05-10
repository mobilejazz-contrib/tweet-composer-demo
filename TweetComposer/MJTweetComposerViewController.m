//
//  MJTweetComposerViewController.m
//  TweetComposer
//
//  Created by gimix on 5/9/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJTweetComposerViewController.h"
#import "MJTwitterText.h"

@interface MJTweetComposerViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *composerTextView;
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;

@property (strong, nonatomic) MJTwitterText* twitterText;

@end

@implementation MJTweetComposerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.twitterText = [[MJTwitterText alloc] init];
    [self updateCounter];
}

- (void)viewDidUnload {
    [self setComposerTextView:nil];
    [self setCounterLabel:nil];
    [super viewDidUnload];
}

- (void)textViewDidChange:(UITextView *)textView {
	[self updateCounter];
}

-(void)updateCounter {
    const int maxTweetLength = 140;
	int tweetLength = [self calculateTweetLength];
	
    // counter
    self.counterLabel.text = [NSString stringWithFormat:@"%d", maxTweetLength - tweetLength];
}

-(int)calculateTweetLength {
	NSString *tweet = self.composerTextView.text;
	int httpUrlLength = 20; //TODO let's guess it's 20. get from Twitter
    
    return [self.twitterText lengthAfterShortening:tweet tcoUrlLength:httpUrlLength];
}
@end
