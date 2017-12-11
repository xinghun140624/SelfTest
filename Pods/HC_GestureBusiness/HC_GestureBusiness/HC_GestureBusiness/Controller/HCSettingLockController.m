//
//  HCSettingLockController.m
//  HongCai
//
//  Created by Candy on 2017/8/11.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCSettingLockController.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"
#import "PCCircleInfoView.h"
#import "PCCircle.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <HCLoginBusiness_Category/CTMediator+HCLoginBusiness.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import "HCSettingGestureService.h"
#import "NSBundle+HCGestureBusiness.h"
@interface HCSettingLockController ()<UINavigationControllerDelegate, CircleViewDelegate>
{
    NSInteger _remainCount;
}
@property (nonatomic, strong) UIImageView * bgImageView;//背景图
@property (nonatomic, strong) UIButton * resetButton;//重置按钮
@property (nonatomic, strong) PCLockLabel *msgLabel;//提示Label
@property (nonatomic, strong) PCCircleView *lockView;//解锁
@property (nonatomic, strong) UILabel * welcomeLabel;
@end


@implementation HCSettingLockController

-  (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[NSBundle gesture_ImageWithName:@"gesture_bg"]];
        _bgImageView.frame = [UIScreen mainScreen].bounds;
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // 1.界面相同部分生成器
    [self setupSameUI];
    
    // 2.界面不同部分生成器
    [self setupDifferentUI];
    [self.view insertSubview:self.bgImageView atIndex:0];

}

#pragma mark - 界面不同部分生成器
- (void)setupDifferentUI
{
    switch (self.type) {
        case GestureViewControllerTypeRecommand:
            [self setupSubViewsSettingVc:YES];
            break;
        case GestureViewControllerTypeSetting:
            [self setupSubViewsSettingVc:NO];
            break;
        case GestureViewControllerTypeLogin:
            _remainCount = 5;
            [self setupSubViewsLoginVc];
            break;
        case GestureViewControllerTypeVerify:
            [self setupSubViewsVerifyVc];
            break;
        case GestureViewControllerTypeVerifyAndDelete:
            [self setupSubViewsVerifyAndDeleteVC];
            break;
        default:
            break;
    }
}

#pragma mark - 界面相同部分生成器
- (void)setupSameUI
{
   
    
    // 解锁界面
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    self.lockView = lockView;
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 20);
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
}
- (void)jumpButtonClick {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"手势密码可在我的>>设置>>密码管理中开启" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     
        NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
        
        NSString *userGestureKey = [NSString stringWithFormat:@"%@_%zd",@"HC_JumpGesturePassword",[user[@"id"] integerValue]];
        
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:userGestureKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.dimissCallBack) {
                self.dimissCallBack();
            }
        }];
        
    }];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:NULL];


}

#pragma mark - 设置手势密码界面
- (void)setupSubViewsSettingVc:(BOOL)isRecommand
{
    if (isRecommand) {
        
        UIButton * jumpButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [jumpButton setTitle:@"跳过" forState:UIControlStateNormal];
        [jumpButton setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
        jumpButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [jumpButton addTarget:self action:@selector(jumpButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:jumpButton];
        [jumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(20);
            make.width.mas_equalTo(45);
            make.height.mas_equalTo(40);
        }];
        [self.lockView setType:CircleViewTypeRecommand];

    }else{
        [self.lockView setType:CircleViewTypeSetting];
    }
    [self.msgLabel showNormalMsg:@"请绘制新的手势密码"];
    
    // 头像
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 65, 65);
    imageView.center = CGPointMake(kScreenW/2, kScreenH/5);
    [imageView setImage:[NSBundle gesture_ImageWithName:@"gesture_logo"]];
    [self.view addSubview:imageView];
    
    // 管理手势密码
    UIButton *resetBtn = [UIButton new];
    [self creatButton:resetBtn frame:CGRectMake((kScreenW -100)/2.0, kScreenH - 60, 100, 20) title:@"重新绘制" alignment:UIControlContentHorizontalAlignmentCenter tag:buttonTagReset];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [resetBtn setTitleColor:[UIColor colorWithHexString:@"0xff6000"] forState:UIControlStateNormal];
    self.resetButton = resetBtn;
    self.resetButton.hidden  = YES;
}

