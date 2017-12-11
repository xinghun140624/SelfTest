//
//  HCHomeHeaderView.h
//  HongCai
//
//  Created by Candy on 2017/6/1.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
@class HCActivityModel;
@class HCHomeNoticeView;

@interface HCHomeHeaderView : UIView
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, strong, readonly) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong, readonly) HCHomeNoticeView *homeNoticeView;
@property (nonatomic, strong) NSArray *imageURLStringsGroup;
@property (nonatomic, strong) NSArray * bannerModelArray;
@property (nonatomic, strong) NSArray <HCActivityModel *> *activictyModels;
@property (nonatomic, copy) void(^buttonClick)(NSInteger index);
@end
