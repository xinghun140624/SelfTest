

#import "HCMemberCenterHeaderView.h"
#import "NSBundle+HCDiscoverModule.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <iCarousel/iCarousel.h>
#import "HCMemberInfoModel.h"
#import "HCAccountModel.h"

@interface HCMemberCenterHeaderView ()<iCarouselDataSource,iCarouselDelegate>
{
    UIImageView * _contentView;
    UILabel * _memberDescLabel;
    UILabel * _memberDesc2Label;
    UILabel * _nameLabel;
    UILabel * _nextLevelLabel;
    UIImageView * _nextLevelImageView;
}
@property (nonatomic, strong) iCarousel * icarouselView;
@property (nonatomic, strong) UIButton * raiseButton;
@property (nonatomic, strong) NSArray * levelNamesArray;


@property (nonatomic, strong) UILabel * currentInvestLabel;
@property (nonatomic, strong) UIButton * descButton;
@property (nonatomic, strong) UIProgressView * progressView;
@end


@implementation HCMemberCenterHeaderView



- (UILabel *)currentInvestLabel {
    if (!_currentInvestLabel) {
        _currentInvestLabel = [[UILabel alloc] init];
        _currentInvestLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _currentInvestLabel.font = [UIFont systemFontOfSize:10];
    }
    return _currentInvestLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.trackTintColor = [UIColor colorWithHexString:@"0xf4f2f0"];
        _progressView.progressTintColor = [UIColor colorWithHexString:@"0xfecb2f"];
        _progressView.transform = CGAffineTransformScale(_progressView.transform, 1, 3);
        _progressView.layer.cornerRadius = 3.f;
        _progressView.layer.masksToBounds = YES;
    }
    return _progressView;
}
- (UIButton *)descButton {
    if (!_descButton) {
        _descButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_descButton setImage:[NSBundle discover_ImageWithName:@"member_raise"] forState:UIControlStateNormal];
        _descButton.userInteractionEnabled = NO;
        _descButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_descButton setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
    }
    return _descButton;
}