#pragma mark - 登陆手势密码界面
- (void)setupSubViewsLoginVc
{
    [self.lockView setType:CircleViewTypeLogin];
    [self.msgLabel showNormalMsg:@"请绘制手势密码"];

    // 头像
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 65, 65);
    imageView.center = CGPointMake(kScreenW/2, kScreenH/5-35);
    [imageView setImage:[NSBundle gesture_ImageWithName:@"gesture_logo"]];
    [self.view addSubview:imageView];
    
    UILabel * welcomeLabel = [[UILabel alloc] init];
    welcomeLabel.text = @"您好，欢迎回来";
    welcomeLabel.font =  [UIFont systemFontOfSize:24];
    welcomeLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    self.welcomeLabel = welcomeLabel;
    [self.view addSubview:self.welcomeLabel];
    
    [self.welcomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(5);
        make.centerX.mas_equalTo(self.view);
    }];
    
    UIButton *forgetBtn = [UIButton new];
    [forgetBtn setTitle:@"忘记手势密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
    [forgetBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [forgetBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    forgetBtn.tag = buttonTagForget;

    [self.view addSubview:forgetBtn];
    
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.bottom.mas_equalTo(-40);
    }];
    
    
    UIButton *changeUserButton = [UIButton new];
    [changeUserButton setTitle:@"换个账号登录" forState:UIControlStateNormal];
    [changeUserButton setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
    [changeUserButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [changeUserButton addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    changeUserButton.tag = buttonTagChangeUser;
    [self.view addSubview:changeUserButton];
    
    [changeUserButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.bottom.mas_equalTo(-40);
    }];

    
}
- (void)setupSubViewsVerifyVc {
    [self.lockView setType:CircleViewTypeVerify];
    [self.msgLabel showNormalMsg:@"请绘制原手势密码"];
    
    // 头像
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 65, 65);
    imageView.center = CGPointMake(kScreenW/2, kScreenH/5);
    [imageView setImage:[NSBundle gesture_ImageWithName:@"gesture_logo"]];
    [self.view addSubview:imageView];
}
- (void)setupSubViewsVerifyAndDeleteVC {
    [self.lockView setType:CircleViewTypeVerifyAndDelete];
    [self.msgLabel showNormalMsg:@"请绘制当前手势密码"];
    
    // 头像
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 65, 65);
    imageView.center = CGPointMake(kScreenW/2, kScreenH/5);
    [imageView setImage:[NSBundle gesture_ImageWithName:@"gesture_logo"]];
    [self.view addSubview:imageView];

}


#pragma mark - 创建UIButton
- (void)creatButton:(UIButton *)btn frame:(CGRect)frame title:(NSString *)title alignment:(UIControlContentHorizontalAlignment)alignment tag:(NSInteger)tag
{
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:alignment];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didClickRightItem {
    NSLog(@"点击了重设按钮");
    // 1.隐藏按钮
    self.resetButton.hidden = YES;
    
    
    // 3.msgLabel提示文字复位
    [self.msgLabel showNormalMsg:@"请绘制新的手势密码"];
    
    // 4.清除之前存储的密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
}

#pragma mark - button点击事件
- (void)didClickBtn:(UIButton *)sender
{
    NSLog(@"%ld", (long)sender.tag);
    switch (sender.tag) {
        case buttonTagChangeUser:
        {
            [[CTMediator sharedInstance] HCUserBusiness_removeUser];
            [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"isHideMoney"];
            
            [self dismissViewControllerAnimated:NO completion:^{
                
                UIViewController * controller = [[CTMediator sharedInstance] HCLoginBusiness_viewController];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:NO completion:NULL];
                
            }];
            
        }
            break;
        case buttonTagForget:
        {
        
        
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"重置手势密码，需要重新登录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [HCSettingGestureService deleteUserGesture:^(BOOL success) {
                    if (success) {
                        NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
                        NSString *userGestureKey = [NSString stringWithFormat:@"%@_%zd",@"HC_JumpGesturePassword",[user[@"id"] integerValue]];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:userGestureKey];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [[CTMediator sharedInstance] HCUserBusiness_removeUser];
                        [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"isHideMoney"];
                        [self dismissViewControllerAnimated:NO completion:^{
                            UIViewController * controller = [[CTMediator sharedInstance] HCLoginBusiness_viewController];
                            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:NULL];
                            
                        }];
                    }
                }];
            }];
            UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:NULL];
        
        }
            
            break;
        case buttonTagReset:{
            [self.msgLabel showNormalMsg:@"请绘制新的手势密码"];
            self.resetButton.hidden = YES;
            [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];

        }
            break;
        default:
            break;
    }
}

