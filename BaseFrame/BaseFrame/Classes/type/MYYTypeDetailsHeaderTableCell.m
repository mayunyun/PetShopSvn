//
//  MYYTypeDetailsHeaderTableCell.m
//  BaseFrame
//
//  Created by apple on 17/5/4.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYTypeDetailsHeaderTableCell.h"
#import "BRPickerView.h"
@interface MYYTypeDetailsHeaderTableCell ()
{
    BOOL _isClick;
}
@end

@implementation MYYTypeDetailsHeaderTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.hidden = YES;
    self.danweiArr = [[NSMutableArray alloc]init];
    [self changeTextColor:self.otherLab Txt:self.otherLab.text changeTxt:@"*"];
}
- (IBAction)selectBtnClicked:(UIButton *)sender {
    [BRStringPickerView showStringPickerWithTitle:@"" dataSource:self.danweiArr defaultSelValue:self isAutoSelect:YES resultBlock:^(id selectValue) {
        [sender setTitle:selectValue forState:UIControlStateNormal];
        if (_selectBtnBlock) {
            self.selectBtnBlock(selectValue);
        }
    }];
    
}
//改变某字符串的颜色
- (void)changeTextColor:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变颜色之前的转换
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:text];
        //改变颜色
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#eb6876"] range:NSMakeRange(location, length)];
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(location, length)];
        //赋值
        label.attributedText = str1;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.shopcartCountViewEditBlock) {
        self.shopcartCountViewEditBlock(self.payCountLabel.text.integerValue);
    }
}
- (void)configureShopcartCountViewWithProductCount:(NSInteger)productCount productStock:(NSInteger)productStock {
    if (productCount == 1) {
        self.reduceBtn.enabled = NO;
        self.addBtn.enabled = YES;
    } else if (productCount == productStock) {
        self.reduceBtn.enabled = YES;
        self.addBtn.enabled = NO;
    } else {
        self.reduceBtn.enabled = YES;
        self.addBtn.enabled = YES;
    }
    self.payCountLabel.text = [NSString stringWithFormat:@"%ld", (long)productCount];
}
- (IBAction)addBtnClick:(id)sender {
    NSInteger count = self.payCountLabel.text.integerValue;
    if (self.shopcartCountViewEditBlock) {
        self.shopcartCountViewEditBlock(++ count);
    }
}
- (IBAction)reduceBtnClick:(id)sender {
    NSInteger count = self.payCountLabel.text.integerValue;
    if (self.shopcartCountViewEditBlock) {
        self.shopcartCountViewEditBlock(-- count);
    }
}
- (IBAction)collectBtnClick:(id)sender {
    _isClick = !_isClick;
    if (_transVaule) {
        _transVaule(_isClick,sender);
    }
}

- (void)upDataWith:(MYYDetailsWebModel *)promodel arr:(NSArray *)arr{
    self.titleLabel.text = [NSString stringWithFormat:@"%@",promodel.proname];
    [self setstockcount:[NSString stringWithFormat:@"%@",promodel.proid] proprice:[NSString stringWithFormat:@"%@",promodel.proprice] danwei:[NSString stringWithFormat:@"%@",promodel.mainunitname] arr:arr];
    NSLog(@"%@,%@",self.titleLabel.text,promodel.proname);
}
- (void)setstockcount:(NSString *)proid proprice:(NSString *)proprice danwei:(NSString *)danwei arr:(NSArray *)array{
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.1f/%@  ￥%.1f/%@  ￥%.1f/%@",[proprice floatValue],danwei,[proprice floatValue]/[[array[0] objectForKey:@"secondtoremainder"] intValue],[array[0] objectForKey:@"remainderunitname"],[proprice floatValue]/[[array[0] objectForKey:@"maintosecond"] intValue],[array[0] objectForKey:@"secondunitname"]];
    
    self.danweiLab.text = [NSString stringWithFormat:@"￥%.1f/%@  ￥%.1f/%@  ￥%.1f/%@",[[array[0] objectForKey:@"saleprice"] floatValue],danwei,[[array[0] objectForKey:@"saleprice"] floatValue]/[[array[0] objectForKey:@"secondtoremainder"] intValue],[array[0] objectForKey:@"remainderunitname"],[[array[0] objectForKey:@"saleprice"] floatValue]/[[array[0] objectForKey:@"maintosecond"] intValue],[array[0] objectForKey:@"secondunitname"]];
    
    [self.selectBtn setTitle:[array[0] objectForKey:@"secondunitname"] forState:UIControlStateNormal];
    [self.danweiArr addObject:[array[0] objectForKey:@"secondunitname"]];
    [self.danweiArr addObject:[array[0] objectForKey:@"remainderunitname"]];
    [self.danweiArr addObject:danwei];
    NSLog(@"1====%@2 == %@3====%@",[array[0] objectForKey:@"remainderunitname"],[array[0] objectForKey:@"secondunitname"],danwei);
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.danweiLab.text attributes:attribtDic];
    // 赋值
    self.danweiLab.attributedText = attribtStr;
    if ([proprice floatValue]==[[array[0] objectForKey:@"saleprice"] floatValue]) {
        self.danweiheight.constant = 0;
    }else{
        self.danweiheight.constant = 20;
    }
    
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\"}",[array[0] objectForKey:@"jxproid"]]};
    
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"%@withUnLog/location?action=searchstock",jingXinYaoYe_Code_YZY] refreshCache:YES params:params success:^(id response) {
        NSArray* JXarr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (JXarr.count) {
            if ([[JXarr[0] objectForKey:@"stockcount"] floatValue]/[[array[0] objectForKey:@"maintosecond"] intValue]==[[JXarr[0] objectForKey:@"stockcount"] intValue]/[[array[0] objectForKey:@"maintosecond"] intValue]) {
                self.kucunLab.text = [NSString stringWithFormat:@"库存:%d",[[JXarr[0] objectForKey:@"stockcount"] intValue]/[[array[0] objectForKey:@"maintosecond"] intValue]];
            }else{
                self.kucunLab.text = [NSString stringWithFormat:@"库存:%.2f",[[JXarr[0] objectForKey:@"stockcount"] floatValue]/[[array[0] objectForKey:@"maintosecond"] intValue]];
            }
        }
    } fail:^(NSError *error) {
        
    }];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}



@end
