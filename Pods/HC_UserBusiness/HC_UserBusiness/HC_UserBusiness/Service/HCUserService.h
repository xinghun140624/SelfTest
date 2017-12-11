//
//  HCUserService.h
//  HongCai
//
//  Created by Candy on 2017/6/9.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HCUser;
@interface HCUserService : NSObject
+ (BOOL)saveUser:(HCUser *)user;
+ (HCUser *)user;
+ (BOOL)removeUser;
@end
