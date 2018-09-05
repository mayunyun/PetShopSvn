//
//  MYYRegisterViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/5.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYRegisterViewController.h"
#import "YZXTimeButton.h"
#define SendTime 60
#import "MYYRegisterSubmitViewController.h"
#import "MYYRegistAgreementViewController.h"

@interface MYYRegisterViewController ()<UITextFieldDelegate>
{
    UITextField* _phoneField;
    UITextField* _pwdField;
    UIButton* _agreeBtn;
    BOOL _isAgreeBtn;
    BOOL _ischeckPhoneTrue;
    NSString* _checkPhone;
    NSString* _SMGCode;
}
@property (nonatomic,strong) YZXTimeButton* sendMessageBtn;
@end

@implementation MYYRegisterViewController
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
    self.title = @"注册";
    
    [self creatUI];
}

- (void)creatUI{
    // 1.设置背景色
    UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    bgimage.image = [UIImage imageNamed:@"loginBG"];
    bgimage.userInteractionEnabled = YES;
    [self.view addSubview:bgimage];
    
    // 2.添加子视图
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(20*MYWIDTH, mScreenHeight/5, mScreenWidth-40*MYWIDTH, 180*MYWIDTH)];
    bgview.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.8];
    bgview.layer.cornerRadius=7;
    [bgimage addSubview:bgview];
    
    UIImageView *titleimage1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20*MYWIDTH, 15, 18)];
    titleimage1.image = [UIImage imageNamed:@"手机"];
    [bgview addSubview:titleimage1];
    
    _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, bgview.width - 70, 59*MYWIDTH)];
    _phoneField.placeholder = @"请输入手机号码";
    _phoneField.delegate = self;
    _phoneField.font = [UIFont systemFontOfSize:14];
    [bgview addSubview:_phoneField];
    
    UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(20, _phoneField.bottom, bgview.width-40, 1)];
    line1.backgroundColor = UIColorFromRGB(0xD7D7D7) ;
    [bgview addSubview:line1];
    
    UIImageView *titleimage2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, line1.bottom + 20*MYWIDTH, 15, 18)];
    titleimage2.image = [UIImage imageNamed:@"短信验证码"];
    [bgview addSubview:titleimage2];
    
    _pwdField = [[UITextField alloc]initWithFrame:CGRectMake(_phoneField.left, line1.bottom, _phoneField.width - 80, _phoneField.height)];
    _pwdField.delegate = self;
    _pwdField.font = [UIFont systemFontOfSize:14];
    _pwdField.placeholder = @"请输入您的验证码";
    [bgview addSubview:_pwdField];
    
    UIView* line2 = [[UIView alloc]initWithFrame:CGRectMake(20, _pwdField.bottom, bgview.width-40, 1)];
    line2.backgroundColor = UIColorFromRGB(0xD7D7D7);
    [bgview addSubview:line2];
    
    _sendMessageBtn = [[YZXTimeButton alloc]initWithFrame:CGRectMake(bgview.right-110, _pwdField.top+10, 80, 35)];
    _sendMessageBtn.backgroundColor = [UIColor clearColor];
    [_sendMessageBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_sendMessageBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
    _sendMessageBtn.layer.cornerRadius = 5;
    [_sendMessageBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:_sendMessageBtn];
    
    _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _agreeBtn.frame = CGRectMake(20, line2.bottom+15, 30, 30);
    [_agreeBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    [bgview addSubview:_agreeBtn];
    _isAgreeBtn = YES;
    [_agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(_agreeBtn.right+5, line2.bottom+15, 240, 30)];
    lab.font = [UIFont systemFontOfSize:14];
    lab.text = @"我已阅读并同意《注册协议》";
    lab.textColor = UIColorFromRGB(0x333333);
    [self changeTextColor:lab Txt:lab.text changeTxt:@"《注册协议》"];
    [bgview addSubview:lab];
    
    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreeTapGesture:)];
    lab.userInteractionEnabled = YES;
    [lab addGestureRecognizer:aTap];
    
    UIButton* nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextBtn.frame = CGRectMake(bgview.left+8, bgview.bottom+40, bgview.width-16, 45);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = 5;
    nextBtn.backgroundColor = NavBarItemColor;
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgimage addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}


