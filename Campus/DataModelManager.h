//
//  DataModelManager.h
//  Campus
//
//  Created by Tengyu Cai on 2014-07-07.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"
#import "Classs.h"

#define DMM [DataModelManager sharedManager]

@interface DataModelManager : NSObject

+(DataModelManager*)sharedManager;

-(void)save;

-(void)deleteCourse:(Course*)course;
-(Course*)createCourse:(NSDictionary*)courseDic withClasses:(NSArray*)classArray;
-(NSArray*)getAllCourses;
-(NSArray*)getAllClasses;

@end
