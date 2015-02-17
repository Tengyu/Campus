//
//  Course.h
//  Campus
//
//  Created by Tengyu Cai on 2014-07-13.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Classs;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * section;
@property (nonatomic, retain) NSString * campus;
@property (nonatomic, retain) NSDate * examDate;
@property (nonatomic, retain) NSString * examLocation;
@property (nonatomic, retain) NSSet *classes;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addClassesObject:(Classs *)value;
- (void)removeClassesObject:(Classs *)value;
- (void)addClasses:(NSSet *)values;
- (void)removeClasses:(NSSet *)values;

@end