#pragma mark - circleView - delegate
#pragma mark - circleView - delegate - setting
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
{
    NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];
    
    // 看是否存在第一个密码
    if ([gestureOne length]) {
        self.resetButton.hidden = NO;
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        NSLog(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesingWithGesture:(NSString *)gesture {

    if (type==CircleViewTypeSetting || type == CircleViewTypeRecommand) {
        
        [self.msgLabel showWarnMsg:@"手势密码至少绘制4个点"];
    }
}
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
{
    NSLog(@"获得第一个手势密码%@", gesture);
    [self.msgLabel showNormalMsg:gestureTextDrawAgain];
    
    // infoView展示对应选中的圆
//    [self infoViewSelectedSubviewsSameAsCircleView:view];
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
{
    NSLog(@"获得第二个手势密码%@",gesture);
    
    if (equal) {
        
        NSLog(@"两次手势匹配！可以进行本地化保存了");
        
        
       
        
        
        [self.msgLabel showWarnMsg:gestureTextSetSuccess];

        
        [HCSettingGestureService updateUserGesture:gesture success:^(BOOL success) {
            if (success) {
                [self dismissViewControllerAnimated:YES completion:^{
                    if (self.dimissCallBack) {
                        self.dimissCallBack();
                    }
                }];
            }
        }];
        
    } else {
        NSLog(@"两次手势不匹配！");
        
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
        self.resetButton.hidden = NO;

    }
}
#pragma mark - circleView - delegate - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    
    // 此时的type有两种情况 Login or verify
    if (type == CircleViewTypeLogin) {
        
        if (equal) {
            if (self.dimissCallBack) {
                self.dimissCallBack();
            }
            [self dismissViewControllerAnimated:YES completion:NULL];
            
        } else {
            NSLog(@"密码错误！");
            if (_remainCount>1) {
                [self.msgLabel showWarnMsgAndShake:[NSString stringWithFormat:@"手势密码绘制错误，还可再绘制%zd次",--_remainCount]];
            }else{
                
                [HCSettingGestureService deleteUserGesture:^(BOOL success) {
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"手势密码已失效，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                        NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
                        NSString *userGestureKey = [NSString stringWithFormat:@"%@_%zd",@"HC_JumpGesturePassword",[user[@"id"] integerValue]];
                         [[NSUserDefaults standardUserDefaults] removeObjectForKey:userGestureKey];
                        
                        [[CTMediator sharedInstance] HCUserBusiness_removeUser];
                        [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"isHideMoney"];
                        
                        [self dismissViewControllerAnimated:NO completion:^{
                            
                            UIViewController * controller = [[CTMediator sharedInstance] HCLoginBusiness_viewController];
                            
                            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:NO completion:NULL];
                            
                        }];
                        
                    }];
                    [alert addAction:action];
                    
                    [self presentViewController:alert animated:YES completion:NULL];
                }];
            }
        }
    } else if (type == CircleViewTypeVerify) {
        
        if (equal) {
            // 管理手势密码
            UIButton *resetBtn = [UIButton new];
            [self creatButton:resetBtn frame:CGRectMake((kScreenW -100)/2.0, kScreenH - 60, 100, 20) title:@"重新绘制" alignment:UIControlContentHorizontalAlignmentCenter tag:buttonTagReset];
            resetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [resetBtn setTitleColor:[UIColor colorWithHexString:@"0xff6000"] forState:UIControlStateNormal];
            self.resetButton = resetBtn;
            self.resetButton.hidden  = YES;

            self.type = GestureViewControllerTypeSetting;
            [self.lockView setType:CircleViewTypeSetting];
            [self.msgLabel showNormalMsg:@"请绘制新的手势密码"];
        } else {
            [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
            
        }
    }else if (type==CircleViewTypeVerifyAndDelete) {
    
        if (equal) {
            //
            
            [HCSettingGestureService deleteUserGesture:^(BOOL success) {
                if (success) {
                    [self dismissViewControllerAnimated:YES completion:NULL];
                    [MBProgressHUD showText:@"手势密码已关闭！"];
                }
            }];
            
        }else{
            [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
        
        }
    
    }
}


@end

