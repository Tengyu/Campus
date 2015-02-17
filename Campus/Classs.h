//
//  Classs.h
//  Campus
//
//  Created by Tengyu Cai on 2014-07-13.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface Classs : NSManagedObject

@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * room;
@property (nonatomic, retain) NSString * instructor;
@property (nonatomic, retain) NSNumber * starthour;
@property (nonatomic, retain) NSNumber * startmin;
@property (nonatomic, retain) NSNumber * endhour;
@property (nonatomic, retain) NSNumber * endmin;
@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * building;
@property (nonatomic, retain) Course *course;

@end
