//
//  CourseFetcher.m
//  Campus
//
//  Created by Tengyu Cai on 2014-07-06.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "CourseFetcher.h"
#import "UWAPI.h"

@implementation CourseFetcher

+(NSURL*)URLForQuery:(NSString *)query
{
    query = [NSString stringWithFormat:@"%@?key=%@",query,UWAPIKey];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [[NSURL alloc] initWithString:query];
    return url;
}


+(NSURL*)URLForSubject:(NSString *)subject catalogNum:(NSString *)catalogNum exam:(BOOL)exam
{
    if (exam) {
        return [self URLForQuery:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/courses/%@/%@/examschedule.json",subject,catalogNum]];
    } else {
        return [self URLForQuery:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/courses/%@/%@/schedule.json",subject,catalogNum]];
    }
}

+(NSURL*)URLForBuilding:(NSString *)buildingCode
{
    return [self URLForQuery:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/buildings/%@.json",buildingCode]];
}


@end
