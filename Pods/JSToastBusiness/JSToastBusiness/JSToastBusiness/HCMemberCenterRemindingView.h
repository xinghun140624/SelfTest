//
//  HCMemberCenterRemindingView.h
//  JSToastBusiness
//
//  Created by 郭金山 on 2017/10/23.
//  Copyright © 2017年 Candy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCMemberCenterRemindingView : UIView
@property (nonatomic, copy) void(^tapClick)(void);
@property (nonatomic, assign) CGRect section1Frame;
@end
