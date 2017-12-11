//
//  HCMobileCheckApi.h
//  Pods
//
//  Created by Candy on 2017/7/5.
//
//

#import <YTKNetwork/YTKNetwork.h>

@interface HCMobileCheckApi : YTKRequest
- (instancetype)initWithBusiness:(int)business mobile:(NSString *)mobile captcha:(NSString *)captcha type:(int)type;
@end
