//
//  EventDetailCell.h
//  Campus
//
//  Created by Tengyu Cai on 2014-06-14.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Classs.h"

@interface EventDetailCell : UITableViewCell

@property (strong, nonatomic) Classs *classs;
@property (nonatomic) BOOL past;

-(void)update;
-(void)updateDistance;

@end
