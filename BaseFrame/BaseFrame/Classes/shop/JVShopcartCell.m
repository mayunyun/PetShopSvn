//
//  JVShopcartCell.m
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import "JVShopcartCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "JVShopcartCountView.h"

@interface JVShopcartCell ()

@property (nonatomic, strong) UIButton *productSelectButton;//选中按钮
@property (nonatomic, strong) UIImageView *productImageView;//商品图片
@property (nonatomic, strong) UILabel *productNameLable;//商品名
@property (nonatomic, strong) UILabel *productPriceLable;//价格
@property (nonatomic, strong) UILabel *productDanweiLabel;//单位
@property (nonatomic, strong) JVShopcartCountView *shopcartCountView;
@property (nonatomic, strong) UIView *shopcartBgView;
@property (nonatomic, strong) UIView *topLineView;

@end

@implementation JVShopcartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.shopcartBgView];
    [self.shopcartBgView addSubview:self.productSelectButton];
    [self.shopcartBgView addSubview:self.productImageView];
    [self.shopcartBgView addSubview:self.productNameLable];
    [self.shopcartBgView addSubview:self.productPriceLable];
    [self.shopcartBgView addSubview:self.shopcartCountView];
    [self.shopcartBgView addSubview:self.topLineView];
}

- (void)configureShopcartCellWithProductURL:(NSString *)productURL productName:(NSString *)productName productPrice:(float)productPrice productCount:(NSInteger)productCount productStock:(float)productStock productSelected:(BOOL)productSelected secondtoremainder:(NSString *)secondtoremainder
                               maintosecond:(NSString *)maintosecond mainunitname:(NSString *)mainunitname{

    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HTImgUrl,@"productimages/",productURL]]];
    self.productNameLable.text = productName;
    NSString* user= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:CUSTTYPEID]];
    if ([user isEqualToString:@"1"]) {
        self.productPriceLable.text = [NSString stringWithFormat:@"￥%.2f/%@", productPrice/[secondtoremainder floatValue],mainunitname];
    }else if ([user isEqualToString:@"2"]){
        self.productPriceLable.text = [NSString stringWithFormat:@"￥%.2f/%@", productPrice/[maintosecond floatValue],mainunitname];
    }else{
        self.productPriceLable.text = [NSString stringWithFormat:@"￥%.2f/%@", productPrice,mainunitname];
    }
    self.productSelectButton.selected = productSelected;
    [self.shopcartCountView configureShopcartCountViewWithProductCount:productCount productStock:nil];
}

- (void)productSelectButtonAction {
    self.productSelectButton.selected = !self.productSelectButton.isSelected;
    if (self.shopcartCellBlock) {
        self.shopcartCellBlock(self.productSelectButton.selected);
    }
}

- (UIButton *)productSelectButton
{
    if(_productSelectButton == nil)
    {
        _productSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_productSelectButton setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
        [_productSelectButton setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
        [_productSelectButton addTarget:self action:@selector(productSelectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _productSelectButton;
}

- (UIImageView *)productImageView {
    if (_productImageView == nil){
        _productImageView = [[UIImageView alloc] init];
        _productImageView.layer.cornerRadius = 5;
        _productImageView.clipsToBounds = YES;
    }
    return _productImageView;
}

- (UILabel *)productNameLable {
    if (_productNameLable == nil){
        _productNameLable = [[UILabel alloc] init];
        _productNameLable.font = [UIFont systemFontOfSize:14];
        _productNameLable.numberOfLines = 0;
        _productNameLable.textColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1];
    }
    return _productNameLable;
}

- (UILabel *)productPriceLable {
    if (_productPriceLable == nil){
        _productPriceLable = [[UILabel alloc] init];
        _productPriceLable.font = [UIFont systemFontOfSize:14];
        _productPriceLable.textColor = [UIColor colorWithRed:0.918  green:0.141  blue:0.137 alpha:1];
    }
    return _productPriceLable;
}

- (JVShopcartCountView *)shopcartCountView {
    if (_shopcartCountView == nil){
        _shopcartCountView = [[JVShopcartCountView alloc] init];
        
        __weak __typeof(self) weakSelf = self;
        _shopcartCountView.shopcartCountViewEditBlock = ^(NSInteger count){
            if (weakSelf.shopcartCellEditBlock) {
                weakSelf.shopcartCellEditBlock(count);
            }
        };
    }
    return _shopcartCountView;
}


- (UIView *)shopcartBgView {
    if (_shopcartBgView == nil){
        _shopcartBgView = [[UIView alloc] init];
        _shopcartBgView.backgroundColor = [UIColor whiteColor];
    }
    return _shopcartBgView;
}

- (UIView *)topLineView {
    if (_topLineView == nil){
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    }
    return _topLineView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.productSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopcartBgView).offset(10);
        make.centerY.equalTo(self.shopcartBgView).offset(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopcartBgView).offset(50);
        make.centerY.equalTo(self.shopcartBgView).offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.productNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(15);
        make.top.equalTo(self.shopcartBgView).offset(10);
        make.right.equalTo(self.shopcartBgView).offset(-5);
        make.height.mas_equalTo(@60);
    }];
    
   
    [self.productPriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(10);
        make.bottom.equalTo(self.shopcartBgView).offset(-15);
        make.right.equalTo(self.shopcartBgView).offset(-5);
        make.height.equalTo(@20);
    }];
    [self.shopcartCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shopcartBgView).offset(-10);
        make.bottom.equalTo(self.shopcartBgView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    
    [self.shopcartBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopcartBgView).offset(50);
        make.top.right.equalTo(self.shopcartBgView);
        make.height.equalTo(@0.4);
    }];
}

@end
