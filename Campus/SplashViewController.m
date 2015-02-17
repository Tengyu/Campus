//
//  SplashViewController.m
//  Campus
//
//  Created by Tengyu Cai on 2014-07-13.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "SplashViewController.h"
#import "CommonViewController.h"
#import "AppDelegate.h"

@interface SplashViewController ()

@end

@implementation SplashViewController {
    UIImageView *logoView;
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = TabBarBlue;
    
    logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splash_logo"]];
    logoView.frame = (CGRect){SVF.size.width/2-logoView.bounds.size.width/2, SVF.size.height/2-logoView.bounds.size.height/2, logoView.bounds.size};
    [self.view addSubview:logoView];
    
}

- (void)transition
{
    [UIView animateWithDuration:0.7 delay:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
        
        logoView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            logoView.transform = CGAffineTransformMakeScale(4, 4);
            logoView.alpha = 0.3;
        } completion:^(BOOL finished) {
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] transitionFromSplash];
        }];
        
    }];
    
}

@end
