//
//  MYYPasswordSubmitViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/5.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYPasswordSubmitViewController.h"

@interface MYYPasswordSubmitViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *textField1;

@property(nonatomic,strong)UITextField *textField2;

@property(nonatomic,strong)UIButton *nextBtn;//提交

@end

@implementation MYYPasswordSubmitViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImage *image = [UIImage imageNamed:@"iconfont-touming"];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationItemButton];
    [self setupUI];
    
}
- (void)navigationItemButton{
    self.navigationItem.title = @"找回登录密码";
}

- (void)setupUI
{
    // 1.设置背景色
    UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    bgimage.image = [UIImage imageNamed:@"loginBG"];
    bgimage.userInteractionEnabled = YES;
    [self.view addSubview:bgimage];
    
    // 2.添加子视图
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(20*MYWIDTH, mScreenHeight/5, mScreenWidth-40*MYWIDTH, 120*MYWIDTH)];
    bgview.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.8];
    bgview.layer.cornerRadius=7;
    [bgimage addSubview:bgview];
    
    UIImageView *titleimage1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20*MYWIDTH, 15, 18)];
    titleimage1.image = [UIImage imageNamed:@"02020"];
    [bgview addSubview:titleimage1];
    
    self.textField1 = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, bgview.width - 70, 59*MYWIDTH)];
    self.textField1.delegate = self;
    self.textField1.layer.cornerRadius = 5;
    self.textField1.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField1.layer.borderColor = [UIColor grayColor].CGColor;
    self.textField1.placeholder = @"请输入登录密码";
    self.textField1.secureTextEntry = YES;
    [self.textField1 setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [bgview addSubview:self.textField1];
    
    UILabel *xian1 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textField1.frame)+1, bgview.width - 40, 1)];
    xian1.backgroundColor = UIColorFromRGB(0xefefef);
    [bgview addSubview:xian1];
    
    UIImageView *titleimage2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, xian1.bottom + 20*MYWIDTH, 15, 18)];
    titleimage2.image = [UIImage imageNamed:@"02020"];
    [bgview addSubview:titleimage2];
    
    self.textField2 = [[UITextField alloc]initWithFrame:CGRectMake(self.textField1.left, xian1.bottom, self.textField1.width, self.textField1.height)];
    self.textField2.delegate = self;
    self.textField2.layer.cornerRadius = 5;
    self.textField2.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField2.layer.borderColor = [UIColor grayColor].CGColor;
    self.textField2.placeholder = @"请再次输入密码";
    [self.textField2 setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    self.textField2.secureTextEntry = YES;
    [bgview addSubview:self.textField2];
    
    
    self.nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(bgview.left+8, bgview.bottom+40, bgview.width-16, 45)];
    [self.nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.nextBtn.layer.cornerRadius = 5;
    [self.nextBtn setBackgroundColor:NavBarItemColor];
    [self.nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgimage addSubview:self.nextBtn];
    
   
}
- (void)nextBtnAction:(UIButton *)sender{
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
    if ([self.textField1.text isEqualToString:self.textField2.text]&&!IsEmptyValue(self.phone)) {
        if ([Command isPassword:self.textField1.text]) {
            [self replacePwdRequest];
        }else{
            [self customAlert:@"密码位数6-20位"];
        }
    }else{
        [self customAlert:@"请输入相同的密码"];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.textField1]) {
        
    }else{
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.textField1]) {
        
        if(![Command isPassword:self.textField1.text]){
            [self showAlert:@"密码应该是6-20位"];
        }
    }else{
        if (![self.textField1.text isEqualToString:self.textField2.text]) {
            [self showAlert:@"密码两次输入不一致"];
        }
    }
    
}


- (void)replacePwdRequest{
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"password\":\"%@\",\"phone\":\"%@\"}",self.textField1.text,self.phone]};
    [HTNetWorking postWithUrl:@"register?action=upPassword" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
//            NSLog(@"重置成功");
            [self showAlert:@"密码重置成功"];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",self.phone] forKey:USERPHONE];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",self.textField1.text] forKey:PASSWORD];
            NSArray* array = self.navigationController.viewControllers;
            UIViewController *viewCtl = self.navigationController.viewControllers[array.count - 1 - 2];
            [self.navigationController popToViewController:viewCtl animated:YES];
        }else{
            [self showAlert:@"密码重置失败"];
        }
        
    } fail:^(NSError *error) {
        
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}
@end
