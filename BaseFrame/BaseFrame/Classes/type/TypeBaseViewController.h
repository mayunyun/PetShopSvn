//
//  TypeBaseViewController.h
//  BaseFrame
//
//  Created by LONG on 2017/12/1.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeBaseViewController : UIViewController
@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,strong)NSString *idStr;
@property (nonatomic,strong)NSString *index;

- (void)requestDataRightTableView;

@end
