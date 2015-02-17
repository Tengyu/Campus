//
//  CourseFetcher.h
//  Campus
//
//  Created by Tengyu Cai on 2014-07-06.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseFetcher : NSObject

+(NSURL*)URLForSubject:(NSString *)subject catalogNum:(NSString *)catalogNum exam:(BOOL)exam;
+(NSURL*)URLForBuilding:(NSString *)buildingCode;

@end
