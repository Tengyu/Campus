//
//  FeedbackViewController.m
//  Campus
//
//  Created by Tengyu Cai on 2014-07-13.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController () <UITextViewDelegate>

@end

@implementation FeedbackViewController {
    UITextView *textView;
}


- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = BackgroundWhite;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendAction)];
    sendButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = sendButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    float y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    float x = 20;
    
    textView = [[UITextView alloc] initWithFrame:(CGRect){x, y, SVB.size.width-2*x, SVB.size.height-y}];
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    textView.font = [UIFont systemFontOfSize:16];
    textView.delegate = self;
    textView.backgroundColor = CCOLOR;
    [self.view addSubview:textView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [textView becomeFirstResponder];
    
}

#pragma mark - Action

-(void)sendAction
{
    
}

#pragma mark - uitextview delegate

-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}



@end
