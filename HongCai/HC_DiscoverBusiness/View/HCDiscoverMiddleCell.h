//
//  HCDiscoverMiddleCell.h
//  HongCai
//
//  Created by Candy on 2017/6/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCDiscoverMiddleCell;
#import "HCActivityModel.h"
@protocol HCDiscoverMiddleCellDelegate <NSObject>

- (void)discoverMiddleCell:(HCDiscoverMiddleCell *)middleCell buttonClickAction:(NSInteger)index;

@end

@interface HCDiscoverMiddleCell : UITableViewCell
@property (nonatomic, assign) id <HCDiscoverMiddleCellDelegate>delegate;
@property (nonatomic, strong) NSArray <HCActivityModel *> *activictyModels;

@end
