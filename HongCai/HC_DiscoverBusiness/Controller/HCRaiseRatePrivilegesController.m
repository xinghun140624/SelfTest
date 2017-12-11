//
//  HCRaiseRatePrivilegesController.m
//  HongCai
//
//  Created by Candy on 2017/11/22.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCRaiseRatePrivilegesController.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "HCMemberCenterHelper.h"
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "HCMemberWelfareRuleModel.h"
#import "HCMemberWelfareApi.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
@interface HCMemberRaiseRateView : UIButton
@property (nonatomic, strong) UIImageView * backgroundImageView;
@property (nonatomic, strong) UILabel * rateLabel;
@property (nonatomic, strong) UILabel * rateDescLabel;
@property (nonatomic, strong) UILabel * investDescLabel;
@property (nonatomic, strong) UILabel * minInvestDescLabel;
@property (nonatomic, strong) UILabel * lingQuLabel;
@end
@implementation HCMemberRaiseRateView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.backgroundImageView];
        [self.backgroundImageView addSubview:self.rateLabel];
        [self.backgroundImageView addSubview:self.rateDescLabel];
        [self.backgroundImageView addSubview:self.investDescLabel];
        [self.backgroundImageView addSubview:self.minInvestDescLabel];
        [self.backgroundImageView addSubview:self.lingQuLabel];
        
        CGFloat width = (CGRectGetWidth([UIScreen mainScreen].bounds)- 50)*0.5;
        CGFloat height = width *78.5/162.7;
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(self.backgroundImageView.mas_width).multipliedBy(78.5/162.7);
        }];
        [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(width*0.30);
            make.top.mas_equalTo(15.f);
        }];
        [self.rateDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.rateLabel);
            make.top.mas_equalTo(self.rateLabel.mas_bottom).mas_offset(5);
        }];
        [self.investDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(height*0.2);
            make.left.mas_equalTo(width * 0.30);
            make.right.mas_equalTo(0);
        }];
        [self.minInvestDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.investDescLabel.mas_bottom).mas_offset(2);
            make.left.mas_equalTo(self.investDescLabel);
            make.right.mas_equalTo(0);
        }];
        [self.lingQuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(64, 16));
            make.centerX.mas_equalTo(self.minInvestDescLabel);
            make.top.mas_equalTo(self.minInvestDescLabel.mas_bottom).mas_offset(4);
        }];
    }
    return self;
}
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
    }
    return _backgroundImageView;
}
- (UILabel *)rateLabel {
    if (!_rateLabel) {
        _rateLabel  = [[UILabel alloc] init];
        _rateLabel.font = [UIFont systemFontOfSize:15.f];
        _rateLabel.textColor = [UIColor whiteColor];
        _rateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rateLabel;
}
- (UILabel *)rateDescLabel {
    if (!_rateDescLabel) {
        _rateDescLabel = [[UILabel alloc] init];
        _rateDescLabel.font = [UIFont systemFontOfSize:11];
        _rateDescLabel.textColor = [UIColor whiteColor];
        _rateDescLabel.text = @"加息券";
        _rateDescLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _rateDescLabel;
}
- (UILabel *)investDescLabel {
    if (!_investDescLabel) {
        _investDescLabel = [[UILabel alloc] init];
        _investDescLabel.font = [UIFont systemFontOfSize:11];
        _investDescLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _investDescLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _investDescLabel;
}
- (UILabel *)minInvestDescLabel {
    if (!_minInvestDescLabel) {
        _minInvestDescLabel = [[UILabel alloc] init];
        _minInvestDescLabel.font = [UIFont systemFontOfSize:11];
        _minInvestDescLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _minInvestDescLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _minInvestDescLabel;
}
- (UILabel *)lingQuLabel {
    if (!_lingQuLabel) {
        _lingQuLabel = [[UILabel alloc] init];
        _lingQuLabel.font = [UIFont systemFontOfSize:11.f];
        _lingQuLabel.textColor = [UIColor whiteColor];
        _lingQuLabel.textAlignment = NSTextAlignmentCenter;
        _lingQuLabel.backgroundColor = [UIColor colorWithHexString:@"0xff611d"];
        _lingQuLabel.text = @"立即领取";
        _lingQuLabel.layer.cornerRadius = 8.f;
        _lingQuLabel.layer.masksToBounds = YES;
    }
    return _lingQuLabel;
}
@end

@interface HCRaiseRatePrivilegesSectionView:UIView
@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UILabel * middleLabel;
@property (nonatomic, strong) UILabel * rightLabel;
@end

@implementation HCRaiseRatePrivilegesSectionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UILabel * leftLabel = [[UILabel alloc] init];
        leftLabel.font = [UIFont systemFontOfSize:14];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        self.leftLabel = leftLabel;
        [self addSubview:leftLabel];
        
        UILabel * middleLabel = [[UILabel alloc] init];
        middleLabel.font = [UIFont systemFontOfSize:14];
        middleLabel.textAlignment = NSTextAlignmentCenter;
        middleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        self.middleLabel = middleLabel;
        [self addSubview:middleLabel];
        
        UILabel * rightLabel = [[UILabel alloc] init];
        rightLabel.font = [UIFont systemFontOfSize:14];
        rightLabel.textAlignment = NSTextAlignmentCenter;
        rightLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        self.rightLabel = rightLabel;
        [self addSubview: rightLabel];
        
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.width.mas_equalTo(self).multipliedBy(0.3);
            make.height.mas_equalTo(self);
        }];
        [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(self.leftLabel.mas_right);
            make.right.mas_equalTo(self.rightLabel.mas_left);
            make.height.mas_equalTo(self);
        }];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(0);
            make.width.mas_equalTo(self).multipliedBy(0.4);
            make.height.mas_equalTo(self);
        }];
    }
    return self;
}

