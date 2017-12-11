//
//  Target_HCMessageBusiness.h
//  HC_MessageBusiness
//
//  Created by Candy on 2017/7/4.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockCallBack)(NSDictionary * info);

@interface Target_HCMessageBusiness : NSObject
- (UIViewController *)Action_viewController:(NSDictionary *)params;
@end
