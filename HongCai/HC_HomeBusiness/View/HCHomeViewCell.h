//
//  HCHomeViewCell.h
//  HongCai
//
//  Created by Candy on 2017/6/12.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCProjectModel;
@interface HCHomeViewCell : UITableViewCell
@property (nonatomic, strong, readonly) UIImageView *logoImageView;
@property (nonatomic, strong, readonly) UILabel *logoTextLabel;
@property (nonatomic, strong, readonly) UILabel *interestRateLabel;
@property (nonatomic, strong, readonly) UILabel *leftLabel;
@property (nonatomic, strong, readonly) UILabel *middleLabel;
@property (nonatomic, strong, readonly) UILabel *rightLabel;
@property (nonatomic, strong, readwrite) HCProjectModel * project;
@property (nonatomic, strong, readonly) UIImageView  *finishImageView;
@property (nonatomic, copy) void (^moreButtonClickCallBack)(void);
@end
