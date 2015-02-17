//
//  CommonViewController.h
//  Campus
//
//  Created by Tengyu Cai on 2014-06-14.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

//Colors
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define CCOLOR [UIColor clearColor]

//Defined colors
#define TabBarBlue RGB(67, 143, 196)
#define CurrentBlue RGB(104, 166, 207)
#define WalkingGreen RGB(178, 228, 173)
#define Blue RGB(49, 123, 169)
#define BlueGreen RGB(63, 216, 181)
#define Red RGB(235, 103, 77)
#define BackgroundWhite RGB(235, 235, 240)

//Rect and alignment
#define rectX(rect,x) [CommonViewController rectWithRect:rect setX:x]
#define rectWidth(rect,width) [CommonViewController rectWithRect:rect setWidth:width]
#define rectHeight(rect,height) [CommonViewController rectWithRect:rect setHeight:height]
#define rectY(rect,y) [CommonViewController rectWithRect:rect setY:y]

//Resizing masks
#define FLEX_SIZE UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth

#define BUTTON  [UIButton buttonWithType:UIButtonTypeCustom];

#define SVB self.view.bounds
#define SVF self.view.frame

@interface CommonViewController : UIViewController



-(AppDelegate*)appDelegate;


+(UIButton*)button:(NSString*)imageName target:(id)target action:(SEL)action;


//Rect helpers
+(CGRect)rectWithRect:(CGRect)rect setX:(float)x;
+(CGRect)rectWithRect:(CGRect)rect setWidth:(float)width;
+(CGRect)rectWithRect:(CGRect)rect setY:(float)y;
+(CGRect)rectWithRect:(CGRect)rect setHeight:(float)height;

//Activity View
-(void)activity:(BOOL)show;

//Generic properties
-(void)setValue:(id)value withKey:(NSString*)key forObject:(id)_object;
-(id)getValueForKey:(NSString*)key ofObject:(id)_object;
-(id)getObjectWithKey:(NSString*)_key value:(id)_value;

//Generic queries
-(id)itemWithValue:(id)value forKey:(NSString*)key in:(NSArray*)array;
-(id)itemWithPredicate:(NSPredicate*)predicate in:(NSArray*)array;


-(NSDateComponents *)getCurrentDateTime;

@end
