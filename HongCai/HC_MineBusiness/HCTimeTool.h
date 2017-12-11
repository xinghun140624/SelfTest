//
//  HCTimeTool.h
//  HongCai
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCTimeTool : NSObject
+ (NSString *)getDateWithTimeInterval:(NSNumber *)timeInterval andTimeFormatter:(NSString *)timeFromatter;

+ (NSInteger)getTimeDistanceDate1:(NSTimeInterval )date1 date2:(NSTimeInterval )date2;

@end
