//
//  HCLoginTool.m
//  HongCai
//
//  Created by Candy on 2017/6/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCLoginTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
@implementation HCLoginTool


+ (NSString *)stringToMD5:(NSString *)mdStr {
    const char *original_str = [mdStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}


#pragma mark 手机号码验证

+(BOOL)isValidPhoneNum:(NSString *)str{
    
    NSString *MOBILE = @"^0?(13|14|15|17|18|19)[0-9]{9}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if ([regextestmobile evaluateWithObject:str] == YES) {
        return YES;
    }else {
        return NO;
    }
}


+ (NSInteger)checkPassword:(NSString *) password;
{
    
    NSString *pattern1 = @"^(?=.*\\d)(?=.*[a-zA-Z])[\\da-zA-Z\\W]{6,16}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern1];
    BOOL isMatch1 = [pred1 evaluateWithObject:password];
    
    
    
    NSString *pattern2 = @"^(?=.*[a-zA-Z])(?=.*[0-9])[\\da-zA-Z~!@#$%^&*]{6,16}$";
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern2];
    BOOL isMatch2 = [pred2 evaluateWithObject:password];
    
    
    if (!isMatch1) {
        return 0;
    }
    if (!isMatch2) {
        return 1;
    }
    return 2;
}
+ (NSMutableAttributedString *)checkPasswordLevel:(NSString *)password {
    
    if (password.length==0) {
        return nil;
    }
    NSString *pattern = @"^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]{11,}$";//数字和字母11位以上
    NSString *pattern2 = @"^(?=.*[0-9].*)(?=.*[A-Z].*)(?=.*[a-z].*)[0-9A-Za-z]{6,}$";//数字，字母大小写，6位以上
    NSString *pattern3 = @"^(?=.*\\d)(?=.*[a-zA-Z])(?=.*[~!@#$%^&*])[\\da-zA-Z~!@#$%^&*]{6,}$";//数字字母符号
    NSString *pattern4 = @"^(?=.*?[0-9])(?=.*?[A-Z])(?=.*?[a-z])[0-9A-Za-z]{11,}$";//数字和字母大小写11位以上
    NSString *pattern5 = @"^(?=.*\\d)(?=.*[a-zA-Z])(?=.*[~!@#$%^&*])[\\da-zA-Z~!@#$%^&*]{11,}$";//数字字母符号11位以上
    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch1 = [pred1 evaluateWithObject:password];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern2];
    BOOL isMatch2 = [pred2 evaluateWithObject:password];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern3];
    BOOL isMatch3 = [pred3 evaluateWithObject:password];
    NSPredicate *pred4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern4];
    BOOL isMatch4 = [pred4 evaluateWithObject:password];
    NSPredicate *pred5 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern5];
    BOOL isMatch5 = [pred5 evaluateWithObject:password];
    
    NSInteger level = 1;
    
    if (isMatch1 || isMatch2 || isMatch3) {
        level = 2;//中
    }
    if (isMatch4 || isMatch5 ) {
        level = 3;//强
    }
    NSMutableAttributedString * passwordStatus = nil;
    
    switch (level) {
        case 1:
        {
            passwordStatus = [[NSMutableAttributedString alloc] initWithString:@"密码强度：弱" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x999999"]}];
            [passwordStatus addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0xef2e2e"] range:NSMakeRange(5, 1)];
        }
            break;
        case 2:
        {
            passwordStatus = [[NSMutableAttributedString alloc] initWithString:@"密码强度：中" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x999999"]}];
            [passwordStatus addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0x25a9f4"] range:NSMakeRange(5, 1)];
        }
            break;
        case 3:
        {
            passwordStatus = [[NSMutableAttributedString alloc] initWithString:@"密码强度：强" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x999999"]}];
            [passwordStatus addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0x6dbe04"] range:NSMakeRange(5, 1)];
        }
            break;
    }
    [passwordStatus addAttribute:NSBackgroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, passwordStatus.string.length)];

    return passwordStatus;
    
}
+ (BOOL)isContainChinese:(NSString *)str {
    for (int i=0; i<str.length; i++) {
        int a = [str characterAtIndex:i];
        if (a>0x4e00 && a <0x9fff) {
            return YES;
        }
    }
    return NO;
}
@end
