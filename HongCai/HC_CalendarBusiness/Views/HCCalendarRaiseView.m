//
//  HCCalendarRaiseView.m
//  HongCai
//
//  Created by 郭金山 on 2017/11/14.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCalendarRaiseView.h"
#import "NSBundle+HCCalendarModule.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
@implementation HCCalendarRaiseView

- (instancetype)init {
    if (self = [super init]) {
        [self setTitleColor:[UIColor colorWithHexString:@"0xff6000"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:9];
        UIImage * image = [NSBundle calendar_ImageWithName:@"calendar_rate"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 5, 0) resizingMode:UIImageResizingModeTile];
        self.titleLabel.textAlignment=  NSTextAlignmentCenter;
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
    return self;
}
- (void)setDescString:(NSString *)descString {
    _descString = descString;
    [self setTitle:descString forState:UIControlStateNormal];
    self.userInteractionEnabled = NO;
    
}

@end
