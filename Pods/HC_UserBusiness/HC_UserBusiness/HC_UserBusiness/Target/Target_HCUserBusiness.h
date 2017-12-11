//
//  Target_HCUserBusiness.h
//  HC_UserBusiness
//
//  Created by Candy on 2017/7/2.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_HCUserBusiness : NSObject
- (NSDictionary *)Action_getUser:(NSDictionary *)params;
- (BOOL)Action_saveUser:(NSDictionary *)params;
- (BOOL)Action_removeUser:(NSDictionary *)params;

- (void)Action_getUserAuth:(NSDictionary *)params;

@end
