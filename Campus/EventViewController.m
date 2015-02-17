//
//  EventViewController.m
//  Campus
//
//  Created by Tengyu Cai on 2014-06-14.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "EventViewController.h"
#import "EventDetailCell.h"
#import "GeneralViewController.h"
#import "CoursesViewController.h"
#import "AddEventsViewController.h"
#import "FriendsViewController.h"
#import "AboutViewController.h"
#import "DataModelManager.h"
#import "LocationManager.h"

#define CellDetailHeight 180

@interface EventViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation EventViewController {
    UIView *currentEventView;
    UITableView *eventTableView;
    UILabel *dateLabel;
    
    NSMutableArray *eventsArray;
    Classs *currentClass;
    
    UIImageView *topShadowView;
    UILabel *currentViewTitle;
    UILabel *currentViewTime;
    
    NSTimer *timer;
    
    int currentSelection;
}


- (void)loadView
{
    [super loadView];
    
    [self loadData];
    
    self.view.backgroundColor = TabBarBlue;
    
    UIBarButtonItem *configButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"config"] style:UIBarButtonItemStylePlain target:self action:@selector(configAction)];
    configButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = configButton;
    
    dateLabel = [UILabel new];
    dateLabel.frame = (CGRect){10,0,120,40};
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"EEE, MMM d"];
    dateLabel.text = [dateFormatter stringFromDate:date];
    dateLabel.font = [UIFont systemFontOfSize:20];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.textAlignment = NSTextAlignmentLeft;
    [self.navigationController.navigationBar addSubview:dateLabel];
    
    float y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
 
    eventTableView = [[UITableView alloc] initWithFrame:(CGRect){0,y,SVB.size.width,SVB.size.height-y} style:UITableViewStyleGrouped];
    eventTableView.autoresizingMask = FLEX_SIZE;
    eventTableView.delegate = self;
    eventTableView.dataSource = self;
    [eventTableView registerClass:[EventDetailCell class] forCellReuseIdentifier:@"xxx"];
    eventTableView.backgroundColor = CCOLOR;
    eventTableView.separatorColor = TabBarBlue;
    eventTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:eventTableView];
    
    y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    
    topShadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow"]];
    topShadowView.frame = (CGRect){0,y+50,SVB.size.width,100};
    
    currentEventView = [[UIView alloc] initWithFrame:(CGRect){0, y, SVB.size.width, 60}];
    currentEventView.backgroundColor = CurrentBlue;
    
    
    currentViewTitle = [UILabel new];
    currentViewTitle.frame = (CGRect){15, y, 210, 60};
    currentViewTitle.textColor = Blue;
    currentViewTitle.textAlignment = NSTextAlignmentLeft;
    currentViewTitle.text = [NSString stringWithFormat:@"%@", currentClass.course.title];
    currentViewTitle.font = [UIFont fontWithName:@"Helvetica-Light" size:40];
    //currentViewTitle.backgroundColor = [UIColor blackColor];
    
    currentViewTime = [UILabel new];
    currentViewTime.frame = (CGRect){230, y, 90, 60};
    currentViewTime.textColor = Blue;
    currentViewTime.textAlignment = NSTextAlignmentCenter;
    //currentViewTime.text = [NSString stringWithFormat:@"%d", pastMin];
    currentViewTime.font = [UIFont fontWithName:@"Helvetica-Light" size:40];
    //currentViewTime.backgroundColor = [UIColor blackColor];
    
//    y = CGRectGetMaxY(currentEventView.frame);
//    eventTableView.frame = rectY(eventTableView.frame, y);
//    eventTableView.frame = rectHeight(eventTableView.frame, SVB.size.height-y);
    
    //courseArray = [[NSMutableArray alloc] initWithObjects:@"CS 350", @"UWMCCF", @"Hacknight",@"CS 350", @"UWMCCF", @"Hacknight", nil];
    self.hasCurrentEvent = NO;
    currentSelection = -1;
    [LM startUpdatingLocation];
    [LM addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];
    [eventTableView reloadData];
    [self checkCurrentEvent];
    if (eventsArray.count) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:[eventsArray indexOfObject:currentClass]+1 inSection:0];
        [eventTableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)loadData
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger today = (weekdayComponents.weekday + 6) % 7;
    //NSLog(@"%d", today);
    
    NSMutableArray *classes = [DMM getAllClasses].mutableCopy;
    
    // sorted by day
    [classes sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Classs *class1 = (Classs*)obj1;
        Classs *class2 = (Classs*)obj2;
        
        int day1 = class1.day.intValue - today;
        day1 = day1 < 0 ? day1 + 7 : day1;
        int day2 = class2.day.intValue - today;
        day2 = day2 < 0 ? day2 + 7 : day2;
        
        if (day1 == day2) {
            
            int startHour1 = class1.starthour.intValue;
            int startHour2 = class2.starthour.intValue;
            
            if (startHour1 == startHour2) {
                
                int startMin1 = class1.startmin.intValue;
                int startMin2 = class2.startmin.intValue;
                return startMin1 > startMin2;
                
            } else {
                
                return startHour1 > startHour2;
                
            }
        } else {
            return day1 > day2;
        }
    }];
    
    eventsArray = classes;
    
//    for (Classs *class in classes) {
//        NSLog(@"%@ %@ %@ : %@", class.course.title, class.day, class.starthour, class.startmin);
//    }
    
}

#pragma mark - Action

-(void)tick:(NSTimer*)timer
{
    [eventTableView reloadData];
    [self checkCurrentEvent];
    [UIView animateWithDuration:2 animations:^{
        currentEventView.backgroundColor = BlueGreen;
        currentEventView.backgroundColor = CurrentBlue;
    }];
    
}



