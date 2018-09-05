//
//  MYYPasswordViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/5.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYPasswordViewController.h"
#import "MYYPasswordSubmitViewController.h"
#import "YZXTimeButton.h"
#define SendTime 60
@interface MYYPasswordViewController ()<UITextFieldDelegate>{
    BOOL _ischeckPhoneTrue;
    NSString* _checkPhone;
    NSString* _SMGCode;
}
@property(nonatomic,strong)UITextField *textField1;

@property(nonatomic,strong)UITextField *textField2;

@property(nonatomic,strong)YZXTimeButton *messageBtn;//

@property(nonatomic,strong)UIButton *nestBtn;//
@end

@implementation MYYPasswordViewController
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
    titleimage1.image = [UIImage imageNamed:@"手机"];
    [bgview addSubview:titleimage1];
    
    self.textField1 = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, bgview.width - 70, 59*MYWIDTH)];
    self.textField1.delegate = self;
    self.textField1.layer.cornerRadius = 5;
    self.textField1.keyboardType = UIKeyboardTypeNumberPad;
    self.textField1.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField1.layer.borderColor = [UIColor grayColor].CGColor;
    self.textField1.placeholder = @"请输入手机号";
    [self.textField1 setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [bgview addSubview:self.textField1];
    
    UILabel *xian1 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textField1.frame)+1, bgview.width - 40, 1)];
    xian1.backgroundColor = UIColorFromRGB(0xefefef);
    [bgview addSubview:xian1];
    
    UIImageView *titleimage2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, xian1.bottom + 20*MYWIDTH, 15, 18)];
    titleimage2.image = [UIImage imageNamed:@"短信验证码"];
    [bgview addSubview:titleimage2];
    
    self.textField2 = [[UITextField alloc]initWithFrame:CGRectMake(self.textField1.left, xian1.bottom, self.textField1.width - 80, self.textField1.height)];
    self.textField2.delegate = self;
    self.textField2.layer.cornerRadius = 5;
    self.textField2.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField2.layer.borderColor = [UIColor grayColor].CGColor;
    self.textField2.placeholder = @"请输入验证码";
    [self.textField2 setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [bgview addSubview:self.textField2];
    
    self.messageBtn = [[YZXTimeButton alloc]initWithFrame:CGRectMake(bgview.right-110, self.textField2.top+10, 80, 35)];
    [self.messageBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.messageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.messageBtn.layer.cornerRadius = 5;
    [self.messageBtn setBackgroundColor:[UIColor clearColor]];
    [self.messageBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
    [self.messageBtn addTarget:self action:@selector(messageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:self.messageBtn];
    
    self.nestBtn = [[UIButton alloc]initWithFrame:CGRectMake(bgview.left+8, bgview.bottom+40, bgview.width-16, 45)];
    [self.nestBtn setTitle:@"下一步" forState:UIControlStateNormal];
    self.nestBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.nestBtn.layer.cornerRadius = 5;
    [self.nestBtn setBackgroundColor:NavBarItemColor];
    [self.nestBtn addTarget:self action:@selector(nestBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgimage addSubview:self.nestBtn];
    
   
}
- (void)nestBtnAction:(UIButton *)sender{
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
    if (_ischeckPhoneTrue == YES&&[self.textField2.text isEqualToString:_SMGCode]) {
        if (!IsEmptyValue(_checkPhone)) {
            MYYPasswordSubmitViewController *pwsVC = [[MYYPasswordSubmitViewController alloc]init];
            pwsVC.phone = _checkPhone;
            [self.navigationController pushViewController:pwsVC animated:YES];
        }
    }else{
        [self showAlert:@"手机号或验证码不正确"];
    }
}
//发送验证码
- (void)messageBtnAction:(UIButton *)sender{
    if (![Command isMobileNumber:self.textField1.text]) {
        [self customAlert:@"请输入正确手机号"];
        return;
    }
    if (!IsEmptyValue(self.textField1.text)) {
        [self checkPhoneRequest];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.textField1]) {
        
    }else{
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.textField1]) {
        
        
    }else{
        
    }
    
}

#pragma mark 验证号码是否注册过
- (void)checkPhoneRequest{
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",self.textField1.text]};
    [HTNetWorking postWithUrl:@"register?action=isExitsPhone" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"检查手机%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            //此号码为没有注册
            _ischeckPhoneTrue = NO;
            [self customAlert:@"此号码还未注册"];
            return ;
        }else{
            if (!IsEmptyValue([self tryToParseData:response])) {
                _ischeckPhoneTrue = YES;
                if (_ischeckPhoneTrue == YES) {
                    _checkPhone = self.textField1.text;
                    self.messageBtn.recoderTime = @"yes";
                    [self.messageBtn setKaishi:SendTime];
                    [self getSMSCodeRequest];
                }
            }
        }
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark 验证码请求
- (void)getSMSCodeRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",self.textField1.text]};
    [HTNetWorking postWithUrl:@"register?action=getSMSCode" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"验证码%@",str);
        _SMGCode = [Command replaceAllOthers:str];
    } fail:^(NSError *error) {
        
    }];
    
}

// 解析json数据
- (id)tryToParseData:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSArray class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSArray class]]){
            dic = nil;
        }
    }
    return dic;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}
@end
