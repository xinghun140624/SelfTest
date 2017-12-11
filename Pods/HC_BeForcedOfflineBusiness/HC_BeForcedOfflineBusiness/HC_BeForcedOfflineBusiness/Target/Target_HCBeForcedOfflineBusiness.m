//
//  Target_HCBeForcedOfflineBusiness.m
//  HC_BeForcedOfflineBusiness
//
//  Created by 郭金山 on 2017/9/14.
//  Copyright © 2017年 candy. All rights reserved.
//

#import "Target_HCBeForcedOfflineBusiness.h"
#import "HCCheckTokenStatusService.h"
@implementation Target_HCBeForcedOfflineBusiness
- (void)Action_checkTokenStatus:(NSDictionary *)params {
    [HCCheckTokenStatusService checkTokenStatus];
}

@end
