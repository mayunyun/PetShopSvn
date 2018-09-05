//
//  MYYTypeDetailsHeaderTableCell.h
//  BaseFrame
//
//  Created by apple on 17/5/4.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "MYYDetailsWebModel.h"
typedef void(^ShopcartCountViewEditBlock)(NSInteger count);


@interface MYYTypeDetailsHeaderTableCell : UITableViewCell<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet SDCycleScrollView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *collectBtn;
- (IBAction)collectBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *danweiLab;
@property (weak, nonatomic) IBOutlet UILabel *guigeLab;
@property (weak, nonatomic) IBOutlet UILabel *kucunLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *danweiheight;
@property (weak, nonatomic) IBOutlet UILabel *otherLab;

@property (weak, nonatomic) IBOutlet UILabel *danweiLabel;
@property(nonatomic,strong)void(^selectBtnBlock)(NSString *);
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic,strong)NSMutableArray * danweiArr;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)addBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *reduceBtn;
- (IBAction)reduceBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *payCountLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, copy) ShopcartCountViewEditBlock shopcartCountViewEditBlock;
@property (nonatomic,copy) void (^transVaule)(BOOL isClick,UIButton* btn);
- (void)configureShopcartCountViewWithProductCount:(NSInteger)productCount productStock:(NSInteger)productStock;

- (void)upDataWith:(MYYDetailsWebModel *)promodel arr:(NSArray *)arr;
@end
