//
//  MYYLoginViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/5.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYLoginViewController.h"
#import "MYYRegisterViewController.h"
#import "MYYPasswordViewController.h"//找回密码
#import "RegistReferModel.h"
@interface MYYLoginViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *textField1;

@property(nonatomic,strong)UITextField *textField2;

@property(nonatomic,strong)UIButton *loginBtn;//登录

@property(nonatomic,strong)UIButton *RegisterBtn;//注册

@property(nonatomic,strong)UIButton *PasswordBtn;//找回密码

@end

@implementation MYYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationItemButton];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImage *image = [UIImage imageNamed:@"iconfont-touming"];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];

    [Command isloginRequest:^(bool str) {
        if (str) {
            //登录成功
            [self.navigationController popViewControllerAnimated:NO];
        }
    }];
    NSString* user= [[NSUserDefaults standardUserDefaults]objectForKey:USERPHONE];
    if (![[self convertNull:user] isEqualToString:@""]) {
        self.textField1.text = user;
    }
    NSString* pwd= [[NSUserDefaults standardUserDefaults]objectForKey:PASSWORD];
    if (![[self convertNull:pwd] isEqualToString:@""]) {
        self.textField2.text = pwd;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)navigationItemButton{
    self.navigationItem.title = @"登录";
    if (self.next==1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-touming"] style:UIBarButtonItemStylePlain target:self action:nil];
        [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0xffffff)];

    }
}

- (void)setupUI
{
    // 1.设置背景色
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    bgimage.image = [UIImage imageNamed:@"loginBG"];
    bgimage.userInteractionEnabled = YES;
    [self.view addSubview:bgimage];
    
    // 2.添加子视图
    UIImageView *logoimage = [[UIImageView alloc]initWithFrame:CGRectMake(mScreenWidth/2-155*MYWIDTH/2, mScreenHeight/6+10, 155*MYWIDTH, 72*MYWIDTH)];
    logoimage.image = [UIImage imageNamed:@"logo"];
    [bgimage addSubview:logoimage];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(20*MYWIDTH, mScreenHeight/3+30, mScreenWidth-40*MYWIDTH, 120*MYWIDTH)];
    bgview.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.8];
    bgview.layer.cornerRadius=7;
    [bgimage addSubview:bgview];
    
    
    UIImageView *titleimage1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20*MYWIDTH, 15, 18)];
    titleimage1.image = [UIImage imageNamed:@"0303"];
    [bgview addSubview:titleimage1];

    self.textField1 = [[UITextField alloc]initWithFrame:CGRectMake(50, 15*MYWIDTH, bgview.width-70, 30*MYWIDTH)];
    self.textField1.delegate = self;
    self.textField1.layer.cornerRadius = 5;
    self.textField1.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField1.layer.borderColor = [UIColor grayColor].CGColor;
    self.textField1.placeholder = @"请输入账号";
    [self.textField1 setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    NSString* user= [[NSUserDefaults standardUserDefaults]objectForKey:USERPHONE];
    if (![[self convertNull:user] isEqualToString:@""]) {
        self.textField1.text = user;
    }
    [bgview addSubview:self.textField1];
    
    UILabel *xian1 = [[UILabel alloc]initWithFrame:CGRectMake(20, bgview.height/2, bgview.width - 40, 1)];
    xian1.backgroundColor = UIColorFromRGB(0xD7D7D7);
    [bgview addSubview:xian1];
    
    UIImageView *titleimage2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, xian1.bottom+20*MYWIDTH, 15, 18)];
    titleimage2.image = [UIImage imageNamed:@"02020"];
    [bgview addSubview:titleimage2];
    
    self.textField2 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.textField1.frame), xian1.bottom+15*MYWIDTH, CGRectGetWidth(self.textField1.frame), CGRectGetHeight(self.textField1.frame))];
    self.textField2.delegate = self;
    self.textField2.layer.cornerRadius = 5;
    self.textField2.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField2.layer.borderColor = [UIColor grayColor].CGColor;
    self.textField2.placeholder = @"请输入密码";
    [self.textField2 setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    self.textField2.secureTextEntry = YES;
    [bgview addSubview:self.textField2];
    
    NSString* pwd= [[NSUserDefaults standardUserDefaults]objectForKey:PASSWORD];
    if (![[self convertNull:pwd] isEqualToString:@""]) {
        self.textField2.text = pwd;
    }
    
    self.loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(bgview.frame)+40, mScreenWidth-40, 45)];
    [self.loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.loginBtn.layer.cornerRadius = 5;
    [self.loginBtn setBackgroundColor:NavBarItemColor];
    [self.loginBtn addTarget:self action:@selector(LoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgimage addSubview:self.loginBtn];
    
    self.RegisterBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.loginBtn.frame)+10, 60, 40)];
    [self.RegisterBtn setTitle:@"注册" forState:UIControlStateNormal];
    self.RegisterBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.RegisterBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.RegisterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.RegisterBtn addTarget:self action:@selector(RegisterAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgimage addSubview:self.RegisterBtn];
    
    self.PasswordBtn = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth - 90, CGRectGetMaxY(self.loginBtn.frame)+10, 60, 40)];
    [self.PasswordBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    self.PasswordBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    self.PasswordBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.PasswordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.PasswordBtn addTarget:self action:@selector(PasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgimage addSubview:self.PasswordBtn];
}
- (void)LoginAction:(UIButton *)sender{
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
    if ([self.textField1.text isEqualToString:@""]) {
        [Command customAlert:@"请输入账号"];
        return;
    }
    if ([self.textField2.text isEqualToString:@""]) {
        [Command customAlert:@"请输入密码"];
        return;
    }
    if (!IsEmptyValue(self.textField1.text)&&!IsEmptyValue(self.textField2.text)) {
        [self loginDataRequest];
    }
}
//注册
- (void)RegisterAction:(UIButton *)sender{
    MYYRegisterViewController *registerViewController = [[MYYRegisterViewController alloc]init];
    registerViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerViewController animated:YES];
    
}
//找回密码
- (void)PasswordAction:(UIButton *)sender{
    MYYPasswordViewController *passwordViewController = [[MYYPasswordViewController alloc]init];
    passwordViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:passwordViewController animated:YES];
    
}