-(void)checkCurrentEvent
{
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    int pastMin = 0;
    for (NSInteger i = 0; i < eventsArray.count; ++i) {
        int pastMin = [self checkPastEvent:eventsArray[i]];
        //EventDetailCell *cell = (EventDetailCell*)[eventTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (pastMin < 0) {
            [cells addObject:eventsArray[i]];
            NSLog(@"%@", eventsArray[i]);
        }
    }
    NSLog(@"past cell: %d", cells.count);
    
    
    if (cells.count) {
        currentClass = cells.lastObject;
        //NSIndexPath *indexPath = [eventTableView indexPathForCell:currentCell];
//        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:[eventsArray indexOfObject:currentClass]+1 inSection:0];
//        [eventTableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        //pastMin = [self calculateCurrentEventTimeLabelValue];
        pastMin = [self checkPastEvent:currentClass];
        NSLog(@"past min: %d", pastMin);
        if (pastMin > 0 || pastMin < -200) {
            self.hasCurrentEvent = NO;
        } else {
            self.hasCurrentEvent = YES;
        }
    }
    //float y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    if (self.hasCurrentEvent) {
        
        [self.view addSubview:topShadowView];
        [self.view addSubview:currentEventView];
        [self.view addSubview:currentViewTitle];
        [self.view addSubview:currentViewTime];
        
        currentViewTitle.text = [NSString stringWithFormat:@"%@", currentClass.course.title];
        currentViewTime.text = [NSString stringWithFormat:@"%d", pastMin];
        
        float y = CGRectGetMaxY(currentEventView.frame);
        [UIView animateWithDuration:2 animations:^{
            currentEventView.alpha = 1;
            topShadowView.alpha = 1;
            currentViewTitle.alpha = 1;
            currentViewTime.alpha = 1;
            eventTableView.frame = rectY(eventTableView.frame, y);
        } completion:^(BOOL finished) {
            eventTableView.frame = rectHeight(eventTableView.frame, SVB.size.height-y);
        }];
        
    } else {
        float y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        eventTableView.frame = rectHeight(eventTableView.frame, SVB.size.height-y);
        [UIView animateWithDuration:2 animations:^{
            eventTableView.frame = rectY(eventTableView.frame, y);
            currentEventView.alpha = 0;
            topShadowView.alpha = 0;
            currentViewTitle.alpha = 0;
            currentViewTime.alpha = 0;
        } completion:^(BOOL finished) {
            [currentEventView removeFromSuperview];
            [topShadowView removeFromSuperview];
            [currentViewTitle removeFromSuperview];
            [currentViewTime removeFromSuperview];
        }];
    }
}

- (void)configAction
{
    GeneralViewController *generalVC = [GeneralViewController new];
    CoursesViewController *coursesVC = [CoursesViewController new];
    AddEventsViewController *addEventVC = [AddEventsViewController new];
    FriendsViewController *friendVC = [FriendsViewController new];
    AboutViewController *aboutVC = [AboutViewController new];
    UINavigationController *nv1 = [[UINavigationController alloc] initWithRootViewController:generalVC];
    UINavigationController *nv2 = [[UINavigationController alloc] initWithRootViewController:coursesVC];
    UINavigationController *nv3 = [[UINavigationController alloc] initWithRootViewController:addEventVC];
    UINavigationController *nv4 = [[UINavigationController alloc] initWithRootViewController:friendVC];
    UINavigationController *nv5 = [[UINavigationController alloc] initWithRootViewController:aboutVC];
    NSArray *controllerArray = [NSArray arrayWithObjects:nv1, nv2, nv3, nv5, nil];
    
    UITabBarController *tbvc = [[UITabBarController alloc] init];
    tbvc.viewControllers = controllerArray;
    
    [self presentViewController:tbvc animated:YES completion:nil];
}

#pragma mark - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xxx" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self loadData];
    cell.classs = eventsArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (currentSelection == indexPath.row) {
        currentSelection = -1;
    } else {
        currentSelection = indexPath.row;
        EventDetailCell *cell = (EventDetailCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.classs = eventsArray[indexPath.row];
    }

    [eventTableView beginUpdates];
    [eventTableView endUpdates];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If our cell is selected
    if (currentSelection == indexPath.row) {
        return 90 + CellDetailHeight;
    }
	
	// Cell isn't selected
	return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return eventsArray.count;
}

#pragma mark - location manager

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object  change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentLocation"]) {
        // do some stuff
        NSArray *cells = [eventTableView visibleCells];
        for (EventDetailCell *cell in cells) {
            [cell updateDistance];
        }
    }
}

#pragma mark - helper

-(int)checkPastEvent:(Classs*)eventDic
{
    NSDateComponents *today = [self getCurrentDateTime];
    
    int startMin = eventDic.starthour.intValue * 60 + eventDic.startmin.intValue;
    int endMin = eventDic.endhour.intValue * 60 + eventDic.endmin.intValue;
    //int timeSpan = endMin - startMin;
    
    int curMin = today.hour * 60 + today.minute;
    int dayOffset = eventDic.day.intValue - ((today.weekday+ 6) % 7);
    dayOffset = dayOffset >= 0 ? dayOffset : dayOffset+7;
    int minOffset = dayOffset * 24 * 60 + (startMin - curMin);
//    NSLog(@"%@", currentCell.classs);
//    NSLog(@"day offset: %d", dayOffset);
//    NSLog(@"min offset: %d", minOffset);
//    if (abs(minOffset) <= timeSpan || abs(minOffset) < 120) {
    return minOffset;
//    } else {
//        return 1;
//    }
}

@end
