//
//  HCInvestmentService.h
//  HongCai
//
//  Created by Candy on 2017/7/1.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCInvestmentService : NSObject
+ (void)getInvestmentDataWithPage:(NSInteger)page type:(NSInteger)type successCallBack:(void(^)(NSArray*models,BOOL finished))successCallBack;
+ (void)getAssignmentsDataWithPage:(NSInteger)page successCallBack:(void(^)(NSArray*models,BOOL finished))successCallBack;
@end
