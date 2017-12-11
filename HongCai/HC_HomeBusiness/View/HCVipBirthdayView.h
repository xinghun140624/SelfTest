//
//  HCVipBirthdayView.h
//  HongCai
//
//  Created by hoolai on 2017/12/6.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCVipBirthdayView : UIView
@property (nonatomic, strong, readonly) UIImageView * imageView;
@property (nonatomic,copy) void (^closeButtonClick)(void);
@property (nonatomic,copy) void (^imageClick)(void);

@end
