//
//  AddCourseViewController.m
//  Campus
//
//  Created by Tengyu Cai on 2014-07-06.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "AddCourseViewController.h"
#import "CourseFetcher.h"
#import "DataModelManager.h"

@interface AddCourseViewController () <UITextFieldDelegate>

@end

@implementation AddCourseViewController {
    UITextField *nameField;
    UITextField *numField;
    UITextField *typeField;
    UITextField *sectionField;
    
    UIActivityIndicatorView *activityView;
}

-(void)loadView
{
    [super loadView];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    float x = 80;
    float y = 90;
    
    nameField = [[UITextField alloc] init];
    nameField.delegate = self;
    nameField.frame = (CGRect){x,y,SVB.size.width/2-75,40};
    nameField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    nameField.backgroundColor = RGB(220, 220, 220);
    nameField.borderStyle = UITextBorderStyleRoundedRect;
    nameField.textAlignment = NSTextAlignmentLeft;
    nameField.keyboardType = UIKeyboardTypeNamePhonePad;
    nameField.placeholder = @"MATH";
    [self.view addSubview:nameField];
    
    x = CGRectGetMaxX(nameField.frame)+10;
    
    numField = [[UITextField alloc] init];
    numField.delegate = self;
    numField.frame = (CGRect){x,y,SVB.size.width/2-95,40};
    numField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    numField.backgroundColor = RGB(220, 220, 220);
    numField.borderStyle = UITextBorderStyleRoundedRect;
    numField.textAlignment = NSTextAlignmentLeft;
    numField.placeholder = @"239";
    numField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.view addSubview:numField];
    
    y = CGRectGetMaxY(numField.frame)+10;
    x = 80;
    
    typeField = [[UITextField alloc] init];
    typeField.delegate = self;
    typeField.frame = (CGRect){x,y,SVB.size.width/2-75,40};
    typeField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    typeField.backgroundColor = RGB(220, 220, 220);
    typeField.borderStyle = UITextBorderStyleRoundedRect;
    typeField.textAlignment = NSTextAlignmentLeft;
    typeField.keyboardType = UIKeyboardTypeNamePhonePad;
    typeField.placeholder = @"LEC";
    [self.view addSubview:typeField];
    
    x = CGRectGetMaxX(typeField.frame)+10;
    
    sectionField = [[UITextField alloc] init];
    sectionField.delegate = self;
    sectionField.frame = (CGRect){x,y,SVB.size.width/2-95,40};
    sectionField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    sectionField.backgroundColor = RGB(220, 220, 220);
    sectionField.borderStyle = UITextBorderStyleRoundedRect;
    sectionField.textAlignment = NSTextAlignmentLeft;
    sectionField.placeholder = @"002";
    sectionField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:sectionField];
    
    y = CGRectGetMaxY(typeField.frame)+25;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = (CGRect){80, y, SVB.size.width-2*80,40};
    button.backgroundColor = TabBarBlue;
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [button addTarget:self action:@selector(addCourseAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Add Course" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];

    
}

-(void)viewDidAppear:(BOOL)animated
{
    [nameField becomeFirstResponder];
}

#pragma mark - Action

-(void)addCourseAction
{
    if (![self hasAllRequiredFields]) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"Fill all fields." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        return;
    }
    
    [self activity:YES];
    
    // fetch course info
    NSLog(@"%@ %@", nameField.text, numField.text);
    NSURL *url = [CourseFetcher URLForSubject:nameField.text catalogNum:numField.text exam:NO];
    NSData *json = [NSData dataWithContentsOfURL:url];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL];
    NSArray *courseArray = dic[@"data"];
    if (courseArray.count == 0) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"COURSE NOT FOUND" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        [self activity:NO];
        return;
    }
    NSString *object = [NSString stringWithFormat:@"%@ %@", typeField.text, sectionField.text];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"section == %@", object];
    
    // create courseDic and classArray
    NSArray *filtedArray = [courseArray filteredArrayUsingPredicate:predicate];
    if (filtedArray.count == 0) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"COURSE NOT FOUND" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        [self activity:NO];
        return;
    }
    NSMutableDictionary *tmpDic = filtedArray[0];
    NSMutableDictionary *courseDic = tmpDic.mutableCopy;

    // fetch course exam info & add to courseDic
    url = [CourseFetcher URLForSubject:courseDic[@"subject"] catalogNum:courseDic[@"catalog_number"] exam:YES];
    json = [NSData dataWithContentsOfURL:url];
    NSDictionary *examDic = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL][@"data"];
    if (examDic) {
        NSArray *examArray = examDic[@"sections"];
        NSDictionary *examScheduleDic = examArray[0];
        if (![examScheduleDic[@"notes"] isEqualToString:@""]) {
            courseDic[@"examLocation"] = examScheduleDic[@"notes"];
        } else {
            NSString *examDate = examScheduleDic[@"date"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [dateFormatter dateFromString:examDate];
            [courseDic setObject:examScheduleDic[@"location"] forKey:@"examLocation"];
            [courseDic setObject:date forKey:@"examDate"];
        }
    } else {
        
    }
    
    
    NSMutableArray *classArray = [self parseClasses:courseDic[@"classes"]].mutableCopy;
    for (NSMutableDictionary *class in classArray) {
        url = [CourseFetcher URLForBuilding:class[@"building"]];
        json = [NSData dataWithContentsOfURL:url];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL];
        NSDictionary *locationDic = dic[@"data"];
        if (locationDic) {
            [class setValue:locationDic[@"latitude"] forKey:@"latitude"];
            [class setValue:locationDic[@"longitude"] forKey:@"longitude"];
        }
    }
    
    if (_delegate) {
        [_delegate addCourseVCDidAddCourse:courseDic withClasses:classArray];
    }
    [self activity:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(NSArray*)parseClasses:(NSArray*)classArray
{
    NSMutableArray *newClassArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *classDic in classArray) {
        NSArray *daysArray = [self parseWeekdays:classDic[@"date"][@"weekdays"]];
        for (int i = 0; i < daysArray.count; ++i) {
            NSMutableDictionary *newClassDic = [[NSMutableDictionary alloc] init];
            
            // instructor & location
            newClassDic[@"instructor"] = [classDic[@"instructors"] count] ? classDic[@"instructors"][0] : @"";
            newClassDic[@"building"] = classDic[@"location"][@"building"];
            newClassDic[@"room"] = classDic[@"location"][@"room"];
            
            //date
            NSString *startTime = classDic[@"date"][@"start_time"];
            NSString *endTime = classDic[@"date"][@"end_time"];
            int startHour = [startTime substringWithRange:(NSRange){0,2}].intValue;
            int startMinute = [startTime substringWithRange:(NSRange){3,2}].intValue;
            int endHour = [endTime substringWithRange:(NSRange){0,2}].intValue;
            int endMinute = [endTime substringWithRange:(NSRange){3,2}].intValue;
            newClassDic[@"startHour"] = @(startHour);
            newClassDic[@"startMin"] = @(startMinute);
            newClassDic[@"endHour"] = @(endHour);
            newClassDic[@"endMin"] = @(endMinute);
            newClassDic[@"day"] = daysArray[i];
            
            [newClassArray addObject:newClassDic];
        }
    }
    
    return newClassArray;
}

