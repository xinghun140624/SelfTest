//
//  HCCalendarCell.h
//  HongCai
//
//  Created by 郭金山 on 2017/10/25.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <FSCalendar/FSCalendar.h>
typedef NS_ENUM(NSUInteger, SelectionType) {
    SelectionTypeNone,
    SelectionTypeHK
};

@interface HCCalendarCell : FSCalendarCell

@property (weak, nonatomic) UIImageView *hkImageView;

@property (assign, nonatomic) SelectionType selectionType;

@end
