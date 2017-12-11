//
//  HCMyInvestService.h
//  Pods
//
//  Created by Candy on 2017/7/14.
//
//

#import <Foundation/Foundation.h>

@interface HCMyInvestService : NSObject
+ (void)loadMyInvestDataWithPage:(NSInteger )page type:(NSInteger)type status:(NSInteger)status success:(void(^)(NSArray *models,BOOL isFinish))success;

@end
