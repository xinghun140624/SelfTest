//
//  HCCGActiveView.h
//  HongCai
//
//  Created by Candy on 2017/7/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCCGActiveView : UIView
@property (nonatomic, copy) void(^detailButtonCallBack)(void);
@property (nonatomic, copy) void(^openButtonCallBack)(void);

@end
