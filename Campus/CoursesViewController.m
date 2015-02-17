//
//  CoursesViewController.m
//  Campus
//
//  Created by Tengyu Cai on 2014-06-29.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "CoursesViewController.h"
#import "AddCourseViewController.h"
#import "DataModelManager.h"


@interface CoursesViewController () <UITableViewDataSource, UITableViewDelegate, AddCourseDelegate>

@end

@implementation CoursesViewController {
    UITableView *coursesTableView;
    NSMutableArray *courseArray;
    
    UIActivityIndicatorView *activityView;
}

- (id)init
{
    self = [super init];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"courses.png"];
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"Courses" image:image tag:1];
        [self setTabBarItem:item];
    }
    
    return self;
}

-(void)loadView
{
    [super loadView];

    courseArray = [DMM getAllCourses].mutableCopy;

    coursesTableView = [[UITableView alloc] initWithFrame:(CGRect){0, 100, SVB.size.width, SVB.size.height-100} style:UITableViewStylePlain];
    coursesTableView.autoresizingMask = FLEX_SIZE;
    coursesTableView.delegate = self;
    coursesTableView.dataSource = self;
    [coursesTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"xxx"];
    coursesTableView.backgroundColor = CCOLOR;
    coursesTableView.backgroundView =  nil;
    //coursesTableView.editing = YES;
    coursesTableView.tableFooterView = [[UIView alloc] initWithFrame:(CGRect){0,0,coursesTableView.bounds.size.width, 50}];
    [self.view addSubview:coursesTableView];
    
    UIButton *addButton = [CommonViewController button:@"add" target:self action:@selector(addAction)];
    addButton.frame = (CGRect){15, 15, addButton.bounds.size};
    [coursesTableView.tableFooterView addSubview:addButton];
    
    float x = CGRectGetMaxX(addButton.frame)+10;
    
    UILabel *addCourseLabel = [UILabel new];
    addCourseLabel.text = @"Add Course";
    addCourseLabel.textAlignment = NSTextAlignmentCenter;
    addCourseLabel.frame = (CGRect){x, 15, 100, addButton.bounds.size.height};
    [coursesTableView.tableFooterView addSubview:addCourseLabel];
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    coursesTableView.allowsMultipleSelectionDuringEditing = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [coursesTableView reloadData];
}


#pragma mark - Action

-(void)addAction
{
    AddCourseViewController *addCourseVC = [AddCourseViewController new];
    addCourseVC.delegate = self;
    [self.navigationController pushViewController:addCourseVC animated:YES];
}


#pragma mark - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xxx" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Course *course = courseArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", course.title, course.section];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Course *course = courseArray[indexPath.row];
        [DMM deleteCourse:course];
        courseArray = [DMM getAllCourses].mutableCopy;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return courseArray.count;
}


#pragma mark - AddCourseDelegate

-(void)addCourseVCDidAddCourse:(NSDictionary *)courseDic withClasses:(NSArray *)classArray
{
    [DMM createCourse:courseDic withClasses:classArray];
    courseArray = [DMM getAllCourses].mutableCopy;
}


@end