- (void)loginDataRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"accountname\":\"%@\",\"password\":\"%@\"}",self.textField1.text,self.textField2.text]};
    [HTNetWorking postWithUrl:@"mallLogin?action=checkMallLogin" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"登录数据%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            [Command customAlert:@"账号或密码不正确"];
        }
        if (!IsEmptyValue(array)) {
            NSDictionary* dict = array[0];
            RegistReferModel* model = [[RegistReferModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [[NSUserDefaults standardUserDefaults]setObject:model.phone forKey:USERPHONE];
            [[NSUserDefaults standardUserDefaults]setObject:model.name forKey:USENAME];
            [[NSUserDefaults standardUserDefaults]setObject:model.Id forKey:USERID];
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:IsLogin];
            [[NSUserDefaults standardUserDefaults]setObject:model.custtypeid forKey:CUSTTYPEID];
            [[NSUserDefaults standardUserDefaults]setObject:model.password forKey:PASSWORD];
            [[NSUserDefaults standardUserDefaults]setObject:model.accountname forKey:ACCOUNTNAME];
            
            NSArray *viewcontrollers=self.navigationController.viewControllers;
            if (viewcontrollers.count>1) {
                if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
                    //push方式
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else{
                //present方式
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } fail:^(NSError *error) {
        
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}
//以下两个代理方法可以防止键盘遮挡textview
-(void)textFieldDidBeginEditing:(UITextView *)textView{
    
    //这里的offset的大小是控制着呼出键盘的时候view上移多少。比如上移20，就给offset赋值-20，以此类推。也可以根据屏幕高度的不同做一个if判断。
    
    float offset = 0.0f;
    
    offset = -40;
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    
    float height = self.view.frame.size.height;
    
    CGRect rect = CGRectMake(0.0f, offset , width, height);
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
    
}
//完成编辑的时候下移回来（只要把offset重新设为0就行了）

-(void)textFieldDidEndEditing:(UITextView *)textView{
    
    float offset = 0.0f;
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    
    float height = self.view.frame.size.height;
    
    CGRect rect = CGRectMake(0.0f, offset , width, height);
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
    
}
@end
