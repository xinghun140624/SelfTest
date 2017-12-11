//
//  HCCalendarCell.m
//  HongCai
//
//  Created by 郭金山 on 2017/10/25.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCalendarCell.h"
#import "NSBundle+HCCalendarModule.h"
#import <FSCalendar/FSCalendarExtensions.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
@implementation HCCalendarCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *hkImageView = [[UIImageView alloc] initWithImage:[NSBundle calendar_ImageWithName:@"_e-icon_hkrq"]];
        [self.contentView insertSubview:hkImageView atIndex:0];
        self.hkImageView = hkImageView;
        
        //        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        //        self.backgroundView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.subtitle) {
        CGFloat titleHeight = self.titleLabel.font.lineHeight;
        CGFloat subtitleHeight = self.subtitleLabel.font.lineHeight;
        
        CGFloat height = titleHeight + subtitleHeight;
        self.titleLabel.frame = CGRectMake(
                                           self.preferredTitleOffset.x,
                                           (self.contentView.fs_height*5.5/6.0-height)*0.5+self.preferredTitleOffset.y,
                                           self.contentView.fs_width,
                                           titleHeight
                                           );
        self.subtitleLabel.frame = CGRectMake(
                                              self.preferredSubtitleOffset.x,
                                              (self.titleLabel.fs_bottom-self.preferredTitleOffset.y) - (self.titleLabel.fs_height-self.titleLabel.font.pointSize)+self.preferredSubtitleOffset.y,
                                              self.contentView.fs_width,
                                              subtitleHeight
                                              );
    } else {
        self.titleLabel.frame = CGRectMake(
                                           self.preferredTitleOffset.x,
                                           self.preferredTitleOffset.y,
                                           self.contentView.fs_width,
                                           floor(self.contentView.fs_height*5.5/6.0)
                                           );
    }
    
    if (self.selectionType == SelectionTypeNone) {
        
        self.hkImageView.hidden = YES;
        [self configureAppearance];
    } else if (self.selectionType == SelectionTypeHK) {
        self.hkImageView.hidden = NO;
        UIImage * image = [NSBundle calendar_ImageWithName:@"_e-icon_hkrq"];
        self.hkImageView.fs_width = image.size.width*0.8;
        self.hkImageView.fs_height = image.size.height*0.8;
        
        self.hkImageView.center = self.titleLabel.center;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"0xfffc00"];
        self.titleLabel.font = [UIFont systemFontOfSize:8.5];
        self.titleLabel.frame = CGRectMake(
                                           self.preferredTitleOffset.x,
                                           self.preferredTitleOffset.y+3,
                                           self.contentView.fs_width,
                                           floor(self.contentView.fs_height*5.5/6.0)
                                           );
    }


    
}



- (void)setSelectionType:(SelectionType)selectionType
{
    _selectionType = selectionType;

    [self setNeedsLayout];
}



@end
