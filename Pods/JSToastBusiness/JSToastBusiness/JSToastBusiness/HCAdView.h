//
//  HCAdView.h
//  JSToastBusiness
//
//  Created by 郭金山 on 2017/8/15.
//  Copyright © 2017年 Candy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCAdView : UIView
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, copy) void (^imageClick)(void);
@end
