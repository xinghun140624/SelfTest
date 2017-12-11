//
//  HCAdView.m
//  JSToastBusiness
//
//  Created by 郭金山 on 2017/8/15.
//  Copyright © 2017年 Candy. All rights reserved.
//

#import "HCAdView.h"
#import <Masonry/Masonry.h>
#import "MBProgressHUD.h"

@interface HCAdButton : UIButton

@end

@implementation HCAdButton


@end




@interface HCAdView ()
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) HCAdButton * adButton;
@end

@implementation HCAdView {
    dispatch_source_t _timer;

}

- (void)dealloc {
    
}
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}
- (CGSize)intrinsicContentSize {
    return [UIScreen mainScreen].bounds.size;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.userInteractionEnabled = YES;
        [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)]];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        self.adButton = [HCAdButton buttonWithType:UIButtonTypeCustom];
        self.adButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        self.adButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.adButton.layer.borderWidth = 1.5f;
        self.adButton.layer.cornerRadius = 22.5;
        self.adButton.titleLabel.numberOfLines = 0;
        self.adButton.titleLabel.font = [UIFont systemFontOfSize:10];
        self.adButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.adButton addTarget:self action:@selector(jumpButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.imageView addSubview:self.adButton];
        
        [self.adButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        [self sendVerifyNum];
    }
    return self;
}
- (void)imageViewClick:(UITapGestureRecognizer *)tap {
    if (self.imageClick) {
        self.imageClick();
    }
    tap.enabled = NO;
}

- (void)jumpButtonClick {
    dispatch_source_cancel(_timer);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HC_AdViewDismissNotification" object:nil];
    [MBProgressHUD hideHUDForView:self.containerView animated:YES];
}

- (void)sendVerifyNum
{
    __block int timeout=3; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.containerView animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HC_AdViewDismissNotification" object:nil];
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.adButton setTitle:[NSString stringWithFormat:@"跳过\n%@s",strTime] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
