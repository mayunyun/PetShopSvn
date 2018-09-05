//
//  MYYCommentTableViewCell.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/4.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYYCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headerimg;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIView *scoreView;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeight;

@end
