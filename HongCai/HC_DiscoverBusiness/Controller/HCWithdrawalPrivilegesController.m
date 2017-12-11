//
//  HCWithdrawalPrivilegesController.m
//  HongCai
//
//  Created by Candy on 2017/11/22.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCWithdrawalPrivilegesController.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import "HCMemberCenterHelper.h"

@interface HCWithdrawalPrivilegesSectionView:UIView
@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UILabel * rightLabel;
@end

@implementation HCWithdrawalPrivilegesSectionView

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
        
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(0);
            make.width.mas_equalTo(self).multipliedBy(0.7);
            make.height.mas_equalTo(self);
        }];
        
    }
    return self;
}


@end

@interface HCWithdrawalPrivilegesController ()
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, weak) UILabel * myPrivilegesLabel;
@property (nonatomic, strong) UIImageView *privilegesBgView;
@property (nonatomic, strong) NSMutableArray <MASConstraint *>*privilegesBgViewHeightConstraintArray;
@property (nonatomic, strong) UILabel * titleLabel ;
@property (nonatomic, strong) UILabel * detailLabel ;

@end

@implementation HCWithdrawalPrivilegesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.privilegesBgViewHeightConstraintArray = [NSMutableArray new];
    
    
    [MBProgressHUD showFullScreenLoadingView:self.view];
    [HCMemberCenterHelper requestMemberCenterWelfareTypesData:self.level completion:^(NSArray *models) {
        [models enumerateObjectsUsingBlock:^(HCMemberWelfareModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
            NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"HCDiscoverController")];
            NSBundle *resourcesBundle = [NSBundle bundleWithPath:[bundle pathForResource:@"HCDiscoverBusinessImage" ofType:@"bundle"]];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"免费提现/月"];
            if (model.type==3 && model.status==1) {
                switch (self.level) {
                    case 4:
                    {
                        self.titleLabel.text = @"黄金会员";
                        [attrString insertAttributedString:[[NSAttributedString alloc] initWithString:@"1次" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xff611d"]}] atIndex:4];
                        NSString * withDrawImagePath = [[resourcesBundle resourcePath] stringByAppendingPathComponent:@"member_withdraw_hj"];
                        self.privilegesBgView.image = [UIImage imageWithContentsOfFile:withDrawImagePath];
                    }
                        break;
                    case 5:
                    {
                        self.titleLabel.text = @"铂金会员";
                        [attrString insertAttributedString:[[NSAttributedString alloc] initWithString:@"2次" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xff611d"]}] atIndex:4];
                        NSString * withDrawImagePath = [[resourcesBundle resourcePath] stringByAppendingPathComponent:@"member_withdraw_bj"];
                        self.privilegesBgView.image = [UIImage imageWithContentsOfFile:withDrawImagePath];
                    }
                        break;
                    case 6:
                    {
                        self.titleLabel.text = @"钻石会员";
                        [attrString insertAttributedString:[[NSAttributedString alloc] initWithString:@"3次" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xff611d"]}] atIndex:4];
                        NSString * withDrawImagePath = [[resourcesBundle resourcePath] stringByAppendingPathComponent:@"member_withdraw_zs"];
                        self.privilegesBgView.image = [UIImage imageWithContentsOfFile:withDrawImagePath];
                    }
                        break;
                }
                self.detailLabel.attributedText = attrString;
                [self setupPrivilegesBgView];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }];
    UILabel * titleLabel =  [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"免费提现" attributes:[UINavigationBar appearance].titleTextAttributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    
    
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
    [self setupSubViews];
    
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
    NSString * withDrawBgImagePath = [[resourcesBundle resourcePath] stringByAppendingPathComponent:@"member_withdrawal_bg"];
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
    myPrivilegesLabel.text = @"规则说明";
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
    
    UIImageView * privilegesBgView = [UIImageView new];
    self.privilegesBgView = privilegesBgView;
    NSString * withDrawImagePath = [[resourcesBundle resourcePath] stringByAppendingPathComponent:@"member_withdraw_zs"];
    UIImage * myImage = [UIImage imageWithContentsOfFile:withDrawImagePath];
    [bottomView addSubview:privilegesBgView];
    MASConstraint __block *sizeConstraint = nil;

    [privilegesBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(levelDescImageView.mas_bottom).mas_offset(15);
        make.centerX.mas_equalTo(bottomView);
        sizeConstraint =  make.size.mas_equalTo(CGSizeZero);
        
        [_privilegesBgViewHeightConstraintArray addObject:sizeConstraint];
    }];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel = titleLabel;
    [privilegesBgView addSubview:titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(myImage.size.height*0.18);
        make.width.mas_equalTo(myImage.size.width*0.65);
    }];
    UILabel * detailLabel = [[UILabel alloc] init];
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.font = [UIFont systemFontOfSize:17];
    self.detailLabel = detailLabel;
    [privilegesBgView addSubview:detailLabel];
   
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(myImage.size.height*0.18);
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
        make.top.mas_equalTo(privilegesBgView.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(18);
    }];
    
    UILabel * firstDescLabel = [[UILabel alloc] init];
    firstDescLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    firstDescLabel.numberOfLines = 0;
    [bottomView addSubview:firstDescLabel];
    
    NSMutableAttributedString * firstStr = [[NSMutableAttributedString alloc] initWithString:@"当用户达到一定会员等级时，每月可享受相应免费提现次数，超出后，依旧按照2元/每笔收取提现手续费；" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
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
    
    NSMutableAttributedString * secondStr = [[NSMutableAttributedString alloc] initWithString:@"每月可享免费提现次数由当月会员等级决定，如遇等级提升，则可立即升级享受相应免费提现特权；" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
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
    
    NSMutableAttributedString * thirdStr = [[NSMutableAttributedString alloc] initWithString:@"每月可享免费提现次数由当月会员等级决定，如遇等级提升，则可立即升级享受相应免费提现特权；" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
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
    
    
    
    HCWithdrawalPrivilegesSectionView * sectionView1 = [HCWithdrawalPrivilegesSectionView new];
    sectionView1.backgroundColor = [UIColor colorWithHexString:@"0xfeefe9"];
    sectionView1.leftLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
    sectionView1.leftLabel.text = @"会员等级";
    sectionView1.rightLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
    sectionView1.rightLabel.text = @"提现特权";
    [bottomView addSubview:sectionView1];
    
    [sectionView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(privilegesDetailImageView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];
    
    
    HCWithdrawalPrivilegesSectionView * sectionView2 = [HCWithdrawalPrivilegesSectionView new];
    sectionView2.backgroundColor = [UIColor whiteColor];
    sectionView2.leftLabel.text = @"黄金";
    sectionView2.rightLabel.text = @"享免费提现次数 1次/月";
    [bottomView addSubview:sectionView2];
    
    [sectionView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sectionView1.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];
    
    
    HCWithdrawalPrivilegesSectionView * sectionView3 = [HCWithdrawalPrivilegesSectionView new];
    sectionView3.backgroundColor = [UIColor colorWithHexString:@"0xfeefe9"];
    sectionView3.leftLabel.text = @"铂金";
    sectionView3.rightLabel.text = @"享免费提现次数 2次/月";
    [bottomView addSubview:sectionView3];
    
    [sectionView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sectionView2.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];
    
    
    HCWithdrawalPrivilegesSectionView * sectionView4 = [HCWithdrawalPrivilegesSectionView new];
    sectionView4.backgroundColor = [UIColor whiteColor];
    sectionView4.leftLabel.text = @"钻石";
    sectionView4.rightLabel.text = @"享免费提现次数 3次/月";
    [bottomView addSubview:sectionView4];
    
    [sectionView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sectionView3.mas_bottom);
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
    UIImage *image = self.privilegesBgView.image;
    self.myPrivilegesLabel.text = @"我的特权";

    self.privilegesBgViewHeightConstraintArray[0].mas_equalTo(image.size);
    [self.privilegesBgView setNeedsLayout];
}
@end
