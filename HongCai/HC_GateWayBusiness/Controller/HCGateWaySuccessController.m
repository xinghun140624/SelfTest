//
//  HCGateWaySuccessController.m
//  HC_GateWayBusiness
//
//  Created by Candy on 2017/7/7.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCGateWaySuccessController.h"
#import "HCGateWaySuccessView.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import <HCMyInvesetmentBusiness_Category/CTMediator+HCMyInvesetmentBusiness.h>
#import "HCHomeService.h"
#import "NSBundle+HCGateWayModule.h"
@interface HCGateWaySuccessController ()
@property (nonatomic, strong) HCGateWaySuccessView *successView;

@end

@implementation HCGateWaySuccessController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    
    [self.successView.leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.successView.rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.successView];
    NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"HCGateWaySuccessController")];
    
    NSString *path = [mainBundle pathForResource:@"SuccessConfig" ofType:@"plist"];
    
    [self.successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    
    NSDictionary * data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    if (self.successParams) {
        NSString * business = self.successParams[@"business"];
        NSDictionary  * dic = data[business];

       
        UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        if ([dic.allKeys containsObject:@"title"]) {
            titleLabel.attributedText = [[NSAttributedString alloc]initWithString:dic[@"title"] attributes:[UINavigationBar appearance].titleTextAttributes];
            [titleLabel sizeToFit];
            self.navigationItem.titleView =titleLabel;
        }
    
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] init];
        
        if ([business isEqualToString:@"PERSONAL_REGISTER"]) {
            NSString * desc = [NSString stringWithFormat:@"恭喜您，成功开通存管账号！"];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:desc];
            [string appendAttributedString:attr];
            self.successView.descLabel.attributedText = attr;
        }else if ([business isEqualToString:@"RECHARGE"]) {
            NSString * desc = [NSString stringWithFormat:@"恭喜您，成功充值%.2f元",[self.successParams[@"amount"] doubleValue]];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:desc];
            
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0xff611d"] range:NSMakeRange(8, desc.length-9)];
            
            [string appendAttributedString:attr];
            self.successView.descLabel.attributedText = attr;
        }else if ([business isEqualToString:@"TRANSFER"]){
            
            [self handlerInvestSuccess];
            
        }else if ([business isEqualToString:@"RECHARGE_AUTH_TENDER"]) {
            
            if ([self.successParams.allKeys containsObject:@"status"]) {
                if ([self.successParams[@"status"] integerValue]==1) {
                    [self handlerInvestSuccess];
                }else{
                    [self handlerInvestFailue];
                }
            }
            
        }else if ([business isEqualToString:@"WITHDRAW"]){
            NSString * moneyStr = [NSString stringWithFormat:@"%.2f",[self.successParams[@"amount"] doubleValue]];
            NSString * desc = [NSString stringWithFormat:@"恭喜您，成功提现%@元",moneyStr];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:desc];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0xff611d"] range:NSMakeRange(8, moneyStr.length)];
            [string appendAttributedString:attr];
            self.successView.descLabel.attributedText = attr;
        }
        
        [self layoutWithButtontitles:dic[@"actionNames"]];

    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    
    __block BOOL ContainRechargeVC = NO;
    __block BOOL ContainTransferDetail = NO;
    __block UIViewController * transferDetailVC = nil;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"HCCreditorTransferDetailController")]) {
            ContainTransferDetail = YES;
            transferDetailVC = obj;
        }
        if ([obj isKindOfClass:NSClassFromString(@"HCRechargeController")]) {
            ContainRechargeVC = YES;
        }
    }];
    
    if (ContainRechargeVC && ContainTransferDetail) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToViewController:transferDetailVC animated:YES];
        });
        return;
    }
    
}



