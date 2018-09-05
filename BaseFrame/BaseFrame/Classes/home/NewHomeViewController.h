//
//  NewHomeViewController.h
//  BaseFrame
//
//  Created by LONG on 2017/12/1.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeFavorableModel.h"
@interface NewHomeViewController : BaseViewController
@property (nonatomic, copy) void (^transVaule)(HomeFavorableModel* model);

@end
