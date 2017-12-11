//
//  HCSettingLockController.h
//  HongCai
//
//  Created by Candy on 2017/8/11.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    GestureViewControllerTypeRecommand = 0,
    GestureViewControllerTypeSetting,
    GestureViewControllerTypeLogin,
    GestureViewControllerTypeVerify,
    GestureViewControllerTypeVerifyAndDelete
}GestureViewControllerType;

typedef enum{
    buttonTagReset = 1,
    buttonTagChangeUser,
    buttonTagForget
    
}buttonTag;


@interface HCSettingLockController : UIViewController
@property (nonatomic, assign) GestureViewControllerType type;
@property (nonatomic, copy) void(^dimissCallBack)(void);
@end