-(NSArray*)parseWeekdays:(NSString*)weekdays
{
    NSMutableArray *daysArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < weekdays.length; ++i) {
        char day = [weekdays characterAtIndex:i];
        switch (day) {
            case 'M':
                [daysArray addObject:@(1)];
                break;
            case 'W':
                [daysArray addObject:@(3)];
                break;
            case 'F':
                [daysArray addObject:@(5)];
                break;
            case 'T':
                if (i+1 < weekdays.length && [weekdays characterAtIndex:i+1] == 'h') {
                    [daysArray addObject:@(4)];
                    ++i;
                } else {
                    [daysArray addObject:@(2)];
                }
                break;
            default:
                break;
        }
    }
    return daysArray;
}

#pragma mark - uitextfield delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == nameField || textField == typeField) {
        
        NSCharacterSet *blockedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
        if ([string rangeOfCharacterFromSet:blockedCharacters].location != NSNotFound) {
            return NO;
        }
        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:[string uppercaseString]];
        return NO;
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == nameField) {
        [numField becomeFirstResponder];
    } else if (textField == typeField) {
        [sectionField becomeFirstResponder];
    } else if (textField == numField) {
        [typeField becomeFirstResponder];
    }
    return YES;
}

-(BOOL)hasAllRequiredFields
{
    BOOL has = NO;
    
    if (nameField.text.length  && numField.text.length && typeField.text.length && sectionField.text.length) {
        has = YES;
    }
    return has;
}

@end
