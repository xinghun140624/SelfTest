//
//  HCInterestRateView.m
//  HongCai
//
//  Created by Candy on 2017/7/4.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCInterestRateView.h"

@implementation HCInterestRateView

- (instancetype)init {
    if (self = [super init]) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:9];
        UIImage * image = [UIImage imageNamed:@"icon_jx_nor"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 15, 5, 10) resizingMode:UIImageResizingModeTile];
        self.titleLabel.textAlignment=  NSTextAlignmentCenter;
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
