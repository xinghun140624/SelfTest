//
//  HCAutoTenderTimeCell.m
//  Pods
//
//  Created by Candy on 2017/7/14.
//
//

#import "HCAutoTenderTimeCell.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "NSBundle+HCSettingModule.h"
#import <TYAlertController/TYAlertController.h>
#import "HCAutoTenderDateView.h"
#import "HCTimeTool.h"
NSString * const HCAutoTenderNormalCellFormTimeCell = @"HCAutoTenderNormalCellFormTimeCell";

@interface HCAutoTenderTimeCell()

//标题
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIDatePicker * datePicker;
@end
@implementation HCAutoTenderTimeCell

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[HCAutoTenderTimeCell class] forKey:HCAutoTenderNormalCellFormTimeCell];
}
- (void)configure {
    [super configure];
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.top.mas_equalTo(15.f);
    }];
    

    UIView * leftBgView = [UIView new];
    leftBgView.backgroundColor = [UIColor whiteColor];
    leftBgView.layer.borderWidth = 0.5f;
    leftBgView.layer.borderColor = [UIColor colorWithHexString:@"0xeeeeee"].CGColor;
    leftBgView.layer.cornerRadius = 3.f;
    
    [self.contentView addSubview:leftBgView];
    
    
    
    CGFloat bgViewWidth = (CGRectGetWidth([UIScreen mainScreen].bounds) -40-30)/2.0;
    
    [leftBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(15.f);
        make.left.mas_equalTo(20.f);
        make.width.mas_equalTo(bgViewWidth);
        make.height.mas_equalTo(30.f);
        make.bottom.mas_equalTo(-15.f);
    }];
    

    [leftBgView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 5, 0, 20));
    }];
    
    UIImageView * imageView1 = [[UIImageView alloc] initWithImage:[NSBundle setting_ImageWithName:@"icon_xyb_nor"]];
    [leftBgView addSubview:imageView1];
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftBgView);
        make.size.mas_equalTo(CGSizeMake(10, 19));
        make.right.mas_equalTo(-5.f);
    }];
    
    
    UILabel *daoLabel = [[UILabel alloc] init];
    daoLabel.text = @"到";
    daoLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    daoLabel.font =[UIFont systemFontOfSize:15];
    [self.contentView addSubview:daoLabel];
    [daoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftBgView.mas_right).mas_offset(5);
        make.width.mas_equalTo(20);
        make.centerY.mas_equalTo(leftBgView);
    }];
    
    
    
    UIView * rightBgView = [UIView new];
    rightBgView.backgroundColor = [UIColor whiteColor];
    rightBgView.layer.borderWidth = 0.5f;
    rightBgView.layer.borderColor = [UIColor colorWithHexString:@"0xeeeeee"].CGColor;
    rightBgView.layer.cornerRadius = 3.f;
    [self.contentView addSubview:rightBgView];

    
    [rightBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(daoLabel.mas_right).mas_offset(5.f);
        make.centerY.mas_equalTo(leftBgView);
        make.width.mas_equalTo(bgViewWidth);
        make.height.mas_equalTo(30.f);
    }];
    
    
    [rightBgView addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 5, 0, 20));
    }];
    UIImageView * imageView2 = [[UIImageView alloc] initWithImage:[NSBundle setting_ImageWithName:@"icon_xyb_nor"]];
    [rightBgView addSubview:imageView2];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(rightBgView);
        make.size.mas_equalTo(CGSizeMake(10, 19));
        make.right.mas_equalTo(-5.f);
    }];

    
    
}
-(void)update {
    [super update];
    [self.leftLabel.gestureRecognizers.firstObject setEnabled:!self.rowDescriptor.isDisabled];
    [self.rightLabel.gestureRecognizers.firstObject setEnabled:!self.rowDescriptor.isDisabled];
    
   

    if (self.rowDescriptor.value) {
        self.leftLabel.textColor = [UIColor colorWithHexString:self.rowDescriptor.isDisabled?@"0x666666":@"0xff611d"];
        self.rightLabel.textColor = [UIColor colorWithHexString:self.rowDescriptor.isDisabled?@"0x666666":@"0xff611d"];
        self.leftLabel.text = self.rowDescriptor.value[@"startTime"];
        self.rightLabel.text = self.rowDescriptor.value[@"endTime"];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *startDate = [dateFormatter dateFromString:self.rowDescriptor.value[@"startTime"]];
        NSDate *endDate = [dateFormatter dateFromString:self.rowDescriptor.value[@"endTime"]];

        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"startDate"]= startDate;
        dic[@"endDate"]= endDate;
        dic[@"startTime"]= self.leftLabel.text;
        dic[@"endTime"]= self.rightLabel.text;

        self.rowDescriptor.value = dic;
    }else {
        self.leftLabel.text = @"开始时间";
        self.rightLabel.text = @"结束时间";
        self.leftLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        self.rightLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    }
    self.titleLabel.text =self.rowDescriptor.tag;
}
- (void)leftLabelClick:(UITapGestureRecognizer *)tap {

   
    HCAutoTenderDateView * dateView = [[HCAutoTenderDateView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 250)];
    dateView.minimumDate = [NSDate date];
    if (self.rowDescriptor.value[@"endDate"]) {
        dateView.maximumDate = self.rowDescriptor.value[@"endDate"];
    }
    __weak typeof(self) weakSelf = self;
    dateView.selectTimeCallBack = ^(NSDate *date) {
        NSTimeInterval time = [date timeIntervalSince1970] *1000.0;
        weakSelf.leftLabel.text = [HCTimeTool getDateWithTimeInterval:@(time) andTimeFormatter:@"yyyy-MM-dd"];
         weakSelf.leftLabel.textColor = [UIColor colorWithHexString:self.rowDescriptor.isDisabled?@"0x666666":@"0xff611d"];
        if (self.rowDescriptor.value) {
            NSMutableDictionary * dic = [self.rowDescriptor.value mutableCopy];
            dic[@"startDate"] = date;
            weakSelf.rowDescriptor.value  = dic;
        }else{
            weakSelf.rowDescriptor.value  = @{@"startDate":date};

        }
       
    };
    TYAlertController * alertVC = [TYAlertController alertControllerWithAlertView:dateView preferredStyle:TYAlertControllerStyleActionSheet];
    
    [self.formViewController presentViewController:alertVC animated:YES completion:NULL];

}

