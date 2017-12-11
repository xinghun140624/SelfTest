//
//  HCHomeActivityView.h
//  HongCai
//
//  Created by 郭金山 on 2017/11/9.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCHomeActivityView : UIView
@property (nonatomic, strong, readonly) UIImageView * imageView;
@property (nonatomic,copy) void (^closeButtonClick)(void);
@property (nonatomic,copy) void (^imageClick)(void);

@end
