//
//  HCCheckUserService.h
//  HongCai
//
//  Created by Candy on 2017/7/12.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HCCheckUserService : NSObject
+ (void)checkUserAuthStatusAndBankcard:(UIViewController *)controller success:(void(^)(BOOL success))success;
+ (void)activeCGT:(UIViewController *)controller;
+ (void)openCGT:(UIViewController *)controller;
@end
