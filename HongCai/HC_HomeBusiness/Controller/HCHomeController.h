//
//  HCHomeController.h
//  HongCai
//
//  Created by Candy on 2017/5/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCHomeController : UIViewController

//mark: 是否第一次加载 yes是
@property (nonatomic, assign) BOOL isFirstLoad;

- (void)requestActivityBirthday;
@end
