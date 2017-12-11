//
//  HCUpdateUserGesturePasswordApi.h
//  HongCai
//
//  Created by 郭金山 on 2017/8/14.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface HCUpdateUserGesturePasswordApi : YTKRequest
- (instancetype)initWithGesture:(NSString * )gesture token:(NSString *)token;
@end
