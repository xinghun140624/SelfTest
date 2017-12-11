//
//  HCGoToTransferView.h
//  Pods
//
//  Created by Candy on 2017/7/7.
//
//

#import <UIKit/UIKit.h>

@interface HCGoToTransferView : UIView
@property (nonatomic, copy) void (^gotoInvestButtonClickCallBack)(void);
@property (nonatomic, strong) NSNumber *projectDays;
@property (nonatomic, strong) NSNumber *remainAmount;
@property (nonatomic, strong) NSNumber *amount;

@property (nonatomic, strong) NSNumber *projectId;
@property (nonatomic, strong) NSNumber *annualEarnings;
@property (nonatomic, strong) NSNumber *originalAnnualEarnings;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong, readonly) NSNumber *investAmount;

@end
