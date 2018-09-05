//
//  NewTypeTableViewCell.h
//  BaseFrame
//
//  Created by LONG on 2017/12/1.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTypeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *guigeLab;
@property (weak, nonatomic) IBOutlet UILabel *numerLab;
@property (weak, nonatomic) IBOutlet UIButton *shopClickBut;

- (void)setstockcount:(NSString *)proid price:(NSString *)price secondunitname:(NSString *)secondunitname maintosecond:(NSString *)maintosecond;

@end
