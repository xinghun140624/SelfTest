//
//  HCImmediatelyTransferController.h
//  HongCai
//
//  Created by Candy on 2017/7/4.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HCImmediatelyTransferController : UIViewController
@property (nonatomic ,copy) NSString * number;

@property (nonatomic ,copy) void (^hanlderSuccessCallBack)(NSDecimalNumber *remainingAmount);
@end
