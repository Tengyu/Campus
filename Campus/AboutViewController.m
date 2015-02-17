//
//  AboutViewController.m
//  Campus
//
//  Created by Tengyu Cai on 2014-06-29.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "AboutViewController.h"
#import "FeedbackViewController.h"
//#import <Instabug/Instabug.h>

@interface AboutViewController () <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>

@end

@implementation AboutViewController {
    UITableView *aboutTableView;
    
    UIImageView *developerView;
    UIImageView *designerView;
    UIWebView *linkedinView;
}

- (id)init
{
    self = [super init];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"about.png"];
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"About" image:image tag:4];//  initWithTitle:@"Courses" image:nil tag:0];
        [self setTabBarItem:item];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    float y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    
    aboutTableView = [[UITableView alloc] initWithFrame:(CGRect){0, y, SVB.size.width, SVB.size.height-y} style:UITableViewStyleGrouped];
    aboutTableView.backgroundColor = CCOLOR;
    aboutTableView.autoresizingMask = FLEX_SIZE;
    aboutTableView.delegate = self;
    aboutTableView.dataSource = self;
    [aboutTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"about"];
    [self.view addSubview:aboutTableView];
    
}

#pragma mark - Action

- (void)tapAction:(UITapGestureRecognizer*)gr
{
    NSString *urlAddress;
    if ([gr.view isEqual:developerView]) {
        urlAddress = @"http://www.linkedin.com/in/tengyucai";
    } else if ([gr.view isEqual:designerView]) {
        urlAddress = @"http://www.linkedin.com/in/lucaswang";
    }
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    linkedinView = [[UIWebView alloc] init];
    linkedinView.delegate = self;
    [linkedinView loadRequest:requestObj];
}

#pragma mark - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"about" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Rate Campus";
                break;
            case 1:
                cell.textLabel.text = @"Send Feedback";
                break;
            default:
                break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            
//            [Instabug setHeaderColor:TabBarBlue];
//            [Instabug setHeaderFontColor:[UIColor whiteColor]];
//            [Instabug setButtonsColor:CCOLOR];
//            [Instabug setButtonsFontColor:[UIColor whiteColor]];
//            [Instabug setTextBackgroundColor:BackgroundWhite];
//            [Instabug setWillShowTutorialAlert:NO];
//            [Instabug setCommentIsRequired:YES];
//            [Instabug setEmailIsRequired:NO];
//            [Instabug setWillShowEmailField:YES];
//            [Instabug setEmailPlaceholder:@"Enter your email...(Optional)"];
//            [Instabug showFeedbackFormWithScreenshotAnnotation:NO];
            FeedbackViewController *feedbackVC = [FeedbackViewController new];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SVB.size.width,160}];
    //view.backgroundColor = Red;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_square"]];
    imageView.frame = (CGRect){SVF.size.width/2-120/2, 10, 120, 100};
    //imageView.backgroundColor = Red;
    
    float y = CGRectGetMaxY(imageView.frame);
    
    UILabel *versionLabel = [UILabel new];
    versionLabel.frame = (CGRect){SVF.size.width/2-100/2, y, 100, 20};
    versionLabel.text = @"Version 0.1";
    //versionLabel.backgroundColor = Blue;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont systemFontOfSize:12];
    versionLabel.textColor = RGB(140, 140, 140);
    
    y = CGRectGetMaxY(versionLabel.frame);
    
    UILabel *dateLabel = [UILabel new];
    dateLabel.frame = (CGRect){SVF.size.width/2-200/2, y, 200, 20};
    dateLabel.text = @"Release Date: July 15, 2014";
    //dateLabel.backgroundColor = Blue;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.font = [UIFont systemFontOfSize:12];
    dateLabel.textColor = RGB(140, 140, 140);
    
    [view addSubview:imageView];
    [view addSubview:versionLabel];
    [view addSubview:dateLabel];
    
    return view;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0, 0, SVB.size.width, 100}];
    
    float x = 70;
    float y = 20;
    float imageWidth = 50;
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    developerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kevincai"]];
    developerView.frame = (CGRect){x, y, imageWidth, imageWidth};
    developerView.layer.cornerRadius = imageWidth/2;
    developerView.layer.masksToBounds = YES;
    developerView.userInteractionEnabled = YES;
    [developerView addGestureRecognizer:singleTap1];
    [view addSubview:developerView];
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    designerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lucaswang"]];
    designerView.frame = (CGRect){SVB.size.width-imageWidth-x, y, imageWidth, imageWidth};
    designerView.layer.masksToBounds = YES;
    designerView.layer.cornerRadius = imageWidth/2;
    designerView.userInteractionEnabled = YES;
    [designerView addGestureRecognizer:singleTap2];
    [view addSubview:designerView];
    
    y = CGRectGetMaxY(designerView.frame);
    x = 65;
    float labelWidth = 60;
    
    UILabel *developerLabel = [[UILabel alloc] initWithFrame:(CGRect){x, y, labelWidth, 20}];
    developerLabel.text = @"@kevincai";
    developerLabel.textAlignment = NSTextAlignmentCenter;
    developerLabel.textColor = [UIColor grayColor];
    developerLabel.font = [UIFont systemFontOfSize:12];
    [view addSubview:developerLabel];
    
    UILabel *designerLabel = [[UILabel alloc] initWithFrame:(CGRect){SVB.size.width-labelWidth-x, y, labelWidth, 20}];
    designerLabel.text = @"@wzti";
    designerLabel.textAlignment = NSTextAlignmentCenter;
    designerLabel.textColor = [UIColor grayColor];
    designerLabel.font = [UIFont systemFontOfSize:12];
    [view addSubview:designerLabel];
    
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 160;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

#pragma mark - Web View

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [[UIApplication sharedApplication] openURL:[request URL]];
    return NO;
}

@end
