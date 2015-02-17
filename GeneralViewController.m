//
//  GeneralViewController.m
//  Campus
//
//  Created by Tengyu Cai on 2014-06-29.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "GeneralViewController.h"
#import "DataModelManager.h"

@interface GeneralViewController () <UITableViewDelegate, UITableViewDataSource>

@end


@implementation GeneralViewController {
    UITableView *mainTableView;
}

- (id)init
{
    self = [super init];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"menu.png"];
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"General" image:image tag:0];//  initWithTitle:@"Courses" image:nil tag:0];
        [self setTabBarItem:item];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    float y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    mainTableView = [[UITableView alloc] initWithFrame:(CGRect){0, y, SVB.size.width, SVB.size.height-y} style:UITableViewStyleGrouped];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"general"];
    mainTableView.backgroundColor = CCOLOR;
    [self.view addSubview:mainTableView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //[mainTableView reloadData];
}

#pragma mark - Action

-(void)notificationAction:(UISwitch*)mySwitch
{
    
}


#pragma mark - TableView

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"general" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Manage Classes";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *courseNumLabel = [[UILabel alloc] initWithFrame:(CGRect){270, 44/2-20/2, 20, 20}];
            //courseNumLabel.backgroundColor = Red;
            courseNumLabel.text = [NSString stringWithFormat:@"%d", [DMM getAllCourses].count];
            courseNumLabel.textColor = [UIColor grayColor];
            [cell.contentView addSubview:courseNumLabel];
            cell.imageView.image = [UIImage imageNamed:@"courses-25"];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Manage Events";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *courseNumLabel = [[UILabel alloc] initWithFrame:(CGRect){270, 44/2-20/2, 20, 20}];
            //courseNumLabel.backgroundColor = Red;
            courseNumLabel.text = @"0";
            courseNumLabel.textColor = [UIColor grayColor];
            [cell.contentView addSubview:courseNumLabel];
            cell.imageView.image = [UIImage imageNamed:@"gift-25"];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Notification";
            UISwitch *notificationSwitch = [[UISwitch alloc] init];
            notificationSwitch.frame = (CGRect){0, 0, notificationSwitch.bounds.size};
            [notificationSwitch addTarget:self action:@selector(notificationAction:) forControlEvents:UIControlEventEditingChanged];
            cell.accessoryView = notificationSwitch;
            cell.imageView.image = [UIImage imageNamed:@"speech_bubble-25"];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


@end
