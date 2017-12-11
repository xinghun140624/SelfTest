//
//  HCUserIdentityView.m
//  HongCai
//
//  Created by Candy on 2017/7/5.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserIdentityView.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
@interface HCUserIdentityView ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *idCardTextField;
@property (nonatomic, strong) UIView *bottomLine1;
@property (nonatomic, strong) UIView *bottomLine2;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;


@end

@implementation HCUserIdentityView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgImageView];
        [self.bgImageView addSubview:self.topLabel];
        [self.bgImageView addSubview:self.nameTextField];
        [self.bgImageView addSubview:self.bottomLine1];
        [self.bgImageView addSubview:self.idCardTextField];
        [self.bgImageView addSubview:self.bottomLine2];
        [self.bgImageView addSubview:self.confirmButton];
        [self.bgImageView addSubview:self.cancelButton];
        
        [self layout_Masonry];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.nameTextField canBecomeFirstResponder]) {
                [self.nameTextField becomeFirstResponder];
            }
        });
        
    }
    return self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.nameTextField==textField) {
        self.bottomLine1.backgroundColor = [UIColor colorWithHexString:@"0xff6000"];
    }else if (self.idCardTextField==textField ){
        self.bottomLine2.backgroundColor = [UIColor colorWithHexString:@"0xff6000"];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.nameTextField==textField) {
        self.bottomLine1.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
    }else if (self.idCardTextField==textField ){
        self.bottomLine2.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)layout_Masonry {
    UIImage * image = [UIImage imageNamed:@"tc_bg-sfrz_nor"];
    CGFloat imageScale = image.size.width/image.size.height;
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds)*0.80;
    
    
    self.frame = CGRectMake(0, 0, width, width/imageScale);
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, width/imageScale));
        make.top.left.mas_equalTo(0);
    }];

    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(width/imageScale*0.25);
        make.centerX.mas_equalTo(self);
    }];
    
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLabel.mas_bottom).mas_offset(width /imageScale *0.08);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
        make.height.mas_equalTo(30);
    }];
    [self.bottomLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameTextField.mas_bottom);
        make.left.right.mas_equalTo(self.nameTextField);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.idCardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomLine1.mas_bottom).mas_offset(width /imageScale *0.08);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
        make.height.mas_equalTo(30);
    }];
    [self.bottomLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.idCardTextField.mas_bottom);
        make.left.right.mas_equalTo(self.nameTextField);
        make.height.mas_equalTo(0.5f);
    }];
    
    CGFloat buttonWidth = width*0.38;
    CGFloat buttonHeight = width *0.38 *66.0/246.0;
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-width/imageScale*0.08);
        make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonHeight));
        self.confirmButton.layer.cornerRadius = buttonHeight/2.0;
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-width/imageScale*0.08);
        make.size.mas_equalTo(self.confirmButton);
        self.cancelButton.layer.cornerRadius = buttonHeight/2.0;
    }];

}
- (void)cancelButtonClick:(UIButton *)button{
    if (self.cancelButtonClickCallBack) {
        self.cancelButtonClickCallBack();
    }
}
- (void)confirmButtonClick:(UIButton *)button {

    if (self.nameTextField.text.length==0) {
        [MBProgressHUD showText:@"请输入您的姓名！"];
        return;
    }
    if (self.idCardTextField.text.length==0) {
        [MBProgressHUD showText:@"请输入您的身份证号！"];
        return;
    }
    if (![self checkUserIdCard:self.idCardTextField.text]) {
        [MBProgressHUD showText:@"请输入合规的身份证号！"];
        return;
    }
    if (self.confirmButtonClickCallBack) {
        self.confirmButtonClickCallBack(@{@"realName":self.nameTextField.text,@"idCardNo":self.idCardTextField.text});
    }
    
    
}
-  (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"^([0-9]{17}[0-9xX]{1})$|^([0-9]{15})$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}



- (UIImageView *)bgImageView {
	if (!_bgImageView) {
        
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tc_bg-sfrz_nor"]];
        _bgImageView.userInteractionEnabled = YES;
	}
	return _bgImageView;
}
- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.text = @"身份认证";
        _topLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
        _topLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return _topLabel;
}
- (UITextField*)nameTextField {
    if (!_nameTextField){
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.borderStyle = UITextBorderStyleNone;
        NSAttributedString * placeholderText = [[NSAttributedString alloc] initWithString:@"请输入你的姓名" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xbfbfbf"]}];
        _nameTextField.attributedPlaceholder = placeholderText;
        _nameTextField.font = [UIFont systemFontOfSize:15];
        _nameTextField.textColor = [UIColor colorWithHexString:@"0x666666"];
        _nameTextField.tintColor = [UIColor colorWithHexString:@"0xbfbfbf"];
        _nameTextField.delegate = self;
    }
    return _nameTextField;
}
- (UIView*)bottomLine1 {
    if (!_bottomLine1){
        _bottomLine1 = [[UIView alloc] init];
        _bottomLine1.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
    }
    return _bottomLine1;
}
- (UITextField*)idCardTextField {
    if (!_idCardTextField){
        _idCardTextField = [[UITextField alloc] init];
        _idCardTextField.borderStyle = UITextBorderStyleNone;
        NSAttributedString * placeholderText = [[NSAttributedString alloc] initWithString:@"请输入你的身份证号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xbfbfbf"]}];
        _idCardTextField.attributedPlaceholder = placeholderText;
        _idCardTextField.font = [UIFont systemFontOfSize:15];
        _idCardTextField.textColor = [UIColor colorWithHexString:@"0x666666"];
        _idCardTextField.tintColor = [UIColor colorWithHexString:@"0xbfbfbf"];
        _idCardTextField.delegate = self;
    }
    return _idCardTextField;
}
- (UIView*)bottomLine2 {
    if (!_bottomLine2){
        _bottomLine2 = [[UIView alloc] init];
        _bottomLine2.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
    }
    return _bottomLine2;
}

- (UIButton *)confirmButton {
	if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _confirmButton.backgroundColor = [UIColor colorWithHexString:@"0xff611d"];
        [_confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _confirmButton;
}


- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"0xff611d"] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        _cancelButton.layer.borderWidth = 1.f;
        _cancelButton.layer.borderColor = _cancelButton.currentTitleColor.CGColor;
        [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
@end
