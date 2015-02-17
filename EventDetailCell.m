//
//  EventDetailCell.m
//  Campus
//
//  Created by Tengyu Cai on 2014-06-14.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "EventDetailCell.h"
#import "Course.h"
#import "CommonViewController.h"
#import "CourseFetcher.h"
#import "LocationManager.h"

#define DetailWhite RGB(245, 250, 255)

#define CellDetailHeight 180

@interface EventDetailCell () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@end

@implementation EventDetailCell {
    UILabel *titlelabel;
    UILabel *locationLabel;
    UILabel *distanceLabel;
    UILabel *timeNumLabel;
    UILabel *timeUnitLabel;
    
    NSDictionary *examDic;
    
    //BOOL detailMode;
    UIView *detailBackgroundView;
    UITableView *eventDetailTableView;
    UIImageView *logoView;
    
    UIScrollView *contentView;
    UIPageControl *pageControl;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = Blue;
        self.past = NO;
        
        float leftEdge = 15;
        float topEdge = 20;
        float mainLabelHeight = 35;
        float subLabelHeight = 20;
        
        titlelabel = [UILabel new];
        titlelabel.frame = (CGRect){leftEdge, topEdge, 210, mainLabelHeight};
        titlelabel.textColor = [UIColor whiteColor];
        titlelabel.textAlignment = NSTextAlignmentLeft;
        titlelabel.font = [UIFont fontWithName:@"Helvetica-Light" size:40];
        //titlelabel.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:titlelabel];
        
        float y = CGRectGetMaxY(titlelabel.frame)+5;
        
        UIImageView *pinpointView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"locationwhite"]];
        pinpointView.frame = (CGRect){leftEdge+5/2, y+5/2, subLabelHeight-5, subLabelHeight-5};
        [self.contentView addSubview:pinpointView];
        
        float x = CGRectGetMaxX(pinpointView.frame);
        
        locationLabel = [UILabel new];
        locationLabel.frame = (CGRect){x, y, 95, subLabelHeight};
        locationLabel.textColor = [UIColor whiteColor];
        locationLabel.textAlignment = NSTextAlignmentLeft;
        //locationLabel.text = @"MC 1234";
        locationLabel.font = [UIFont systemFontOfSize:14];
        //locationLabel.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:locationLabel];
        
        x = CGRectGetMaxX(locationLabel.frame);
        
        UIImageView *walkingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"walking"]];
        walkingView.frame = (CGRect){x+5/2, y+5/2, subLabelHeight-5, subLabelHeight-5};
        walkingView.tintColor = RGB(165, 230, 225);
        [self.contentView addSubview:walkingView];
        
        x = CGRectGetMaxX(walkingView.frame);
        
        distanceLabel = [UILabel new];
        distanceLabel.frame = (CGRect){x, y, 85, subLabelHeight};
        distanceLabel.textColor = RGB(165, 230, 225);
        distanceLabel.textAlignment = NSTextAlignmentLeft;
        distanceLabel.text = @"Calculating...";
        distanceLabel.font = [UIFont systemFontOfSize:14];
        //distanceLabel.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:distanceLabel];
        
        x = CGRectGetMaxX(titlelabel.frame)+0.2;
        
        timeNumLabel = [UILabel new];
        timeNumLabel.frame = (CGRect){x, topEdge, self.frame.size.width-leftEdge-titlelabel.frame.size.width-15, mainLabelHeight};
        timeNumLabel.textColor = [UIColor whiteColor];
        timeNumLabel.textAlignment = NSTextAlignmentCenter;
        timeNumLabel.text = @"100";
        timeNumLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:40];
        //timeNumLabel.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:timeNumLabel];
        
        
        timeUnitLabel = [UILabel new];
        timeUnitLabel.frame = (CGRect){x, y, self.frame.size.width-leftEdge-titlelabel.frame.size.width-15, subLabelHeight};
        timeUnitLabel.textColor = [UIColor whiteColor];
        timeUnitLabel.textAlignment = NSTextAlignmentCenter;
        //timeUnitLabel.text = @"MINS";
        timeUnitLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        //timeUnitLabel.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:timeUnitLabel];
        
        y = 90;
        
        contentView = [UIScrollView new];
        contentView.delegate = self;
        contentView.frame = (CGRect){0, y, 640, CellDetailHeight};
        contentView.pagingEnabled=YES;
        contentView.scrollEnabled = YES;
        contentView.userInteractionEnabled = YES;
        contentView.showsHorizontalScrollIndicator = YES;
        contentView.backgroundColor = Red;
        [self.contentView addSubview:contentView];
        
        
        detailBackgroundView = [UIView new];
        detailBackgroundView.backgroundColor = DetailWhite;
        detailBackgroundView.frame = (CGRect){0, 0, self.bounds.size.width, CellDetailHeight};
        [contentView addSubview:detailBackgroundView];
        
        UIView *tmp = [UIView new];
        tmp.backgroundColor = BlueGreen;
        tmp.frame = (CGRect){0, 320, self.bounds.size.width, CellDetailHeight};
        [contentView addSubview:tmp];
        
        //PageControl
        pageControl = [UIPageControl new];
        pageControl.frame = (CGRect){0, y+CellDetailHeight-10 ,320,10};
        //pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [pageControl addTarget:self action:@selector(pageControlAction) forControlEvents:UIControlEventValueChanged];
        pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageControl.numberOfPages = 2;
        //pageControl.backgroundColor = [UIColor blackColor];
        //[self.contentView addSubview:pageControl];
        
        logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uwaterloologo"]];
        logoView.frame = (CGRect){180, 30, 120, 30};
