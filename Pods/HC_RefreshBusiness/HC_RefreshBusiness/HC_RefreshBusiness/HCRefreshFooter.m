//
//  HCRefreshFooter.m
//  HongCai
//
//  Created by Candy on 2017/7/20.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCRefreshFooter.h"

@implementation HCRefreshFooter

- (void)prepare {
    [super prepare];
    self.stateLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    self.stateLabel.font = [UIFont systemFontOfSize:11];
}

@end
