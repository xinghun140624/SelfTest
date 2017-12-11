//
//  HCMemberCenterBottomView.h
//  HongCai
//
//  Created by Candy on 2017/11/21.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HCMemberCenterButtonType) {
    HCMemberCenterButtonTypeRaise = 100,//加息
    HCMemberCenterButtonTypeBirthDay,
    HCMemberCenterButtonTypeTixian,
    HCMemberCenterButtonTypeWait
};

@interface HCMemberCenterBottomView : UIView
@property (nonatomic,strong) UIImageView *levelDescImageView;
@property (nonatomic,strong) NSMutableArray * buttonArray;
@property (nonatomic,  copy) void(^buttonClickCallBack)(HCMemberCenterButtonType type);
@end
