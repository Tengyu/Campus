//
//  FriendsViewController.m
//  Campus
//
//  Created by Tengyu Cai on 2014-06-29.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "FriendsViewController.h"

@implementation FriendsViewController

- (id)init
{
    self = [super init];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"friends.png"];
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"Friends" image:image tag:3];//  initWithTitle:@"Courses" image:nil tag:0];
        [self setTabBarItem:item];
    }
    
    return self;
}



@end
