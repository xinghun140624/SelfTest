//
//  HCMyInvesetmentFactoryCell.h
//  Pods
//
//  Created by Candy on 2017/6/27.
//
//

#import <UIKit/UIKit.h>
@class HCMyInvestModel;
@interface HCMyInvesetmentFactoryCell : UITableViewCell
@property (nonatomic, strong)HCMyInvestModel * model;
@property (nonatomic, strong,readonly) UILabel *middleLabel;

@end
