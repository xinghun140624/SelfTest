//
//  HCUser.h
//  HongCai
//
//  Created by Candy on 2017/6/9.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import "HCUserService.h"

@interface HCUser : NSObject<NSCoding,YYModel>
@property (nonatomic, strong) NSNumber *active;
@property (nonatomic,   copy) NSString *autoTender;
@property (nonatomic, strong) NSNumber *bindMobile;
@property (nonatomic, strong) NSNumber *createTime;
@property (nonatomic, strong) NSNumber *deleteFlag;
@property (nonatomic,   copy) NSString *email;
@property (nonatomic, strong) NSNumber *frozen;
@property (nonatomic, strong) NSNumber *fundsAccount;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *isFrozen;
@property (nonatomic, strong) NSNumber *lastLoginTime;
@property (nonatomic,   copy) NSString *mobile;
@property (nonatomic,   copy) NSString *name;
@property (nonatomic,   copy) NSString *nickName;
@property (nonatomic, strong) NSNumber *openid;
@property (nonatomic,   copy) NSString *password;
@property (nonatomic,   copy) NSString *portraitUrl;
@property (nonatomic,   copy) NSString *realName;
@property (nonatomic, strong) NSNumber *registSource;
@property (nonatomic, strong) NSNumber *sex;
@property (nonatomic,   copy) NSString *token;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic,   copy) NSString *userAuth;
@property (nonatomic, strong) NSArray *userList;
@property (nonatomic,   copy) NSString *userSecurityStatus;
@property (nonatomic,   copy) NSString *originMobile;

@end
