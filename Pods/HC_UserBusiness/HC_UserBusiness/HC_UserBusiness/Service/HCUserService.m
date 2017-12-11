//
//  HCUserService.m
//  HongCai
//
//  Created by Candy on 2017/6/9.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserService.h"
#import "HCUser.h"

#define HCAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HCAcccount.data"]

@implementation HCUserService
+ (BOOL)saveUser:(HCUser *)user {
   return [NSKeyedArchiver archiveRootObject:user toFile:HCAccountFile];
}
+ (HCUser *)user {
    HCUser *user =  [NSKeyedUnarchiver unarchiveObjectWithFile:HCAccountFile];
    return user;
}
+ (BOOL )removeUser {
    NSError * error = nil;
    BOOL isSuccess =  [[NSFileManager defaultManager] removeItemAtPath:HCAccountFile error:&error];
#if DEBUG
    if (isSuccess) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"%@",error.localizedDescription);
    }
#endif
    return isSuccess;
}
@end