- (void)setMemberInfoModel:(HCMemberInfoModel *)memberInfoModel {
    if (_memberInfoModel != memberInfoModel) {
        _memberInfoModel = memberInfoModel;
        NSInteger level = memberInfoModel.currentLevel.level;
        [self.icarouselView reloadData];
        [self.icarouselView setCurrentItemIndex:level-1];
        if (level==6) {
            if (self.centerController.heightConstraint.firstObject) {
                MASConstraint * height = self.centerController.heightConstraint.firstObject;
                height.mas_equalTo(200);
                [self layoutIfNeeded];
                [self setNeedsLayout];
            }
          
        }
        
        self.currentInvestLabel.text = [NSString stringWithFormat:@"%zd/%.0f",self.accountModel.waitingCapital.integerValue,memberInfoModel.nextLevel.minInvestAmount];
        self.progressView.progress = self.accountModel.waitingCapital.floatValue/memberInfoModel.nextLevel.minInvestAmount;
        NSString * buttonTitle = nil;
        if (memberInfoModel.nextLevel.minInvestAmount<10000) {
            buttonTitle = [NSString stringWithFormat:@"在投总资产达到%.0f元即可升至下一级哦",memberInfoModel.nextLevel.minInvestAmount];
        }else {
            buttonTitle = [NSString stringWithFormat:@"在投总资产达到%.0f万元即可升至下一级哦",memberInfoModel.nextLevel.minInvestAmount/10000.0];
        }
        [self.descButton setTitle:buttonTitle forState:UIControlStateNormal];
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.levelNamesArray = @[@"普通",@"青铜",@"白银",@"黄金",@"铂金",@"钻石"];
        [self addSubview:self.icarouselView];
        [self addSubview:self.currentInvestLabel];
        [self addSubview:self.progressView];
        [self addSubview:self.descButton];

        
        [self.currentInvestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.icarouselView.mas_bottom).mas_offset(20);
            make.centerX.mas_equalTo(self);
        }];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.icarouselView).mas_offset(60);
            make.right.mas_equalTo(self.icarouselView).mas_offset(-60);
            make.top.mas_equalTo(self.currentInvestLabel.mas_bottom).mas_offset(5);
        }];
        
        [self.descButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.progressView.mas_bottom).mas_offset(10);
            make.centerX.mas_equalTo(self);
        }];
        

    }
    return self;
}
- (iCarousel *)icarouselView {
    if (!_icarouselView) {
        _icarouselView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 180)];
        _icarouselView.dataSource = self;
        _icarouselView.delegate = self;
        _icarouselView.type = iCarouselTypeCustom;
        _icarouselView.pagingEnabled = YES;
        _icarouselView.bounces =NO;
    }
    return _icarouselView;
}
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return 6;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {

    if (!view) {
        _contentView =[UIImageView new];
        _contentView.userInteractionEnabled = YES;
        _contentView.tag = 100;
        NSString * bgImageName = [NSString stringWithFormat:@"member_level_%zd",index+1];
        NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"HCDiscoverController")];
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"HCDiscoverBusinessImage" ofType:@"bundle"]];
        NSString * bgImagePath = [[resourcesBundle resourcePath] stringByAppendingPathComponent:bgImageName];
        
        UIImage * bgImage = [UIImage imageWithContentsOfFile:bgImagePath];
        _contentView.image = bgImage;
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds)*0.8;
        CGFloat height = width *365.0/616.0;

        _contentView.frame = CGRectMake(0, 0, width,height);
        
        _contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        _contentView.layer.shadowOpacity = 0.4f;
        _contentView.layer.shadowRadius = 4.f;
        _contentView.layer.shadowOffset = CGSizeMake(0,3);
        //路径阴影
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(4,height-3)];
        //添加直线
        [path addLineToPoint:CGPointMake(width/2.0-4, height)];
        [path addLineToPoint:CGPointMake(width-4,height-3)];

        //设置阴影路径
        _contentView.layer.shadowPath = path.CGPath;


        _memberDescLabel = [[UILabel alloc] init];
        _memberDescLabel.tag = 200;
        _memberDescLabel.textColor = [UIColor whiteColor];
        _memberDescLabel.font = [UIFont systemFontOfSize:23];
        [_contentView addSubview:_memberDescLabel];
        _memberDescLabel.hidden = YES;
        _memberDescLabel.frame = CGRectMake(20, 25, width-20, 20);

        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.tag = 300;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [_contentView addSubview:_nameLabel];
        _nameLabel.frame = CGRectMake(CGRectGetMinX(_memberDescLabel.frame), CGRectGetMaxY(_memberDescLabel.frame)+8, width-CGRectGetMinX(_memberDescLabel.frame), 20);
        
        _memberDesc2Label = [[UILabel alloc] init];
        _memberDesc2Label.tag = 600;
        _memberDesc2Label.textColor = [UIColor whiteColor];
        _memberDesc2Label.font = [UIFont boldSystemFontOfSize:24];
        [_contentView addSubview:_memberDesc2Label];
        _memberDesc2Label.text = [NSString stringWithFormat:@"%@会员",self.levelNamesArray[index]];
        _memberDesc2Label.frame = CGRectMake(20, CGRectGetMidY(_contentView.frame)-40, width-20,30);
        
        _nextLevelLabel = [[UILabel alloc] init];
        _nextLevelLabel.tag = 400;
        _nextLevelLabel.font = [UIFont systemFontOfSize:12.f];
        _nextLevelLabel.textColor = [UIColor whiteColor];
        
        
        _raiseButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_raiseButton setTitle:@"等级说明" forState:UIControlStateNormal];
        [_raiseButton setImage:[NSBundle discover_ImageWithName:@"member_raise"] forState:UIControlStateNormal];
        _raiseButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_raiseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_raiseButton setBackgroundColor:[UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.2]];
        _raiseButton.layer.cornerRadius = 10.f;
        [_raiseButton addTarget:self action:@selector(raiseButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_contentView addSubview:_raiseButton];
        _raiseButton.frame =  CGRectMake(CGRectGetMaxX(_contentView.frame)-100, CGRectGetMaxY(_contentView.frame)-45, 80, 25);
        
        CGSize size = [@"下一等级：钻石" sizeWithAttributes:@{NSFontAttributeName:_nextLevelLabel.font}];
        _nextLevelLabel.frame = CGRectMake(CGRectGetMinX(_memberDescLabel.frame), CGRectGetMaxY(_nameLabel.frame)+10, ceilf(size.width), ceilf(size.height));
        [_contentView addSubview:_nextLevelLabel];

        _nextLevelImageView = [[UIImageView alloc] init];
        _nextLevelImageView.tag = 500;
        _nextLevelImageView.hidden = YES;
        _nextLevelImageView.image = [UIImage new];
        [_contentView addSubview:_nextLevelImageView];
        _nextLevelImageView.frame = CGRectMake(CGRectGetMaxX(_nextLevelLabel.frame)+3, CGRectGetMaxY(_nameLabel.frame), 30, 30/186.0*206.0);//186 206
        NSString * iconImageName = [NSString stringWithFormat:@"icon_member_level_%zd",index+2];
        NSString * iconImagePath = [[resourcesBundle resourcePath] stringByAppendingPathComponent:iconImageName];
        UIImage * iconImage = [UIImage imageWithContentsOfFile:iconImagePath];
        _nextLevelImageView.image = iconImage;
    }else {
        _contentView = (UIImageView *)[view viewWithTag:100];
        _memberDescLabel = (UILabel *)[view viewWithTag:200];
        _nameLabel = (UILabel *)[view viewWithTag:300];
        _nextLevelLabel = (UILabel *)[view viewWithTag:400];
        _memberDescLabel = (UILabel *)[view viewWithTag:500];
        _memberDesc2Label =(UILabel *)[view viewWithTag:600];
    }
    
    if (index==self.memberInfoModel.currentLevel.level-1) {
        _nameLabel.text = self.userName;
        _raiseButton.hidden = NO;

        _memberDescLabel.hidden = NO;
        _memberDescLabel.text = self.memberInfoModel.currentLevel.name;
        if (index<5) {
            _nextLevelLabel.font = [UIFont systemFontOfSize:12.f];

            CGSize size = [@"下一等级：钻石" sizeWithAttributes:@{NSFontAttributeName:_nextLevelLabel.font}];
            _nextLevelLabel.frame = CGRectMake(CGRectGetMinX(_memberDescLabel.frame), CGRectGetMaxY(_nameLabel.frame)+10, ceilf(size.width), ceilf(size.height));
            _nextLevelLabel.text = [NSString stringWithFormat:@"下一等级：%@",self.levelNamesArray[self.memberInfoModel.currentLevel.level]];
        }else {
            _nextLevelLabel.text = @"钻石会员终身有效";
            _nextLevelLabel.font = [UIFont boldSystemFontOfSize:13.f];

            CGSize size = [@"钻石会员终身有效" sizeWithAttributes:@{NSFontAttributeName:_nextLevelLabel.font}];
            _nextLevelLabel.frame = CGRectMake(CGRectGetMinX(_memberDescLabel.frame), CGRectGetMaxY(_nameLabel.frame)+10, ceilf(size.width), ceilf(size.height));
        }
        _nextLevelImageView.hidden = NO;
        _memberDesc2Label.hidden = YES;
    }else {
        _memberDescLabel.hidden = YES;
        _nameLabel.text = nil;
        _nextLevelLabel.text =nil;
        _nextLevelImageView.hidden = YES;
        _memberDesc2Label.hidden = NO;
        _raiseButton.hidden = YES;

    }

    return _contentView;
}
- (void)raiseButtonClick {
    if (self.raiseButtonClickCallBack) {
        self.raiseButtonClickCallBack();
    }
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            return value ;
        }
            break;

        default:
        {
            return value;
        }
    }
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    MASConstraint * height = self.centerController.heightConstraint.firstObject;

    if (height) {
        if (self.memberInfoModel.currentLevel.level-1 == carousel.currentItemIndex) {
            if (self.memberInfoModel.currentLevel.level==6) {
                height.mas_equalTo(200);
                [self layoutIfNeeded];
                [self setNeedsLayout];
            }else {
                height.mas_equalTo(250);
                [self layoutIfNeeded];
                [self setNeedsLayout];
            }
        }else {
            height.mas_equalTo(200);
            [self layoutIfNeeded];
            [self setNeedsLayout];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HCICarouselNotification" object:@(carousel.currentItemIndex+1)];
    }
    
}
- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 0.8f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1+offset : 1-offset;
        float slope = (max_sacle - min_scale) / 1;
        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    
    return CATransform3DTranslate(transform, offset * carousel.itemWidth * 1.2, 0.0, 0.0);
}

@end
