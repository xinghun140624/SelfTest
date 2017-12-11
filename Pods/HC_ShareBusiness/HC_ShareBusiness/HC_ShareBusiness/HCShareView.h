//
//  HCShareView.h
//  HC_ShareBusiness
//
//  Created by Candy on 2017/6/30.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface HCShareView : UIView
@property (nonatomic, copy) void (^shareButtonClickCallBack)(NSInteger index);
@property (nonatomic, copy) void (^cancelButtonClickCallBack)();
@property (nonatomic, assign) NSInteger type;//(1包含复制链接， 2不包含复制链接)
@end
