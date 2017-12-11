//
//  HCHomeNoticeView.h
//  HongCai
//
//  Created by Candy on 2017/6/12.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Wonderful/SXHeadLine.h>
#import <HCMessageBusiness_Category/CTMediator+HCMessageBusiness.h>
#import "HCNoticeModel.h"
@interface HCHomeNoticeView : UIView
@property (nonatomic, strong)NSArray * noticeModels;
@property (nonatomic, strong, readonly) SXHeadLine *headLine;
@end