//        float width = 280;
//        float height = logoView.bounds.size.height/logoView.bounds.size.width*320;
//        logoView.frame = (CGRect){detailBackgroundView.bounds.size.width/2-width/2, CellDetailHeight/2-height/2, width, height};
//        logoView.alpha = 0.1;
//        logoView.autoresizingMask = FLEX_SIZE;
        [detailBackgroundView addSubview:logoView];
        
        eventDetailTableView = [[UITableView alloc] initWithFrame:detailBackgroundView.bounds style:UITableViewStyleGrouped];
        eventDetailTableView.delegate = self;
        eventDetailTableView.dataSource = self;
        [eventDetailTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EventDetail"];
        eventDetailTableView.backgroundColor = CCOLOR;
        eventDetailTableView.separatorColor = CCOLOR;
        eventDetailTableView.bounces = NO;
        //[detailBackgroundView addSubview:eventDetailTableView];
        
        UIImageView *shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow"]];
        shadowView.frame = (CGRect){0,-50,320,100};
        [detailBackgroundView addSubview:shadowView];
        detailBackgroundView.clipsToBounds = YES;
        
        UIImageView *reverseShadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow-reverse"]];
        reverseShadowView.frame = (CGRect){0,CellDetailHeight-100+50,320,100};
        [detailBackgroundView addSubview:reverseShadowView];
        
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)viewDidLayoutSubviews
{
    contentView.contentSize = (CGSize){self.bounds.size.width*2,0};
}

-(void)update
{
    [eventDetailTableView reloadData];
}

- (void)setClasss:(Classs *)classs
{
    _classs = classs;
    titlelabel.text = _classs.course.title;
    locationLabel.text = [NSString stringWithFormat:@"%@ %@", _classs.building, _classs.room];
    timeNumLabel.text = [NSString stringWithFormat:@"%.00f", [self calculateTimeLabelValue]];
    
    //NSLog(@"%@, %@", _classs.course.name, [_classs.course.section substringToIndex:3]);
    
    if ([[_classs.course.section substringToIndex:3] isEqualToString:@"TUT"]) {
        self.backgroundColor = Red;
    } else if ([[_classs.course.section substringToIndex:3] isEqualToString:@"LEC"]) {
        self.backgroundColor = Blue;
    }
    [self updateDistance];
    [eventDetailTableView reloadData];
}

#pragma mark - Action

-(void)pageControlAction
{
    [contentView setContentOffset:(CGPoint){pageControl.currentPage*contentView.bounds.size.width,0} animated:YES];
}

