//
//  AddEventsViewController.m
//  Campus
//
//  Created by Tengyu Cai on 2014-06-29.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "AddEventsViewController.h"

@implementation AddEventsViewController

- (id)init
{
    self = [super init];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"events.png"];
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"Events" image:image tag:2];//  initWithTitle:@"Courses" image:nil tag:0];
        [self setTabBarItem:item];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    UILabel *label = [UILabel new];
    label.frame = (CGRect){0, SVB.size.height/2-50/2, SVB.size.width, 50};
    label.text = @"Coming this winter...";
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
}


@end
