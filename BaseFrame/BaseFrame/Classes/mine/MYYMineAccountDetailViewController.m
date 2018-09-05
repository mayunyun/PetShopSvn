//
//  MYYMineAccountDetailViewController.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/16.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYMineAccountDetailViewController.h"

@interface MYYMineAccountDetailViewController ()
{
    UITextField* _textField;
}

@end

@implementation MYYMineAccountDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavUI:self.controller];
    [self creatUI:self.controller];
}

- (void)creatNavUI:(NSString*)controller{

    [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"保存"];
    if ([controller integerValue] == 1) {
        self.title = @"我的账户";
    }else if ([controller integerValue] == 2){
        self.title = @"我的姓名";
    }else if ([controller integerValue] == 3){
        self.title = @"我的电话";
    }else if ([controller integerValue] == 4){
        self.title = @"修改密码";
    }else if ([controller integerValue] == 5){
        self.title = @"单位公司全称";
    }else if ([controller integerValue] == 6){
        self.title = @"统一社会信用代码";
    }else if ([controller integerValue] == 7){
        self.title = @"单位地址";
    }else if ([controller integerValue] == 8){
        self.title = @"单位电话";
    }else if ([controller integerValue] == 9){
        self.title = @"开户银行";
    }else if ([controller integerValue] == 10){
        self.title = @"银行账号";
    }
}

- (void)creatUI:(NSString*)controller{
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10+64, kScreen_Width, 44)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, kScreen_Width - 20, 44)];
    if ([controller integerValue] == 1) {
        _textField.placeholder = @"请输入账户";
    }else if ([controller integerValue] == 2){
        _textField.placeholder = @"请输入姓名";
    }else if ([controller integerValue] == 3){
        _textField.placeholder = @"请输入电话";
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }else if ([controller integerValue] == 4){
        _textField.placeholder = @"请输入密码";
    }else if ([controller integerValue] == 5){
        _textField.placeholder = @"请输入单位公司全称";
    }else if ([controller integerValue] == 6){
        _textField.placeholder = @"请输入统一社会信用代码";
    }else if ([controller integerValue] == 7){
        _textField.placeholder = @"请输入单位地址";
    }else if ([controller integerValue] == 8){
        _textField.placeholder = @"请输入单位电话";
    }else if ([controller integerValue] == 9){
        _textField.placeholder = @"请输入开户银行";
    }else if ([controller integerValue] == 10){
        _textField.placeholder = @"请输入银行账号";
    }
    
    [bgView addSubview:_textField];
    
}

- (void)rightBarClick:(UIButton*)sender{
    [self updataPersonalRequest];
}

- (void)updataPersonalRequest{
/*
 personal?action=updPersonalInfo
 */
    if ([_textField.text isEqualToString:@""]) {
        [self customAlert:@"输入不能为空"];
        return;
    }
    
    NSDictionary* params = [[NSDictionary alloc]init];
    if (!IsEmptyValue(_textField.text)) {
        if ([_controller integerValue] == 1) {
            params= @{@"data":[NSString stringWithFormat:@"{\"accountname\":\"%@\",\"biaoshi\":\"biaoshi\"}",_textField.text]};
        }else if ([_controller integerValue] == 2){
            params= @{@"data":[NSString stringWithFormat:@"{\"name\":\"%@\",\"biaoshi\":\"biaoshi\"}",_textField.text]};
        }else if ([_controller integerValue] == 3){
            params= @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\",\"biaoshi\":\"biaoshi\"}",_textField.text]};
            if (![Command isMobileNumber:_textField.text]) {
                [self customAlert:@"请输入正确手机号"];
                return;
            }
        }else if ([_controller integerValue] == 4){
            params= @{@"data":[NSString stringWithFormat:@"{\"password\":\"%@\",\"biaoshi\":\"biaoshi\"}",_textField.text]};
            if (![Command isPassword:_textField.text]) {
                [self customAlert:@"密码长度6-20位"];
                return;
            }
        }else if ([_controller integerValue] == 5){
            params= @{@"data":[NSString stringWithFormat:@"{\"companyname\":\"%@\",\"biaoshi\":\"biaoshi\"}",_textField.text]};
            if ([_textField.text isEqualToString:@""]) {
                [self customAlert:@"输入不能为空"];
                return;
            }
        }else if ([_controller integerValue] == 6){
            params= @{@"data":[NSString stringWithFormat:@"{\"honesty\":\"%@\",\"biaoshi\":\"biaoshi\"}",_textField.text]};
            if ([_textField.text isEqualToString:@""]) {
                [self customAlert:@"输入不能为空"];
                return;
            }
        }else if ([_controller integerValue] == 7){
            params= @{@"data":[NSString stringWithFormat:@"{\"companyaddress\":\"%@\",\"biaoshi\":\"biaoshi\"}",_textField.text]};
            if ([_textField.text isEqualToString:@""]) {
                [self customAlert:@"输入不能为空"];
                return;
            }
        }else if ([_controller integerValue] == 8){
            params= @{@"data":[NSString stringWithFormat:@"{\"companyphone\":\"%@\",\"biaoshi\":\"biaoshi\"}",_textField.text]};
            if ([_textField.text isEqualToString:@""]) {
                [self customAlert:@"输入不能为空"];
                return;
            }
        }else if ([_controller integerValue] == 9){
            params= @{@"data":[NSString stringWithFormat:@"{\"companybank\":\"%@\",\"biaoshi\":\"biaoshi\"}",_textField.text]};
            if ([_textField.text isEqualToString:@""]) {
                [self customAlert:@"输入不能为空"];
                return;
            }
        }else if ([_controller integerValue] == 10){
            params= @{@"data":[NSString stringWithFormat:@"{\"companyaccount\":\"%@\",\"biaoshi\":\"biaoshi\"}",_textField.text]};
            if ([_textField.text isEqualToString:@""]) {
                [self customAlert:@"输入不能为空"];
                return;
            }
        }
    }
    
    [HTNetWorking postWithUrl:@"personal?action=updPersonalInfo" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"修改个人信息%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            if (!IsEmptyValue(_textField.text)) {
                if ([_controller integerValue] == 1) {
                    [[NSUserDefaults standardUserDefaults]setObject:_textField.text forKey:ACCOUNTNAME];
                }else if ([_controller integerValue] == 2){
                    [[NSUserDefaults standardUserDefaults]setObject:_textField.text forKey:USENAME];
                }else if ([_controller integerValue] == 3){
                    [[NSUserDefaults standardUserDefaults]setObject:_textField.text forKey:USERPHONE];
                }else if ([_controller integerValue] == 4){
                    [[NSUserDefaults standardUserDefaults]setObject:_textField.text forKey:PASSWORD];
                }
            }
            
            [Command customAlert:@"修改个人信息成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
