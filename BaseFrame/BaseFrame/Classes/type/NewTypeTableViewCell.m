//
//  NewTypeTableViewCell.m
//  BaseFrame
//
//  Created by LONG on 2017/12/1.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "NewTypeTableViewCell.h"

@implementation NewTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.headerView.layer.cornerRadius = 5;
    self.headerView.clipsToBounds = YES;
    
    
}
- (void)setstockcount:(NSString *)proid price:(NSString *)price secondunitname:(NSString *)secondunitname maintosecond:(NSString *)maintosecond{
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\"}",proid]};
    

    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"%@withUnLog/location?action=searchstock",jingXinYaoYe_Code_YZY] refreshCache:YES params:params success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (array.count) {
            if ([[array[0] objectForKey:@"stockcount"] floatValue]/[maintosecond intValue]==[[array[0] objectForKey:@"stockcount"] intValue]/[maintosecond intValue]) {
                self.numerLab.text = [NSString stringWithFormat:@"￥%@/%@   库存:%d",price,secondunitname,[[array[0] objectForKey:@"stockcount"] intValue]/[maintosecond intValue]];
                [self changeTextFont:self.numerLab Txt:self.numerLab.text changeTxt:[NSString stringWithFormat:@"库存:%d",[[array[0] objectForKey:@"stockcount"] intValue]/[maintosecond intValue]]];

            }else{
                self.numerLab.text = [NSString stringWithFormat:@"￥%@/%@   库存:%.2f",price,secondunitname,[[array[0] objectForKey:@"stockcount"] floatValue]/[maintosecond intValue]];
                [self changeTextFont:self.numerLab Txt:self.numerLab.text changeTxt:[NSString stringWithFormat:@"库存:%.2f",[[array[0] objectForKey:@"stockcount"] floatValue]/[maintosecond intValue]]];

            }
        }
    } fail:^(NSError *error) {
        
    }];
}
//改变某字符串的大小
- (void)changeTextFont:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变大小之前的转换
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:text];
        //改变大小
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(location, length)];
        //赋值
        label.attributedText = str1;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
