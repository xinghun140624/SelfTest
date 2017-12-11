//
//  HCAutoTenderDateView.h
//  HongCai
//
//  Created by Candy on 2017/7/20.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCAutoTenderDateView : UIView
@property (nonatomic, strong, readonly) UILabel * titleLabel;
@property (nonatomic, strong, readonly) UIDatePicker * datePicker;
@property (nonatomic) NSDate *minimumDate;
@property (nonatomic) NSDate *maximumDate;
@property (nonatomic) NSInteger minuteInterval;
@property (nonatomic) NSLocale *locale;
@property (nonatomic, copy) void (^selectTimeCallBack)(NSDate * date);
@end
