//
//  HCUser.m
//  HongCai
//
//  Created by Candy on 2017/6/9.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUser.h"
static NSString *const kUserActive                    = @"active";
static NSString *const kUserAutoTender                = @"autoTender";
static NSString *const kUserBindMobile                = @"bindMobile";
static NSString *const kUserCreateTime                = @"createTime";
static NSString *const kUserDeleteFlag                = @"deleteFlag";
static NSString *const kUserEmail                     = @"email";
static NSString *const kUserFrozen                    = @"frozen";
static NSString *const kUserFundsAccount              = @"fundsAccount";
static NSString *const kUserUserId                    = @"userId";
static NSString *const kUserIsFrozen                  = @"isFrozen";
static NSString *const kUserLastLoginTime             = @"lastLoginTime";
static NSString *const kUserMobile                    = @"mobile";
static NSString *const kUserName                      = @"name";
static NSString *const kUserNickName                  = @"nickName";
static NSString *const kUserOpenid                    = @"openid";
static NSString *const kUserPassword                  = @"password";
static NSString *const KUserPortraitUrl               = @"portraitUrl";
static NSString *const kUserRealName                  = @"realName";
static NSString *const kUserRegistSource              = @"registSource";
static NSString *const kUserSex                       = @"sex";
static NSString *const kUserToken                     = @"token";
static NSString *const kUserType                      = @"type";
static NSString *const kUserUserAuth                  = @"userAuth";
static NSString *const kUserUserList                  = @"userList";
static NSString *const kUserUserSecurityStatus        = @"userSecurityStatus";
static NSString *const kUserOriginMobile              = @"originMobile";

@implementation HCUser

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"userId":@"id"};
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.active = [aDecoder decodeObjectForKey:kUserActive];
        self.autoTender = [aDecoder decodeObjectForKey:kUserAutoTender];
        self.bindMobile = [aDecoder decodeObjectForKey:kUserBindMobile];
        self.createTime = [aDecoder decodeObjectForKey:kUserCreateTime];
        self.deleteFlag = [aDecoder decodeObjectForKey:kUserDeleteFlag];
        self.email = [aDecoder decodeObjectForKey:kUserEmail];
        self.frozen = [aDecoder decodeObjectForKey:kUserFrozen];
        self.fundsAccount = [aDecoder decodeObjectForKey:kUserFundsAccount];
        self.userId = [aDecoder decodeObjectForKey:kUserUserId];
        self.isFrozen= [aDecoder decodeObjectForKey:kUserIsFrozen];
        self.lastLoginTime = [aDecoder decodeObjectForKey:kUserLastLoginTime];
        self.mobile = [aDecoder decodeObjectForKey:kUserMobile];
        self.name = [aDecoder decodeObjectForKey:kUserName];
        self.nickName = [aDecoder decodeObjectForKey:kUserNickName];
        self.openid= [aDecoder decodeObjectForKey:kUserOpenid];
        self.password = [aDecoder decodeObjectForKey:kUserPassword];
        self.portraitUrl = [aDecoder decodeObjectForKey:KUserPortraitUrl];
        self.realName = [aDecoder decodeObjectForKey:kUserRealName];
        self.registSource = [aDecoder decodeObjectForKey:kUserRegistSource];
        self.sex = [aDecoder decodeObjectForKey:kUserSex];
        self.token = [aDecoder decodeObjectForKey:kUserToken];
        self.type = [aDecoder decodeObjectForKey:kUserType];
        self.userAuth = [aDecoder decodeObjectForKey:kUserUserAuth];
        self.userList = [aDecoder decodeObjectForKey:kUserUserList];
        self.userSecurityStatus = [aDecoder decodeObjectForKey:kUserUserSecurityStatus];
        self.originMobile = [aDecoder decodeObjectForKey:kUserOriginMobile];
    }
    return self;
}
/**
 *  将对象写入文件时调用
 *
 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.active forKey:kUserActive];
    [aCoder encodeObject:self.autoTender forKey:kUserAutoTender];
    [aCoder encodeObject:self.bindMobile forKey:kUserBindMobile];
    [aCoder encodeObject:self.createTime forKey:kUserCreateTime];
    [aCoder encodeObject:self.deleteFlag forKey:kUserDeleteFlag];
    [aCoder encodeObject:self.email forKey:kUserEmail];
    [aCoder encodeObject:self.frozen forKey:kUserFrozen];
    [aCoder encodeObject:self.fundsAccount forKey:kUserFundsAccount];
    [aCoder encodeObject:self.userId forKey:kUserUserId];
    [aCoder encodeObject:self.isFrozen forKey:kUserIsFrozen];
    [aCoder encodeObject:self.lastLoginTime forKey:kUserLastLoginTime];
    [aCoder encodeObject:self.mobile forKey:kUserMobile];
    [aCoder encodeObject:self.name forKey:kUserName];
    [aCoder encodeObject:self.nickName forKey:kUserNickName];
    [aCoder encodeObject:self.openid forKey:kUserOpenid];
    [aCoder encodeObject:self.password forKey:kUserPassword];
    [aCoder encodeObject:self.portraitUrl forKey:KUserPortraitUrl];
    [aCoder encodeObject:self.realName forKey:kUserRealName];
    [aCoder encodeObject:self.registSource forKey:kUserRegistSource];
    [aCoder encodeObject:self.sex forKey:kUserSex];
    [aCoder encodeObject:self.token forKey:kUserToken];
    [aCoder encodeObject:self.type forKey:kUserType];
    [aCoder encodeObject:self.userAuth forKey:kUserUserAuth];
    [aCoder encodeObject:self.userList forKey:kUserUserList];
    [aCoder encodeObject:self.userSecurityStatus forKey:kUserUserSecurityStatus];
    [aCoder encodeObject:self.originMobile forKey:kUserOriginMobile];

}
@end
