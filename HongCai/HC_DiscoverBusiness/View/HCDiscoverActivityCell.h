//
//  HCDiscoverActivityCell.h
//  HongCai
//
//  Created by Candy on 2017/6/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCActivityModel;
@interface HCDiscoverActivityCell : UITableViewCell
@property (nonatomic, strong, readonly) UIImageView *activityImageView;
@property (nonatomic, strong) HCActivityModel * activityModel;
@end
