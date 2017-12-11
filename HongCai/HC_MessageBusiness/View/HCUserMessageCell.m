//
//  HCUserMessageCell.m
//  HC_MessageBusiness
//
//  Created by Candy on 2017/7/3.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserMessageCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "NSBundle+HCMessageModule.h"
#import <Masonry/Masonry.h>
#import "HCUserMessageModel.h"
#import "HCTimeTool.h"

@interface HCPasteLabel : UILabel

@end

@implementation HCPasteLabel

-(BOOL)canBecomeFirstResponder {
    
    return YES;
}

// 可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(newFunc)) {
        return YES;
    }
    return NO;
}
//UILabel默认是不接收事件的，我们需要自己添加touch事件
-(void)attachTapHandler {
    
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:touch];
}
- (void)dealloc {
}
//绑定事件
- (id)init {
    self = [super init];
    if (self) {
        [self attachTapHandler];
    }
    return self;
}

-(void)awakeFromNib {
    
    [super awakeFromNib];
    [self attachTapHandler];
}

-(void)handleTap:(UIGestureRecognizer*) recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        return;
    }else if (recognizer.state == UIGestureRecognizerStateBegan){
        [self becomeFirstResponder];
        if ([UIMenuController sharedMenuController].isMenuVisible) {
            return;
        }
        UIMenuItem * item = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(newFunc)];
        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
        [UIMenuController sharedMenuController].menuItems = @[item];
        [UIMenuController sharedMenuController].menuVisible = YES;
    }
}

-(void)newFunc{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}


    
@end




@interface HCUserMessageCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) HCPasteLabel *contentLabel;
@property (nonatomic, strong) UIImageView *noticeBgView;

@end
@implementation HCUserMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.noticeBgView];
        [self.noticeBgView addSubview:self.contentLabel];
        [self layout_Masonry];
    }
    return self;
}
- (void)setModel:(HCUserMessageModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[HCTimeTool getDateWithTimeInterval:model.createTime andTimeFormatter:@"yyyy-MM-dd HH:mm:ss"]];
    self.contentLabel.text = model.content;
    
}
- (void)layout_Masonry {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20.f);
        make.left.mas_equalTo(20.f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(15);
    }];
    [self.noticeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(self.contentView).mas_offset(20);
        make.right.mas_equalTo(self.contentView).mas_offset(-20);
        make.bottom.mas_equalTo(-20);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.bottom.mas_equalTo(-10.f);
    }];

}

- (void)hc_copy {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.model.content;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        _timeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _timeLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (HCPasteLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[HCPasteLabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
- (UIImageView *)noticeBgView {
    if (!_noticeBgView) {
        UIImage * image = [NSBundle message_ImageWithName:@"message-box.c77a754b"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(40, 40, 0, 0) resizingMode:UIImageResizingModeTile];
        
        _noticeBgView = [[UIImageView alloc] initWithImage:image];
        _noticeBgView.userInteractionEnabled = YES;
        [_noticeBgView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    }
    return _noticeBgView;
}

@end
