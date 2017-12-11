//
//  HCBirthdayPrivilegesController.m
//  HongCai
//
//  Created by Candy on 2017/11/22.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCBirthdayPrivilegesController.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import "HCMemberCenterHelper.h"
@interface HCBirthdayPrivilegesSectionView:UIView
@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UILabel * middleLabel;
@property (nonatomic, strong) UILabel * rightLabel;
@end

@implementation HCBirthdayPrivilegesSectionView

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


@interface HCBirthdayPrivilegesController ()
@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation HCBirthdayPrivilegesController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"生日福利" attributes:[UINavigationBar appearance].titleTextAttributes];
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
    [self setupSubViews];
  
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
    NSString * withDrawBgImagePath = [[resourcesBundle resourcePath] stringByAppendingPathComponent:@"member_birthday_bg"];
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
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(18);
    }];
    
    UILabel * firstDescLabel = [[UILabel alloc] init];
    firstDescLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    firstDescLabel.numberOfLines = 0;
    [bottomView addSubview:firstDescLabel];
    
    NSMutableAttributedString * firstStr = [[NSMutableAttributedString alloc] initWithString:@"会员等级在白银及以上级别的用户，在生日当天可获得宏财网送上的生日福利，等级越高，福利越高；" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
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
    
    NSMutableAttributedString * secondStr = [[NSMutableAttributedString alloc] initWithString:@"用户生日以实名认证的身份证信息为准；" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
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
    
    NSMutableAttributedString * thirdStr = [[NSMutableAttributedString alloc] initWithString:@"生日福利额度由用户生日当天0点的会员等级决定，提前升级更划算哟。" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    [thirdStr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, thirdStr.string.length)];
    thirdDescLabel.attributedText = thirdStr;
    
    [thirdDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.firstBaseline.mas_equalTo(thirdLabel);
        make.left.mas_equalTo(secondLabel.mas_right).mas_offset(3);
        make.right.mas_equalTo(-18);
    }];
    
    
    UIImageView * privilegesDetailImageView = [UIImageView new];
    NSString * levelDescImagePath = [[resourcesBundle resourcePath] stringByAppendingPathComponent:@"level_desc"];
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
    
    HCBirthdayPrivilegesSectionView * sectionView1 = [HCBirthdayPrivilegesSectionView new];
    sectionView1.backgroundColor = [UIColor colorWithHexString:@"0xfeefe9"];
    sectionView1.leftLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
    sectionView1.leftLabel.text = @"会员等级";
    sectionView1.middleLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
    sectionView1.middleLabel.text = @"特权本金";
    sectionView1.rightLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
    sectionView1.rightLabel.text = @"有效期";
    [bottomView addSubview:sectionView1];
    
    [sectionView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(privilegesDetailImageView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];
    
    
    HCBirthdayPrivilegesSectionView * sectionView2 = [HCBirthdayPrivilegesSectionView new];
    sectionView2.backgroundColor = [UIColor whiteColor];
    sectionView2.leftLabel.text = @"白银";
    sectionView2.middleLabel.text = @"2888元";
    sectionView2.rightLabel.text = @"3天";
    [bottomView addSubview:sectionView2];
    
    [sectionView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sectionView1.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];
    
    
    HCBirthdayPrivilegesSectionView * sectionView3 = [HCBirthdayPrivilegesSectionView new];
    sectionView3.backgroundColor = [UIColor colorWithHexString:@"0xfeefe9"];
    sectionView3.leftLabel.text = @"黄金";
    sectionView3.middleLabel.text = @"6666元";
    sectionView3.rightLabel.text = @"6天";
    [bottomView addSubview:sectionView3];
    
    [sectionView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sectionView2.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];
    
    
    HCBirthdayPrivilegesSectionView * sectionView4 = [HCBirthdayPrivilegesSectionView new];
    sectionView4.backgroundColor = [UIColor whiteColor];
    sectionView4.leftLabel.text = @"铂金";
    sectionView4.middleLabel.text = @"8888元";
    sectionView4.rightLabel.text = @"12天";
    [bottomView addSubview:sectionView4];
    
    [sectionView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sectionView3.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];
    
    
    HCBirthdayPrivilegesSectionView * sectionView5 = [HCBirthdayPrivilegesSectionView new];
    sectionView5.backgroundColor = [UIColor colorWithHexString:@"0xfeefe9"];
    sectionView5.leftLabel.text = @"钻石";
    sectionView5.middleLabel.text = @"18888元";
    sectionView5.rightLabel.text = @"15天";
    [bottomView addSubview:sectionView5];
    
    [sectionView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sectionView4.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
        make.bottom.mas_equalTo(-15);
    }];
 
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottomView.mas_bottom).mas_offset(15);
    }];
}
@end