#pragma mark 发送验证码
- (void)sendBtnClick:(YZXTimeButton*)sender
{
    if (!IsEmptyValue(_phoneField.text)&&[Command isMobileNumber:_phoneField.text]) {
        [self checkPhoneDataRequest];
    }else{
        [self showAlert:@"手机号格式不正确"];
    }
}
//改变某字符串的颜色
- (void)changeTextColor:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变颜色之前的转换
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:text];
        //改变颜色
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#579cfb"] range:NSMakeRange(location, length)];
        //赋值
        label.attributedText = str1;
    }
}
- (void)agreeBtnClick:(UIButton*)sender
{
    _isAgreeBtn = !_isAgreeBtn;
    if (_isAgreeBtn) {
        [_agreeBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }else{
        [_agreeBtn setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
    }
}

#pragma mark 注册协议点击方法
- (void)agreeTapGesture:(UITapGestureRecognizer*)tap
{
    //点击注册协议
    MYYRegistAgreementViewController* vc = [[MYYRegistAgreementViewController alloc]init];
    [vc setTransVaule:^(BOOL status) {
        if (status) {
            _isAgreeBtn = YES;
            [_agreeBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        }else{
            _isAgreeBtn = NO;
            [_agreeBtn setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
        }
    }];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
    
}

- (void)nextBtnClick:(UIButton*)sender{
    if (_ischeckPhoneTrue == YES&&_isAgreeBtn == YES&&[_pwdField.text isEqualToString:_SMGCode]) {
        if (!IsEmptyValue(_checkPhone)) {
            MYYRegisterSubmitViewController* vc = [[MYYRegisterSubmitViewController alloc]init];
            self.hidesBottomBarWhenPushed = YES;
            vc.phone = _checkPhone;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        if ([_pwdField.text isEqualToString:@""]) {
            [self showAlert:@"验证码不能为空"];
        }else if (![_pwdField.text isEqualToString:_SMGCode]){
            [self showAlert:@"验证码不正确"];
        }else if (_isAgreeBtn == NO){
            [self showAlert:@"请同意《注册协议》"];
        }else if (_ischeckPhoneTrue == NO){
            [self customAlert:@"请填写正确手机号"];

        }
    }
}

//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField == _phoneField) {
//        if (!IsEmptyValue(_phoneField.text)&&[Command isMobileNumber:_phoneField.text]) {
//            
//        }else{
//            [self showAlert:@"手机号格式不正确"];
//        }
//    }else if (textField == _pwdField){
//    
//    }
//}

#pragma mark isExitsPhone手机号是否注册
- (void)checkPhoneDataRequest{
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",_phoneField.text]};
    [HTNetWorking postWithUrl:@"register?action=isExitsPhone" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"手机验证%@",str);
        if ([str rangeOfString:@"true"].location != NSNotFound) {
            _ischeckPhoneTrue = YES;
            if (_ischeckPhoneTrue == YES) {
                _checkPhone = _phoneField.text;
                _sendMessageBtn.recoderTime = @"yes";
                [_sendMessageBtn setKaishi:SendTime];
                [self getSMSCodeRequest];
            }
        }else if ([str rangeOfString:@"false"].location != NSNotFound){
            _ischeckPhoneTrue = NO;
            [self customAlert:@"手机已注册"];
        }else{
            _ischeckPhoneTrue = NO;
            [self customAlert:@"手机已注册"];
        }
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark 验证码请求
- (void)getSMSCodeRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",_phoneField.text]};
    [HTNetWorking postWithUrl:@"register?action=getSMSCode" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"验证码%@",str);
        _SMGCode = [Command replaceAllOthers:str];
    } fail:^(NSError *error) {
        
    }];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}
@end