#pragma mark - ScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageControl.currentPage = scrollView.contentOffset.x/scrollView.bounds.size.width;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = contentView.frame.size.width;
    int page = floor((contentView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}



#pragma mark - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventDetail" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = CCOLOR;
    cell.backgroundView.backgroundColor = CCOLOR;
    cell.backgroundColor = CCOLOR;
    if (indexPath.row == 0) {
        
        cell.imageView.image = [UIImage imageNamed:@"one"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", _classs.course.section];
        cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        cell.imageView.contentMode = UIViewContentModeCenter;
        
    } if (indexPath.row == 1) {
        
        cell.imageView.image = [UIImage imageNamed:@"cal"];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
        NSInteger today = (weekdayComponents.weekday + 6) % 7;
        NSString *day;
        if (today == _classs.day.intValue) {
            day = @"Today";
        } else {
            switch (_classs.day.intValue) {
                case 1:
                    day = @"MON";
                    break;
                case 2:
                    day = @"TUE";
                    break;
                case 3:
                    day = @"WED";
                    break;
                case 4:
                    day = @"THU";
                    break;
                case 5:
                    day = @"FRI";
                    break;
                case 6:
                    day = @"SAT";
                    break;
                case 7:
                    day = @"SUN";
                    break;
                default:
                    break;
            }
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@:%02d - %@:%02d", day, _classs.starthour, _classs.startmin.intValue, _classs.endhour, _classs.endmin.intValue];
        cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        
    } else if (indexPath.row == 2) {
        
        cell.imageView.image = [UIImage imageNamed:@"location"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@", _classs.course.campus, _classs.building, _classs.room];
        cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        
    } else if (indexPath.row == 3) {
        
        if ([_classs.instructor isEqualToString:@""]) {
            cell.textLabel.text = @"Unknown";
        } else {
            NSInteger surnameIndex = 0;
            NSInteger firstnameIndex = 0;
            for (NSInteger i = 0; i < _classs.instructor.length ; ++i) {
                char c = [_classs.instructor characterAtIndex:i];
                if (c == ','){
                    surnameIndex = i;
                    firstnameIndex = i+1;
                    break;
                }
            }
            NSString *surname = [_classs.instructor substringToIndex:surnameIndex];
            NSString *firstname = [_classs.instructor substringFromIndex:firstnameIndex];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", firstname, surname];
        }
        cell.imageView.image = [UIImage imageNamed:@"user"];
        cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        
    } else if (indexPath.row == 4) {
        
        cell.imageView.image = [UIImage imageNamed:@"time"];
        
        if (!_classs.course.examLocation) {
            cell.textLabel.text = @"Exam Schedule TBA";
        } else if (!_classs.course.examDate) {
            cell.textLabel.text = _classs.course.examLocation;
        } else {
            int countDown = [self examCountDown:_classs.course.examDate];
            cell.textLabel.text = [NSString stringWithFormat:@"Exam in %d days at %@", countDown, _classs.course.examLocation];
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UILabel *classNameLabel = [UILabel new];
        classNameLabel.frame = (CGRect){10,0,320-2*10,30};
        classNameLabel.backgroundColor = CCOLOR;
        classNameLabel.text = _classs.course.name;
        classNameLabel.textAlignment = NSTextAlignmentCenter;
        classNameLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
        return classNameLabel;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


#pragma mark - location

- (void)updateDistance
{
    float destinationLatitude = _classs.latitude.floatValue;
    float destinationLongitude = _classs.longitude.floatValue;
    CLLocation *destination = [[CLLocation alloc] initWithLatitude:destinationLatitude longitude:destinationLongitude];
    CLLocation *currentLocation = [LM currentLocation];
    
    CLLocationDistance distance = [currentLocation distanceFromLocation:destination];
    NSString *dis = distance > 1000 ? [NSString stringWithFormat:@"%.02f km", distance/1000] : [NSString stringWithFormat:@"%.0f m", distance];
    distanceLabel.text = dis;
}


#pragma mark - helper

-(NSDateComponents *)getCurrentDateTime
{
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSHourCalendarUnit + NSMinuteCalendarUnit + NSSecondCalendarUnit + NSWeekdayCalendarUnit + NSDayCalendarUnit fromDate:now];
    return comps;
    
}

-(float)calculateTimeLabelValue
{
    NSDateComponents *today = [self getCurrentDateTime];
    int curMin = today.hour * 60 + today.minute;
    int startMin = _classs.starthour.intValue * 60 + _classs.startmin.intValue;
    int dayOffset = _classs.day.intValue - ((today.weekday+ 6) % 7);
    dayOffset = dayOffset < 0 ? dayOffset + 7 : dayOffset;
    float minOffset = dayOffset * 24 * 60 + (startMin - curMin);
    
    //NSLog(@"%f", minOffset);
    
    if (minOffset < 0) {
        self.past = YES;
        //NSLog(@"%@", _classs.course.name);
    }
    
    if (abs(minOffset) <= 90) {
        timeUnitLabel.text = @"MINS";
        return minOffset;
    } else {
        minOffset /= 60;
        if (abs(minOffset) <= 24) {
            timeUnitLabel.text = @"HRS";
            return minOffset;
        } else {
            timeUnitLabel.text = dayOffset <= 1 ? @"DAY" : @"DAYS";
            return dayOffset;
        }
    }
}

-(double)examCountDown:(NSDate*)examDate
{
    NSDate *today = [NSDate date];
    NSTimeInterval timeInterval = [examDate timeIntervalSinceDate:today];
    double minutes = timeInterval / 60;
    double hours = minutes / 60;
    double days = hours / 24;
    return days;
}

@end
