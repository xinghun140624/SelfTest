//
//  HCTimeTool.m
//  HongCai
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCTimeTool.h"

@implementation HCTimeTool
//时间戳转化
+ (NSString *)getDateWithTimeInterval:(NSNumber *)timeInterval andTimeFormatter:(NSString *)timeFromatter
{
    double timeInte = [timeInterval doubleValue] / 1000.0;
    NSDateFormatter * formatter = [self transformWithTimeFormatter:timeFromatter];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeInte];
    NSString * dateString = [formatter stringFromDate:date];
    return dateString;
}
+ (NSDateFormatter *)transformWithTimeFormatter:(NSString *)timeFormatter {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    });
    [formatter setDateFormat:timeFormatter];
    
    return formatter;
}

+ (NSInteger)getTimeDistanceDate1:(NSTimeInterval )date1 date2:(NSTimeInterval )date2 {
    NSDate * time1 = [NSDate dateWithTimeIntervalSince1970:date1/1000.0];
    NSDate * time2 = [NSDate dateWithTimeIntervalSince1970:date2/1000.0];

    time1 = [self zeroOfDateWithDate:time1];
    time2 = [self zeroOfDateWithDate:time2];
    NSTimeInterval resultTime = fabs([time1 timeIntervalSinceDate:time2]);
    
    return  resultTime/60.0/60.0/24.0;

}

+ (NSDate *)zeroOfDateWithDate:(NSDate *)date;
{
    NSCalendar *calendar = [self currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:date];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    // components.nanosecond = 0 not available in iOS
    NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
    return [NSDate dateWithTimeIntervalSince1970:ts];
}
+ (NSCalendar *)currentCalendar {
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}
@end
