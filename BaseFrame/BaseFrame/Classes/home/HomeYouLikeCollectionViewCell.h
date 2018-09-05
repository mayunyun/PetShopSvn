//
//  HomeYouLikeCollectionViewCell.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/3.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeYouLikeCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *shopCarBtn;
@property (weak, nonatomic) IBOutlet UILabel *guigeLab;
@property (weak, nonatomic) IBOutlet UILabel *kucunLab;

- (IBAction)shopCarBtnClick:(id)sender;
@property (nonatomic, copy) void (^transVaule)(BOOL isClick);
- (void)setstockcount:(NSString *)proid maintosecond:(NSString *)maintosecond;
@end
