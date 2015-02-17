//
//  AddCourseViewController.h
//  Campus
//
//  Created by Tengyu Cai on 2014-07-06.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "ConfigContainerVC.h"

@protocol AddCourseDelegate;

@interface AddCourseViewController : ConfigContainerVC

@property (nonatomic,weak) id <AddCourseDelegate> delegate;

@end


@protocol AddCourseDelegate <NSObject>

-(void)addCourseVCDidAddCourse:(NSDictionary*)courseDic withClasses:(NSArray*)classArray;

@end