- (void)handlerInvestFailue {
    
    
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] init];
    
    if ([self.successParams.allKeys containsObject:@"rechargeAmount"]) {
        
        UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"投资失败" attributes:[UINavigationBar appearance].titleTextAttributes];
        [titleLabel sizeToFit];
        self.navigationItem.titleView =titleLabel;
        
        NSString * moneyStr = [NSString stringWithFormat:@"%.2f",[self.successParams[@"rechargeAmount"] doubleValue]];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10.f;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        
        NSString * desc = [NSString stringWithFormat:@"投资失败了...\n请稍后重试，本次充值金额%@元",moneyStr];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:desc];
        
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0xff611d"] range:NSMakeRange(desc.length-moneyStr.length-1, moneyStr.length)];
        
        [string appendAttributedString:attr];
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attr.length)];
        
        self.successView.descLabel.attributedText = attr;
        self.successView.iconView.image = [NSBundle gateWay_ImageWithName:@"tzsb_icon_nor"];
    }
    
    
    
}
//投资成功
- (void)handlerInvestSuccess {
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] init];
    NSString * moneyStr = [NSString stringWithFormat:@"%.2f",[self.successParams[@"amount"] doubleValue]];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10.f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    if ([self.successParams.allKeys containsObject:@"coupon"]) {
        
        if ([self.successParams[@"coupon"][@"type"] integerValue]==1) {
            
            NSString * desc = [NSString stringWithFormat:@"恭喜您，成功投资%@元\n开始计息！\n额外加息%.2f%%",moneyStr,[self.successParams[@"coupon"][@"value"] doubleValue]];
            NSInteger duration =  [self.successParams[@"coupon"][@"duration"] integerValue];
            
            if (duration >0) {
                desc = [desc stringByAppendingFormat:@"项目期限内前%zd天加息",duration];
            }else {
                desc = [desc stringByAppendingString:@"项目期限内全程加息"];
            }

            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:desc];
            
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0xff611d"] range:NSMakeRange(8, moneyStr.length)];
            [string appendAttributedString:attr];
            [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attr.length)];
            
            self.successView.descLabel.attributedText = attr;
            
        }else if ([self.successParams[@"coupon"][@"type"] integerValue]==2) {
            
            NSString * desc = [NSString stringWithFormat:@"恭喜您，成功投资%@元\n开始计息！额外奖励%.2f元",moneyStr,[self.successParams[@"coupon"][@"value"] doubleValue]];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:desc];
            
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0xff611d"] range:NSMakeRange(8, moneyStr.length)];
            
            [string appendAttributedString:attr];
            [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attr.length)];
            
            self.successView.descLabel.attributedText = attr;
        }
        
    }else {
        NSString * desc = [NSString stringWithFormat:@"恭喜您，成功投资%@元,\n开始计息！",moneyStr];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:desc];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0xff611d"] range:NSMakeRange(8, moneyStr.length)];
        [string appendAttributedString:attr];
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attr.length)];
        if ([self.successParams.allKeys containsObject:@"privilegesRewards"]) {
            NSAttributedString *privilegesRewardsString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n获得特权奖励：%@",self.successParams[@"privilegesRewards"]]];
            [attr appendAttributedString:privilegesRewardsString];
        }
        self.successView.descLabel.attributedText = attr;
    }
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"投资成功" attributes:[UINavigationBar appearance].titleTextAttributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
}
- (void)buttonClick:(UIButton *)button {
    if ([button.currentTitle isEqualToString:@"去投资"]) {
        UITabBarController * tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        tabBarVC.selectedIndex = 1;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }else if ([button.currentTitle isEqualToString:@"我的投资"]) {
        UITabBarController * tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        tabBarVC.selectedIndex = 3;
        UIViewController * controller = [[CTMediator sharedInstance] HCMyInvesetmentBusiness_viewController];
        [(UINavigationController *)tabBarVC.selectedViewController pushViewController:controller animated:NO];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }else if ([button.currentTitle isEqualToString:@"逛逛首页"]) {
        UITabBarController * tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        tabBarVC.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }else if ([button.currentTitle isEqualToString:@"我的账户"]){
        UITabBarController * tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        tabBarVC.selectedIndex = 3;
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }else if ([button.currentTitle isEqualToString:@"去充值"]) {
        UITabBarController * tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;

        if (tabBarVC.selectedIndex==3) {
            UINavigationController * navVC = (UINavigationController *)tabBarVC.selectedViewController;
            UIViewController * controller = [NSClassFromString(@"HCRechargeController") new];
            [navVC setViewControllers:@[navVC.viewControllers.firstObject,controller]];
            
        }else{
            UIViewController * controller = [NSClassFromString(@"HCRechargeController") new];
            tabBarVC.selectedIndex = 3;
            [(UINavigationController *)tabBarVC.selectedViewController pushViewController:controller animated:NO];
        }
       
    }
    
}
- (void)layoutWithButtontitles:(NSArray *)tittles{
    
    [self.successView.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50.f);
        make.centerX.mas_equalTo(self.successView);
        
    }];
    [self.successView.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.successView.iconView.mas_bottom).mas_offset(40.f);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.centerX.mas_equalTo(self.successView);
    }];
    if (tittles.count==1) {
        
        [self.successView.leftButton setTitle:tittles.firstObject forState:UIControlStateNormal];
        [self.successView.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.successView);
            make.top.mas_equalTo(self.successView.descLabel.mas_bottom).mas_offset(60.f);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds)-40);
            self.successView.leftButton.layer.cornerRadius = 20.f;
        }];
    }else{
        
        [self.successView.leftButton setTitle:tittles.firstObject forState:UIControlStateNormal];
        [self.successView.rightButton setTitle:tittles.lastObject forState:UIControlStateNormal];
        
        NSArray * buttons = @[self.successView.leftButton,self.successView.rightButton];
        [buttons mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.successView.leftButton.mas_width).multipliedBy(85.0/316.0);
            make.top.mas_equalTo(self.successView.descLabel.mas_bottom).mas_offset(60.f);
        }];
        [buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:CGRectGetWidth([UIScreen mainScreen].bounds)*(316.0/750.0) leadSpacing:20 tailSpacing:20];
        
    }
    
}


- (HCGateWaySuccessView *)successView {
    if (!_successView) {
        _successView = [[HCGateWaySuccessView alloc] initWithFrame:CGRectZero];
    }
    return _successView;
}


@end
