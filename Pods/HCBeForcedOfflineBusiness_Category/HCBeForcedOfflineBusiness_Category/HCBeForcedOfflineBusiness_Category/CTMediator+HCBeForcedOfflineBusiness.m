//
//  CTMediator+HCBeForcedOfflineBusiness.m
//  HCBeForcedOfflineBusiness_Category
//
//  Created by 郭金山 on 2017/9/14.
//  Copyright © 2017年 candy. All rights reserved.
//

#import "CTMediator+HCBeForcedOfflineBusiness.h"

@implementation CTMediator (HCBeForcedOfflineBusiness)
- (void)HCBeForcedOfflineBusiness_checkTokenStatus {
    [self performTarget:@"HCBeForcedOfflineBusiness" action:@"checkTokenStatus" params:nil shouldCacheTarget:NO];
}

@end
