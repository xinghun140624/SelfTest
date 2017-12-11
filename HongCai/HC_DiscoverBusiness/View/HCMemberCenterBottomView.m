//
//  HCMemberCenterBottomView.m
//  HongCai
//
//  Created by Candy on 2017/11/21.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMemberCenterBottomView.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>

@interface HCMemberCenterButton:UIButton

@end

@implementation HCMemberCenterButton
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat y = 3;
    return CGRectMake(contentRect.size.width*0.15, y, contentRect.size.width*0.75, contentRect.size.width*0.75);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat y = contentRect.size.height *0.8;
    return CGRectMake(0, y, contentRect.size.width, contentRect.size.height*0.15);
}
@end

@implementation HCMemberCenterBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.buttonArray = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
        UIView *placeHolderView = [UIView new];
        placeHolderView.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
        [self addSubview:placeHolderView];
        [placeHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(15);
        }];
        
        NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"HCDiscoverController")];
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"HCDiscoverBusinessImage" ofType:@"bundle"]];
        
        
        UILabel * descLabel = [[UILabel alloc] init];
        descLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        descLabel.text = @"特权待遇享不停";
        descLabel.font = [UIFont systemFontOfSize:15.f];
        [self addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(placeHolderView.mas_bottom).mas_offset(15);
            make.height.mas_equalTo(20);
        }];
        
        UIView * line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(placeHolderView.mas_bottom).mas_offset(50);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        NSArray * buttonNameArray = @[@"专享加息券",@"生日福利",@"免费提现",@"敬请期待"];
        NSMutableArray * buttonArray = [NSMutableArray array];
        HCMemberCenterButton * lastButton = nil;
        for (NSInteger index = 0; index <4; index++) {
            HCMemberCenterButton * button = [HCMemberCenterButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.tag = 100+index;
            [button setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
            if (index<3) {
                [buttonArray addObject:button];
            }else {
                lastButton = button;
            }
            [button setTitle:buttonNameArray[index] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(myButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        [buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
            HCMemberCenterButton * button = buttonArray.firstObject;
            make.top.mas_equalTo(line.mas_bottom).mas_offset(0);
            make.height.mas_equalTo(button.mas_width);
        }];
        [lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
            HCMemberCenterButton * button = buttonArray.firstObject;
            make.size.mas_equalTo(button);
            make.left.mas_equalTo(button);
            make.top.mas_equalTo(button.mas_bottom);
        }];
        [self.buttonArray addObjectsFromArray:buttonArray];
        [self.buttonArray addObject:lastButton];
        UIImageView * levelDescImageView = [UIImageView new];
        NSString * levelDescImagePath = [[resourcesBundle resourcePath] stringByAppendingPathComponent:@"level_desc"];
        levelDescImageView.image = [UIImage imageWithContentsOfFile:levelDescImagePath];
        self.levelDescImageView = levelDescImageView;
        [self addSubview:levelDescImageView];
        [levelDescImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lastButton.mas_bottom).mas_offset(10);
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(levelDescImageView.image.size);
        }];
        
        UILabel * levelDescLabel = [UILabel new];
        levelDescLabel.text = @"等级说明";
        levelDescLabel.font = [UIFont systemFontOfSize:15.f];
        levelDescLabel.textColor = [UIColor whiteColor];
        [levelDescImageView addSubview:levelDescLabel];
        levelDescLabel.textAlignment = NSTextAlignmentCenter;
        [levelDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(levelDescImageView.image.size.height*0.15);
            make.height.mas_equalTo(20);
        }];
        
        UIView * circleView1 = [UIView new];
        circleView1.backgroundColor = [UIColor colorWithHexString:@"0xff611d"];
        circleView1.layer.cornerRadius = 7.5;
        [self addSubview:circleView1];
        [circleView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.top.mas_equalTo(levelDescImageView.mas_bottom).mas_offset(20);
        }];
        UILabel * memberLevelDesc = [UILabel new];
        memberLevelDesc.textColor = circleView1.backgroundColor;
        memberLevelDesc.text = @"会员等级介绍";
        memberLevelDesc.font = [UIFont systemFontOfSize:15];
        [self addSubview:memberLevelDesc];
        [memberLevelDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(circleView1.mas_right).mas_offset(3);
            make.centerY.mas_equalTo(circleView1);
            make.height.mas_equalTo(20);
        }];
        UIView * bottomLine1 = [UIView new];
        bottomLine1.backgroundColor = memberLevelDesc.textColor;
        [self addSubview:bottomLine1];
        [bottomLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(27.5);
            make.top.mas_equalTo(circleView1.mas_bottom).mas_offset(-0.5);
            make.right.mas_equalTo(memberLevelDesc);
            make.height.mas_equalTo(1.f);
        }];
 
        
        UILabel * memberLevelDetailLabel = [UILabel new];
        memberLevelDetailLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        memberLevelDetailLabel.font = [UIFont systemFontOfSize:14.f];
        memberLevelDetailLabel.numberOfLines = 0;
        memberLevelDetailLabel.text = @"会员体系共包含6个会员等级，会员等级由账户待收本金决定。";
        [self addSubview:memberLevelDetailLabel];
        
        [memberLevelDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(bottomLine1.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(-20);
        }];
       
        UIImageView * chartImageView = [UIImageView new];
        NSString * chartImagePath = [[resourcesBundle resourcePath] stringByAppendingPathComponent:@"member_level_chart"];
        chartImageView.image = [UIImage imageWithContentsOfFile:chartImagePath];
        [self addSubview:chartImageView];
        [chartImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(memberLevelDetailLabel.mas_bottom).mas_offset(10);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(chartImageView.mas_width).multipliedBy(chartImageView.image.size.height/chartImageView.image.size.width);
        }];
        
        
        UIView * circleView2 = [UIView new];
        circleView2.backgroundColor = [UIColor colorWithHexString:@"0xff611d"];
        circleView2.layer.cornerRadius = 7.5;
        [self addSubview:circleView2];
        [circleView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.top.mas_equalTo(chartImageView.mas_bottom).mas_offset(20);
        }];
        UILabel * memberLevelDesc2 = [UILabel new];
        memberLevelDesc2.textColor = circleView1.backgroundColor;
        memberLevelDesc2.text = @"说明";
        memberLevelDesc2.font = [UIFont systemFontOfSize:15];
        [self addSubview:memberLevelDesc2];
        [memberLevelDesc2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(circleView2.mas_right).mas_offset(3);
            make.centerY.mas_equalTo(circleView2);
            make.height.mas_equalTo(20);
        }];
        UIView * bottomLine2 = [UIView new];
        bottomLine2.backgroundColor = memberLevelDesc.textColor;
        [self addSubview:bottomLine2];
        [bottomLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(27.5);
            make.top.mas_equalTo(circleView2.mas_bottom).mas_offset(-0.5);
            make.right.mas_equalTo(memberLevelDesc2);
            make.height.mas_equalTo(1.f);
        }];
        
        UILabel * instructionLabel = [UILabel new];
        instructionLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        instructionLabel.numberOfLines = 0;
        [self addSubview:instructionLabel];
        
        [instructionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bottomLine2.mas_bottom).mas_offset(15);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(-10);
        }];
        
        NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 8.f;
        
        NSMutableAttributedString * instructionStr = [[NSMutableAttributedString alloc] initWithString:@"1.特权本金：\n" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.f]}];
        NSAttributedString * instructingStr1 = [[NSAttributedString alloc] initWithString:@"待收本金为您当前账户投资精选项目、尊贵项目及债权转让项目的待收本金总和（不含收益及可用余额）\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        [instructionStr appendAttributedString:instructingStr1];
         NSAttributedString * instructingStr2 = [[NSAttributedString alloc] initWithString:@"2.会员评级规则：\n" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}];
        NSAttributedString * instructingStr3 = [[NSAttributedString alloc] initWithString:@"用户在宏财网进行投资，且待收本金达到会员等级标准，即可拥有对应会员特权。\n如因项目到期，待收本金下降导致的降级，会于次月1日根据待收本金重新计算级别。" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        [instructionStr appendAttributedString:instructingStr2];
        [instructionStr appendAttributedString:instructingStr3];
        [instructionStr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, instructionStr.string.length)];
        instructionLabel.attributedText = instructionStr;
        
    }
    return self;
}
- (void)myButtonClick:(HCMemberCenterButton *)button {
    if (self.buttonClickCallBack) {
        self.buttonClickCallBack((HCMemberCenterButtonType)button.tag);
    }
}
@end
