//
//  HCMyDealFilterView.m
//  HongCai
//
//  Created by Candy on 2017/7/22.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyDealFilterView.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>






@interface HCMyDealFilterCell : UICollectionViewCell
@property (nonatomic, strong) UIButton * filterButton;
@end


@implementation HCMyDealFilterCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.filterButton];
        self.filterButton.center = self.contentView.center;
        [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-2);
            make.centerX.mas_equalTo(self.contentView);
            make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.8);
            make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.8);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    self.filterButton.selected = selected;
    if (selected) {
        self.filterButton.backgroundColor = [UIColor colorWithHexString:@"0xffd9c9"];
        self.filterButton.layer.borderColor = [UIColor colorWithHexString:@"0xff611d"].CGColor;
    }else{
        self.filterButton.layer.borderColor = [UIColor colorWithHexString:@"0xdddddd"].CGColor;
        self.filterButton.backgroundColor = [UIColor colorWithHexString:@"0xf7f7f7"];
    }
}

- (UIButton *)filterButton {
    if (!_filterButton) {
        _filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _filterButton.layer.borderWidth = 0.5f;
        _filterButton.layer.cornerRadius = 3.f;
        _filterButton.userInteractionEnabled = NO;
        _filterButton.layer.borderColor = [UIColor colorWithHexString:@"0xdddddd"].CGColor;
        _filterButton.backgroundColor = [UIColor colorWithHexString:@"0xf7f7f7"];
        [_filterButton setTitle:@"全部" forState:(UIControlStateNormal)];
        _filterButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_filterButton setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
        [_filterButton setTitleColor:[UIColor colorWithHexString:@"0xff611d"] forState:UIControlStateSelected];
    }
    return _filterButton;
}
@end



@interface HCMyDealFilterView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView * collectionView;
@end

@implementation HCMyDealFilterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        self.collectionView.frame = CGRectMake(0, 10, CGRectGetWidth(frame), CGRectGetHeight(frame)-10);
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self titleArray].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HCMyDealFilterCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell.filterButton setTitle:[self titleArray][indexPath.item] forState:UIControlStateNormal];
    return cell;
}
- (NSArray *)titleArray {
    return @[@"全部",@"充值",@"投资",@"提现",@"回款",@"奖励",@"其他"];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HCMyDealFilterCell * cell = (HCMyDealFilterCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.selectCallback) {
        self.selectCallback(cell.filterButton.currentTitle);
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumLineSpacing = CGFLOAT_MIN;
        flow.minimumInteritemSpacing= CGFLOAT_MIN;
        
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
        
        flow.itemSize= CGSizeMake(width/3.1, width/3.1*82/206.0);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.dataSource =self;
        _collectionView.delegate = self;
        _collectionView.allowsMultipleSelection = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[HCMyDealFilterCell class] forCellWithReuseIdentifier:@"Cell"];
        
    }
    return _collectionView;
}
@end
