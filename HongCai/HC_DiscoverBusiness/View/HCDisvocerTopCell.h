//
//  HCDisvocerTopCell.h
//  HongCai
//
//  Created by Candy on 2017/6/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCUserMemberModel;

@interface HCDisvocerTopUnLoginCell : UITableViewCell

@end

@interface HCDisvocerTopLoginedCell : UITableViewCell
@property (nonatomic, strong) HCUserMemberModel * model;
@end