@end



@interface HCRaiseRatePrivilegesController ()
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, weak) UILabel * myPrivilegesLabel;
@property (nonatomic, strong) NSMutableArray <MASConstraint *>* heightConstraint;
@property (nonatomic, strong) HCMemberRaiseRateView * leftRateView;
@property (nonatomic, strong) HCMemberRaiseRateView * rightRateView;
@property (nonatomic, strong) HCMemberWelfareModel *welfareModel;
@end

@implementation HCRaiseRatePrivilegesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollView = [UIScrollView new];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11,*)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        }else {
            make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        }
        make.left.right.mas_equalTo(0);
        if (@available(iOS 11,*)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-49);
        }else {
            make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).mas_offset(-49);
        }
    }];
    UILabel * titleLabel =  [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"专享加息券" attributes:[UINavigationBar appearance].titleTextAttributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.heightConstraint = [NSMutableArray array];
    [self setupSubViews];
    [self requestData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIButton * investButton = [UIButton buttonWithType:UIButtonTypeSystem];
    investButton.backgroundColor = [UIColor colorWithHexString:@"0xFA4918"];
    [investButton setTintColor:[UIColor whiteColor]];
    [investButton setTitle:@"立即投资" forState:UIControlStateNormal];
    investButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [investButton addTarget:self action:@selector(investButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:investButton];
    [investButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(49);
        if (@available(iOS 11,*)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else {
            make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop);
        }
    }];

}
- (void)investButtonClick:(UIButton *)investButton {
    UITabBarController * tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBarVC.selectedIndex = 1;
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)rateViewClick:(HCMemberRaiseRateView *)rateView {
    NSString * token = [[CTMediator sharedInstance] HCUserBusiness_getUser][@"token"];
    HCMemberWelfareRuleModel * ruleModel = nil;
    if (rateView==self.leftRateView) {
        ruleModel = self.welfareModel.welfareRules.firstObject;
    }else {
        ruleModel = self.welfareModel.welfareRules.lastObject;
    }
    NSInteger userId = [[[CTMediator sharedInstance] HCUserBusiness_getUser][@"id"] integerValue];
    HCMemberWelfareApi * api = [[HCMemberWelfareApi alloc] initWithToken:token userId:userId memberWelfareId:self.welfareModel.memberWelfareId number:ruleModel.number];
    [MBProgressHUD showLoadingFromView:self.view];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseJSONObject) {
            NSDictionary * dic = request.responseJSONObject;
            
            if ([dic.allKeys containsObject:@"number"]) {
                //领取成功；
                UIAlertController * alertVC =[UIAlertController alertControllerWithTitle:@"" message:@"领取成功！可前往我的优惠券查看～" preferredStyle:UIAlertControllerStyleAlert];
                [alertVC addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:NULL]];
                [self.navigationController presentViewController:alertVC animated:YES completion:NULL];
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (request.responseJSONObject) {
            if (request.responseStatusCode==400) {
                UIAlertController * alertVC =[UIAlertController alertControllerWithTitle:@"" message:request.responseJSONObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                [alertVC addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:NULL]];
                [self.navigationController presentViewController:alertVC animated:YES completion:NULL];
            }
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];
    
   
}
- (void)requestData {
    [MBProgressHUD showFullScreenLoadingView:self.view];
    [HCMemberCenterHelper requestMemberCenterWelfareTypesData:self.level completion:^(NSArray *models) {
        if (models.count) {
            [models enumerateObjectsUsingBlock:^(HCMemberWelfareModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (model.type==1) {
                  
                        self.welfareModel = model;
                        NSURL * leftImgUrl = [NSURL URLWithString:[model.welfareRules.firstObject imgUrl]];
                        
                        [self.leftRateView.backgroundImageView sd_setImageWithURL:leftImgUrl placeholderImage:[UIImage imageNamed:@"logo_zwf_nor"]];
                        [self.rightRateView.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[model.welfareRules.lastObject imgUrl]] placeholderImage:[UIImage imageNamed:@"logo_zwf_nor"]];
                        
                        self.leftRateView.investDescLabel.text = @"投资项目：精选";
                        self.rightRateView.investDescLabel.text = @"投资项目：尊贵";
                        NSMutableAttributedString * leftRateString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[[model.welfareRules.firstObject amount] floatValue]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]}];
                        [leftRateString appendAttributedString:[[NSAttributedString alloc] initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.f]}]];
                        self.leftRateView.rateLabel.attributedText = leftRateString;
                        
                        NSMutableAttributedString * rightRateString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[[model.welfareRules.lastObject amount]floatValue]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]}];
                        [rightRateString appendAttributedString:[[NSAttributedString alloc] initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.f]}]];
                        self.rightRateView.rateLabel.attributedText = rightRateString;
                        self.leftRateView.minInvestDescLabel.text = [NSString stringWithFormat:@"起投金额：%zd",[model.welfareRules.firstObject minInvestAmount]];
                        self.rightRateView.minInvestDescLabel.text = [NSString stringWithFormat:@"起投金额：%zd",[model.welfareRules.lastObject minInvestAmount]];
                        
                    
                }
            }];
        }else{
            self.myPrivilegesLabel.text = @"规则说明";
            self.leftRateView.hidden = YES;
            self.rightRateView.hidden = YES;
            [self setupPrivilegesBgView];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];

}
- (void)setupSubViews {
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"0xfff1bf"];
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"HCDiscoverController")];
    NSBundle *resourcesBundle = [NSBundle bundleWithPath:[bundle pathForResource:@"HCDiscoverBusinessImage" ofType:@"bundle"]];
    UIView * contentView = [UIView new];
    [self.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
    }];
    UIImageView * bgImageView = [UIImageView new];
    NSString * withDrawBgImagePath = [[resourcesBundle resourcePath] stringByAppendingPathComponent:@"member_raiseRate_bg"];
    bgImageView.image = [UIImage imageWithContentsOfFile:withDrawBgImagePath];
    [contentView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    
    UIView * bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.cornerRadius = 15;
    [self.scrollView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgImageView.mas_bottom);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    
    UIImageView * levelDescImageView = [UIImageView new];
    NSString * levelDescImagePath = [[resourcesBundle resourcePath] stringByAppendingPathComponent:@"level_desc"];
    levelDescImageView.image = [UIImage imageWithContentsOfFile:levelDescImagePath];
    [bottomView addSubview:levelDescImageView];
    [levelDescImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(bottomView);
        make.size.mas_equalTo(levelDescImageView.image.size);
    }];
    
    
    UILabel * myPrivilegesLabel = [UILabel new];
    myPrivilegesLabel.text = @"我的特权";
    myPrivilegesLabel.font = [UIFont systemFontOfSize:15.f];
    myPrivilegesLabel.textColor = [UIColor whiteColor];
    self.myPrivilegesLabel = myPrivilegesLabel;
    [levelDescImageView addSubview:myPrivilegesLabel];
    myPrivilegesLabel.textAlignment = NSTextAlignmentCenter;
    [myPrivilegesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(levelDescImageView.image.size.height*0.15);
        make.height.mas_equalTo(20);
    }];
    
    HCMemberRaiseRateView * leftView = [[HCMemberRaiseRateView alloc] init];
    [leftView addTarget:self action:@selector(rateViewClick:) forControlEvents:UIControlEventTouchUpInside];
    self.leftRateView = leftView;
    
    HCMemberRaiseRateView * rightView = [[HCMemberRaiseRateView alloc] init];
    self.rightRateView = rightView;
    [rightView addTarget:self action:@selector(rateViewClick:) forControlEvents:UIControlEventTouchUpInside];
    NSArray * views = @[leftView,rightView];
    [bottomView addSubview:leftView];
    [bottomView addSubview:rightView];
    
    [views mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:12 tailSpacing:12];
    __block MASConstraint * heightConstraint = nil;
    [views mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat width = 0;

        if ([UIScreen mainScreen].bounds.size.width==320) {
            width =  (CGRectGetWidth([UIScreen mainScreen].bounds)-20)*0.5;
        }else {
            width =  (CGRectGetWidth([UIScreen mainScreen].bounds)-20- 34)*0.5;
        }
        heightConstraint =  make.height.mas_equalTo(width *78.5/162.7).priorityHigh();
        [self.heightConstraint addObject:heightConstraint];
        make.top.mas_equalTo(levelDescImageView.mas_bottom).mas_offset(8.f);
    }];
    
    
    //
    UILabel * firstLabel = [[UILabel alloc] init];
    firstLabel.text = @"1";
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.textColor = [UIColor whiteColor];
    firstLabel.backgroundColor = [UIColor colorWithHexString:@"0xff611d"];
    firstLabel.font = [UIFont boldSystemFontOfSize:15.f];
    firstLabel.layer.cornerRadius = 10.f;
    firstLabel.layer.masksToBounds = YES;
    [bottomView addSubview:firstLabel];
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(leftView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(18);
    }];
    
    UILabel * firstDescLabel = [[UILabel alloc] init];
    firstDescLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    firstDescLabel.numberOfLines = 0;
    [bottomView addSubview:firstDescLabel];
    
    NSMutableAttributedString * firstStr = [[NSMutableAttributedString alloc] initWithString:@"不同等级会员可领取相应级别的专属加息券，会员等级越高，可领取的加息幅度越高；"
                                                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    NSMutableParagraphStyle * paragraph = [NSMutableParagraphStyle new];
    paragraph.lineSpacing = 8.f;
    [firstStr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, firstStr.string.length)];
    firstDescLabel.attributedText = firstStr;
    
    [firstDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.firstBaseline.mas_equalTo(firstLabel);
        make.left.mas_equalTo(firstLabel.mas_right).mas_offset(3);
        make.right.mas_equalTo(-18);
    }];
    
    
    //
    UILabel * secondLabel = [[UILabel alloc] init];
    secondLabel.text = @"2";
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.textColor = [UIColor whiteColor];
    secondLabel.backgroundColor = [UIColor colorWithHexString:@"0xff611d"];
    secondLabel.font = [UIFont boldSystemFontOfSize:15.f];
    secondLabel.layer.cornerRadius = 10.f;
    secondLabel.layer.masksToBounds = YES;
    [bottomView addSubview:secondLabel];
    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(firstDescLabel.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(18);
    }];
    
    UILabel * secondDescLabel = [[UILabel alloc] init];
    secondDescLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    secondDescLabel.numberOfLines = 0;
    [bottomView addSubview:secondDescLabel];
    
    NSMutableAttributedString * secondStr = [[NSMutableAttributedString alloc] initWithString:@"点击领取后，加息券将自动发放至用户的账户中，请到[我的]页面>>[优惠券]中查看；"
                                                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    [secondStr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, secondStr.string.length)];
    secondDescLabel.attributedText = secondStr;
    
    [secondDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.firstBaseline.mas_equalTo(secondLabel);
        make.left.mas_equalTo(firstLabel.mas_right).mas_offset(3);
        make.right.mas_equalTo(-18);
    }];
    
    //
    UILabel * thirdLabel = [[UILabel alloc] init];
    thirdLabel.text = @"3";
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    thirdLabel.textColor = [UIColor whiteColor];
    thirdLabel.backgroundColor = [UIColor colorWithHexString:@"0xff611d"];
    thirdLabel.font = [UIFont boldSystemFontOfSize:15.f];
    thirdLabel.layer.cornerRadius = 10.f;
    thirdLabel.layer.masksToBounds = YES;
    [bottomView addSubview:thirdLabel];
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(secondDescLabel.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(18);
    }];
    
    UILabel * thirdDescLabel = [[UILabel alloc] init];
    thirdDescLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    thirdDescLabel.numberOfLines = 0;
    [bottomView addSubview:thirdDescLabel];
    
    NSMutableAttributedString * thirdStr = [[NSMutableAttributedString alloc] initWithString:@"领取会员专属加息券后，请于有效期内及时使用，即领即用更方便。"
                                                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    [thirdStr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, thirdStr.string.length)];
    thirdDescLabel.attributedText = thirdStr;
    
    [thirdDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.firstBaseline.mas_equalTo(thirdLabel);
        make.left.mas_equalTo(secondLabel.mas_right).mas_offset(3);
        make.right.mas_equalTo(-18);
    }];
    
    
    UIImageView * privilegesDetailImageView = [UIImageView new];
    privilegesDetailImageView.image = [UIImage imageWithContentsOfFile:levelDescImagePath];
    [bottomView addSubview:privilegesDetailImageView];
    [privilegesDetailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thirdDescLabel.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(bottomView);
        make.size.mas_equalTo(privilegesDetailImageView.image.size);
    }];
    
    
    UILabel * privilegesDetailLabel = [UILabel new];
    privilegesDetailLabel.text = @"特权详情";
    privilegesDetailLabel.font = [UIFont systemFontOfSize:15.f];
    privilegesDetailLabel.textColor = [UIColor whiteColor];
    [privilegesDetailImageView addSubview:privilegesDetailLabel];
    privilegesDetailLabel.textAlignment = NSTextAlignmentCenter;
    [privilegesDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(privilegesDetailImageView.image.size.height*0.15);
        make.height.mas_equalTo(20);
    }];
    
    HCRaiseRatePrivilegesSectionView * sectionView1 = [HCRaiseRatePrivilegesSectionView new];
    sectionView1.backgroundColor = [UIColor colorWithHexString:@"0xfeefe9"];
    sectionView1.leftLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
    sectionView1.leftLabel.text = @"会员等级";
    sectionView1.middleLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
    sectionView1.middleLabel.text = @"精选加息";
    sectionView1.rightLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
    sectionView1.rightLabel.text = @"尊贵加息";
    [bottomView addSubview:sectionView1];

    [sectionView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(privilegesDetailImageView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];


    HCRaiseRatePrivilegesSectionView * sectionView2 = [HCRaiseRatePrivilegesSectionView new];
    sectionView2.backgroundColor = [UIColor whiteColor];
    sectionView2.leftLabel.text = @"青铜";
    sectionView2.middleLabel.text = @"0.3%";
    sectionView2.rightLabel.text = @"0.5%";
    [bottomView addSubview:sectionView2];

    [sectionView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sectionView1.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];


    HCRaiseRatePrivilegesSectionView * sectionView3 = [HCRaiseRatePrivilegesSectionView new];
    sectionView3.backgroundColor = [UIColor colorWithHexString:@"0xfeefe9"];
    sectionView3.leftLabel.text = @"白银";
    sectionView3.middleLabel.text = @"0.5%";
    sectionView3.rightLabel.text = @"0.8%";
    [bottomView addSubview:sectionView3];

    [sectionView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sectionView2.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];


    HCRaiseRatePrivilegesSectionView * sectionView4 = [HCRaiseRatePrivilegesSectionView new];
    sectionView4.backgroundColor = [UIColor whiteColor];
    sectionView4.leftLabel.text = @"黄金";
    sectionView4.middleLabel.text = @"0.7%";
    sectionView4.rightLabel.text = @"1.7%";
    [bottomView addSubview:sectionView4];

    [sectionView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sectionView3.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];


    HCRaiseRatePrivilegesSectionView * sectionView5 = [HCRaiseRatePrivilegesSectionView new];
    sectionView5.backgroundColor = [UIColor colorWithHexString:@"0xfeefe9"];
    sectionView5.leftLabel.text = @"铂金";
    sectionView5.middleLabel.text = @"0.8%";
    sectionView5.rightLabel.text = @"1.8%";
    [bottomView addSubview:sectionView5];

    [sectionView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sectionView4.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];

    HCRaiseRatePrivilegesSectionView * sectionView6 = [HCRaiseRatePrivilegesSectionView new];
    sectionView6.backgroundColor = [UIColor whiteColor];
    sectionView6.leftLabel.text = @"钻石";
    sectionView6.middleLabel.text = @"1%";
    sectionView6.rightLabel.text = @"2%";
    [bottomView addSubview:sectionView6];
    
    [sectionView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sectionView5.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
        make.bottom.mas_equalTo(-15);
    }];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottomView.mas_bottom).mas_offset(15);
    }];
}
- (void)setupPrivilegesBgView {
    self.heightConstraint[0].mas_equalTo(CGSizeZero);
}
@end
