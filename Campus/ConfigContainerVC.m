//
//  ConfigContainerVC.m
//  Campus
//
//  Created by Tengyu Cai on 2014-06-29.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "ConfigContainerVC.h"

@implementation ConfigContainerVC

-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = BackgroundWhite;

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    doneButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = doneButton;
    

    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Campus";
    //titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.font = [UIFont fontWithName:@"Zapfino" size:16];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.frame = (CGRect){self.navigationController.navigationBar.bounds.size.width/2-150/2,self.navigationController.navigationBar.bounds.size.height/2-30/2,150,30};
    [self.navigationController.navigationBar addSubview:titleLabel];
}

#pragma mark - Action

-(void)doneAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}




@end
