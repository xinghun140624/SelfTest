//
//  HCLoadingView.m
//  HongCai
//
//  Created by Candy on 2017/7/21.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCLoadingView.h"
#import <Masonry/Masonry.h>
#import "NSBundle+JSToastBusiness.h"
@interface HCLoadingView ()
@property (nonatomic, strong) UIView * leftLoading;
@end

@implementation HCLoadingView
- (void)dealloc {

}
- (CGSize)intrinsicContentSize {
    return CGSizeMake(120, 140);
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.image = [NSBundle jSToastBusiness_ImageWithName:@"loading"];
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self).mas_offset(-CGRectGetHeight(frame)*0.15);
            make.size.mas_equalTo(CGSizeMake(60, 55));
        }];
        
        UILabel * label = [[UILabel alloc] init];
        label.text = @"稍等一会儿哦...";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithRed:244/255.0 green:181.0/255.0 blue:49/255.0 alpha:1];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).mas_offset(10.f);
            make.centerX.mas_equalTo(self).mas_offset(5);
        }];
        self.leftLoading= [[UIView alloc] init];
        [self addSubview:self.leftLoading];
        
        [self.leftLoading mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).mas_equalTo(19.f);
            make.right.mas_equalTo(label.mas_left);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        [self creatCircleJoinAnimation];
    }
    return self;
}

- (void)creatCircleJoinAnimation

{
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds          = CGRectMake(0, 0, 10, 10);
    replicatorLayer.cornerRadius    = 10.0;
    replicatorLayer.position        =  self.leftLoading.center;
    replicatorLayer.backgroundColor = [UIColor whiteColor].CGColor;
    
    [self.leftLoading.layer addSublayer:replicatorLayer];
    
    
    CALayer *dot        = [CALayer layer];
    dot.bounds          = CGRectMake(0, 0, 5, 5);
    dot.position        = CGPointMake(0, 0);
    dot.backgroundColor = [UIColor colorWithRed:244/255.0 green:181.0/255.0 blue:49/255.0 alpha:0.7].CGColor;
    dot.cornerRadius    = 5;
    dot.masksToBounds   = YES;
    
    [replicatorLayer addSublayer:dot];
    
    
    CGFloat count                     = 100.0;
    replicatorLayer.instanceCount     = count;
    CGFloat angel                     = 2* M_PI/count;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angel, 0, 0, 1);
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration    = 1.0;
    animation.fromValue   = @1;
    animation.toValue     = @0.1;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    [dot addAnimation:animation forKey:@"nil"];
    
    
    replicatorLayer.instanceDelay = 1.0/ count;
    
    dot.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
}
@end
