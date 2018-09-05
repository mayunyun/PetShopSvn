//
//  MYYQRcodeViewController.m
//  BaseFrame
//
//  Created by LONG on 2017/12/12.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYQRcodeViewController.h"

@interface MYYQRcodeViewController ()

@end

@implementation MYYQRcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.titleName;
    if ([self.titleName isEqualToString:@"关注微信公众号"]) {
        self.imageview.image = [UIImage imageNamed:@"微信公众号_1.jpg"];
    }else{
        self.imageview.image = [UIImage imageNamed:@"爱宠APP下载"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
