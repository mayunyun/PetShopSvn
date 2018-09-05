//
//  HomeYouLikeCollectionViewCell.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/3.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "HomeYouLikeCollectionViewCell.h"

@interface HomeYouLikeCollectionViewCell()
{
    BOOL _isClick;
}
@end

@implementation HomeYouLikeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 5;
}

- (IBAction)shopCarBtnClick:(id)sender {
    _isClick = !_isClick;
    if (_transVaule) {
        _transVaule(_isClick);
    }
}
- (void)setstockcount:(NSString *)proid maintosecond:(NSString *)maintosecond{

    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\"}",proid]};
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"%@withUnLog/location?action=searchstock",jingXinYaoYe_Code_YZY] refreshCache:YES params:params success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (array.count) {
            if ([[array[0] objectForKey:@"stockcount"] floatValue]/[maintosecond intValue]==[[array[0] objectForKey:@"stockcount"] intValue]/[maintosecond intValue]) {
                self.kucunLab.text = [NSString stringWithFormat:@"库存:%d",[[array[0] objectForKey:@"stockcount"] intValue]/[maintosecond intValue]];
            }else{
                self.kucunLab.text = [NSString stringWithFormat:@"库存:%.2f",[[array[0] objectForKey:@"stockcount"] floatValue]/[maintosecond intValue]];
            }
        }else{
            self.kucunLab.text = [NSString stringWithFormat:@"库存:%@",@"0"];
        }
    } fail:^(NSError *error) {
        
    }];
}
@end
