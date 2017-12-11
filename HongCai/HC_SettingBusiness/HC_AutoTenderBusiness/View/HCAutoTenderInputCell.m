//
//  HCAutoTenderInputCell.m
//  Pods
//
//  Created by Candy on 2017/7/14.
//
//

#import "HCAutoTenderInputCell.h"

#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>

NSString * const HCAutoTenderNormalCellFormInputCell = @"HCAutoTenderNormalCellFormInputCell";

@interface HCAutoTenderInputCell()<UITextFieldDelegate>
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//转让金额
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UILabel *statuLabel;
@property (nonatomic, strong) UIView * line;

@end
@implementation HCAutoTenderInputCell


+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[HCAutoTenderInputCell class] forKey:HCAutoTenderNormalCellFormInputCell];
}
- (void)configure {
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.top.mas_equalTo(15.f);
    }];
    
    
    
    UIView * bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 0.5f;
    bgView.layer.borderColor = [UIColor colorWithHexString:@"0xeeeeee"].CGColor;
    bgView.layer.cornerRadius = 3.f;
    
    [self.contentView addSubview:bgView];
    [bgView addSubview:self.inputTextField];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(20.f);
        make.centerY.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(-20.f);
        make.height.mas_equalTo(35.f);
    }];
    
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 10, 0, 40));
    }];
    
    
    
    UILabel *yuanLabel = [[UILabel alloc] init];
    yuanLabel.text = @"元";
    yuanLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    yuanLabel.font =[UIFont systemFontOfSize:15];
    [bgView addSubview:yuanLabel];
    
    [yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8.f);
        make.centerY.mas_equalTo(bgView);
    }];
    [self.contentView addSubview:self.line];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.right.mas_equalTo(-20.f);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    
    [self.contentView addSubview:self.statuLabel];
    
    [self.statuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_bottom).mas_offset(5.f);
        make.left.mas_equalTo(bgView.mas_left).mas_offset(5.f);
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.rowDescriptor.tag isEqualToString:@"最小投资金额"]) {
        self.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        self.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;

    }
}
- (void)textFieldDidChange {
    NSString * inputText = self.inputTextField.text;
    if ([self.rowDescriptor.tag isEqualToString:@"最小投资金额"]) {
        if (inputText.length >0) {
            self.rowDescriptor.value = inputText;
        }
        if ([inputText integerValue]%100==0) {
            self.statuLabel.text = @"";
        }else if([inputText integerValue]>1000000){
            self.statuLabel.text = @"最小投资金额不能超过1000000";
        }else{
            self.statuLabel.text = @"请输入100的正整数倍";

        }
    }else if ([self.rowDescriptor.tag isEqualToString:@"账户保留金额"]) {
        if (inputText.length >0) {
            self.rowDescriptor.value = inputText;
        }else if([inputText doubleValue]>1000000){
            self.statuLabel.text = @"账户保留金额不能超过1000000";
        }
    }
}

#define kMaxAmount 1000000

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    BOOL isHaveDian = NO;
    if ([textField.text containsString:@"."]) {
        isHaveDian = YES;
    }else{
        isHaveDian = NO;
    }
    
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.'))
        {
            return NO;
        }
        
        // 只能有一个小数点
        if (isHaveDian && single == '.') {
            return NO;
        }
        
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > 1) {
                    return NO;
                }
            }
        }
        
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.inputTextField resignFirstResponder];
    return YES;
}

+ (CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    return 65;
}
-(void)update {
    [super update];
    self.inputTextField.textColor = [UIColor colorWithHexString:self.rowDescriptor.isDisabled?@"0x666666":@"0xff611d"];

    
    if ([self.rowDescriptor.tag isEqualToString:@"最小投资金额"]) {
        NSAttributedString * placeholderText = [[NSAttributedString alloc] initWithString:@"请输入100的正整数倍" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xbfbfbf"]}];
        self.inputTextField.attributedPlaceholder = placeholderText;
    }else{
        NSAttributedString * placeholderText = [[NSAttributedString alloc] initWithString:@"请输入账户保留金额" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xbfbfbf"]}];
        self.inputTextField.attributedPlaceholder = placeholderText;
    }
    
     [self.inputTextField setEnabled:!self.rowDescriptor.isDisabled];
    if (self.rowDescriptor.value) {
        NSDecimalNumber * value = self.rowDescriptor.value;
        
        self.inputTextField.text = [NSString stringWithFormat:@"%zd",[value integerValue]];
    }
    self.titleLabel.text =self.rowDescriptor.tag;
}
- (UIView *)line {
    if (!_line) {
        _line =[[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"0xefefef"];
    }
    return _line;
}

- (UILabel *)statuLabel {
    if (!_statuLabel) {
        _statuLabel = [[UILabel alloc] init];
        _statuLabel.font = [UIFont systemFontOfSize:10];
        _statuLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
    }
    return _statuLabel;
}
- (UILabel*)titleLabel {
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _titleLabel;
}
- (UITextField *)inputTextField {
    if (!_inputTextField){
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.font = [UIFont systemFontOfSize:15.f];
        _inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _inputTextField.borderStyle = UITextBorderStyleNone;
        _inputTextField.textColor = [UIColor colorWithHexString:@"0xff611d"];
        _inputTextField.delegate = self;
    }
    return _inputTextField;
}



@end

