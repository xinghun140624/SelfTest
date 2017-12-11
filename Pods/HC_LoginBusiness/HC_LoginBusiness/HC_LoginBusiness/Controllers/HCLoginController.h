//
//  HCLoginController.h
//  HongCai
//
//  Created by Candy on 2017/6/1.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^closeButtonClickCallBack)(void);

@interface HCLoginController : UIViewController
@property (nonatomic, copy)closeButtonClickCallBack closeButtonCallBack;
@end
