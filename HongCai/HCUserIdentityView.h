//
//  HCUserIdentityView.h
//  HongCai
//
//  Created by Candy on 2017/7/5.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCUserIdentityView : UIView
@property (nonatomic, copy) void (^cancelButtonClickCallBack)(void);
@property (nonatomic, copy) void (^confirmButtonClickCallBack)( NSDictionary * params);

@end
