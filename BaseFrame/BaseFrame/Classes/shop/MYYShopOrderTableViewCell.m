//
//  MYYShopOrderTableViewCell.m
//  BaseFrame
//
//  Created by apple on 17/5/9.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYShopOrderTableViewCell.h"

@implementation MYYShopOrderTableViewCell

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.headerImage.layer.cornerRadius = 5;
    self.headerImage.clipsToBounds = YES;
}

- (void)setDataCount:(NSInteger )count WithModel:(MYYShopOrderModel *)model gouWuCheModel:(JVShopcartBrandModel *)BrandModel{
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HTImgUrl,@"productimages/",model.autoname]]];
    
    self.titleName.text = [NSString stringWithFormat:@"%@",model.proname];

    NSString* user= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:CUSTTYPEID]];
    if ([user isEqualToString:@"1"]) {
        self.priceLab.text = [NSString stringWithFormat:@"￥%.2f", [model.price floatValue]/[model.secondtoremainder floatValue]];
    }else if ([user isEqualToString:@"2"]){
        self.priceLab.text = [NSString stringWithFormat:@"￥%.2f", [model.price floatValue]/[model.maintosecond floatValue]];
    }else{
        self.priceLab.text = [NSString stringWithFormat:@"￥%@",model.price];
    }
    if (BrandModel.count>0) {
        self.countLab.text = [NSString stringWithFormat:@"x%zd",BrandModel.count];
    }else{
        self.countLab.text = [NSString stringWithFormat:@"x%zd",count];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}


@end
