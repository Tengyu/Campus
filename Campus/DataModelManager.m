//
//  DataModelManager.m
//  Campus
//
//  Created by Tengyu Cai on 2014-07-07.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "DataModelManager.h"
#import "AppDelegate.h"

@implementation DataModelManager {
    NSManagedObjectContext *managedObjectContext;
}

+(DataModelManager*)sharedManager
{
    static DataModelManager *shareManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [DataModelManager new];
    });
    return shareManager;
}

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        managedObjectContext = appDelegate.managedObjectContext;
        
    }
    
    return self;
}


#pragma mark - Course

-(Course*)createCourse:(NSDictionary*)courseDic
{
    Course *course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:managedObjectContext];
    course.title = [NSString stringWithFormat:@"%@ %@", courseDic[@"subject"], courseDic[@"catalog_number"]];
    course.name = courseDic[@"title"];
    course.section = courseDic[@"section"];
    course.campus = courseDic[@"campus"];
    if (courseDic[@"examDate"]) course.examDate = courseDic[@"examDate"];
    if (courseDic[@"examLocation"]) course.examLocation = courseDic[@"examLocation"];
    
    [self save];
    
    return course;
}

-(Course*)createCourse:(NSDictionary*)courseDic withClasses:(NSArray*)classArray
{
    Course *course = [self createCourse:courseDic];
    
    for (NSDictionary *classDic in classArray) {
        [self createClasss:classDic forCourse:course];
    }
    
    [self save];
    
    return course;
}

-(NSArray*)getAllCourses
{
    return [self getAll:@"Course"];
}

-(void)deleteCourse:(Course*)course
{
    [self delete:course];
    [self save];
}

#pragma mark - Class

-(Classs*)createClasss:(NSDictionary*)classDic
{
    Classs *classs = [NSEntityDescription insertNewObjectForEntityForName:@"Classs" inManagedObjectContext:managedObjectContext];
    classs.building = classDic[@"building"];
    classs.room = classDic[@"room"];
    classs.instructor = classDic[@"instructor"];
    classs.starthour = classDic[@"startHour"];
    classs.startmin = classDic[@"startMin"];
    classs.endhour = classDic[@"endHour"];
    classs.endmin = classDic[@"endMin"];
    classs.day = classDic[@"day"];
    classs.latitude = classDic[@"latitude"];
    classs.longitude = classDic[@"longitude"];
    
    [self save];
    
    return classs;
}

-(Classs*)createClasss:(NSDictionary*)classDic forCourse:(Course*)course
{
    Classs *classs = [self createClasss:classDic];
    [course addClassesObject:classs];
    
    [self save];
    
    return classs;
}

-(NSArray*)getAllClasses
{
    return [self getAll:@"Classs"];
}

#pragma mark - General


-(NSArray*)getAll:(NSString*)entity{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity];
    
    NSError *error;
    NSArray *managedObjectsArray = [managedObjectContext executeFetchRequest:request error:&error];
    
    return managedObjectsArray;
    
}

-(void)delete:(NSManagedObject*)object
{
    [managedObjectContext deleteObject:object];
    [self save];
}

-(void)save
{
    NSError *_error;
    [managedObjectContext save:&_error];
    if (_error) {
        NSLog(@"%@",_error);
    }
    
}
@end
