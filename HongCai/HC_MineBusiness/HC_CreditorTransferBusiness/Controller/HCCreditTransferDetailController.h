//
//  HCCreditTransferDetailController.h
//  HongCai
//
//  Created by Candy on 2017/7/17.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCCreditTransferDetailController : UIViewController
@property (nonatomic, strong) NSString * number;
@property (nonatomic, copy) void(^cancelTransferCallBack)(void);
@end