- (void)rightLabelClick:(UITapGestureRecognizer *)tap {
    
    
    HCAutoTenderDateView * dateView = [[HCAutoTenderDateView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 250)];
    
    if (self.rowDescriptor.value[@"startDate"]) {
        dateView.minimumDate  = self.rowDescriptor.value[@"startDate"];
    }else{
        dateView.minimumDate  = [NSDate date];

    }
    
    __weak typeof(self) weakSelf = self;

    dateView.selectTimeCallBack = ^(NSDate *date) {
        
        NSTimeInterval time = [date timeIntervalSince1970] *1000.0;
        weakSelf.rightLabel.text = [HCTimeTool getDateWithTimeInterval:@(time) andTimeFormatter:@"yyyy-MM-dd"];
    
        weakSelf.rightLabel.textColor = [UIColor colorWithHexString:self.rowDescriptor.isDisabled?@"0x666666":@"0xff611d"];
        if (self.rowDescriptor.value) {
            NSMutableDictionary * dic = [self.rowDescriptor.value mutableCopy];
            dic[@"endDate"] = date;
            weakSelf.rowDescriptor.value  = dic;
        }else{
            weakSelf.rowDescriptor.value  = @{@"endDate":date};
            
        }
    };
    
    TYAlertController * alertVC = [TYAlertController alertControllerWithAlertView:dateView preferredStyle:TYAlertControllerStyleActionSheet];
    
    [self.formViewController presentViewController:alertVC animated:YES completion:NULL];
    
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:15];
        _leftLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _leftLabel.userInteractionEnabled = YES;
        [_leftLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftLabelClick:)]];
    }
    return _leftLabel;
}
- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:15];
        _rightLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _rightLabel.userInteractionEnabled = YES;
        [_rightLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightLabelClick:)]];

    }
    return _rightLabel;
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




@end

