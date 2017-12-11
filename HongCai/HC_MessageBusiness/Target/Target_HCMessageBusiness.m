//
//  Target_HCMessageBusiness.m
//  HC_MessageBusiness
//
//  Created by Candy on 2017/7/4.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "Target_HCMessageBusiness.h"
#import "HCMessageController.h"

@implementation Target_HCMessageBusiness
- (UIViewController *)Action_viewController:(NSDictionary *)params {
    HCMessageController * messageController = [[HCMessageController alloc] init];
    if ([params.allKeys containsObject:@"index"]) {
        messageController.index = [params[@"index"] integerValue];
    }
 
    return messageController;
    
}
@end
