//
//  NewTypeViewController.m
//  BaseFrame
//
//  Created by LONG on 2017/12/1.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "NewTypeViewController.h"
#import "TypeBaseViewController.h"
#import "HXSearchBar.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeController.h"
#import "MYYLoginViewController.h"
#import "MYYSaoMiaoLoginViewController.h"
#import "MYYTypeDetailsViewController.h"
#import "Reachability.h"
@interface NewTypeViewController ()<UISearchBarDelegate>{
    HXSearchBar *_search;//搜索

}

@end

@implementation NewTypeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = NavBarItemColor;
    [self setStatusBarBackgroundColor:[UIColor clearColor]];

    if ([_controller isEqualToString:@"home"]) {
        self.selectIndex = _row;
        
        
    }

}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //通知中心注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [self searchview];
    [self requestDataLeftTableView];
    
}
- (void)reachabilityChanged:(NSNotification *)note
{
    
    
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status==ReachableViaWiFi||status==ReachableViaWWAN) {
    
        [self requestDataLeftTableView];
        
    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}
- (void)requestDataLeftTableView
{
    __weak typeof (self)weakself = self;

    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"%@",Type_URL] refreshCache:YES params:nil success:^(id response) {
        
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"分类返回arr%@",array);
        [self setUpAllChildViewController:array];
        
        [self setUpDisplayStyle:^(UIColor *__autoreleasing *titleScrollViewBgColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIColor *__autoreleasing *proColor, UIFont *__autoreleasing *titleFont, BOOL *isShowProgressView, BOOL *isOpenStretch, BOOL *isOpenShade) {


            *selColor = NavBarItemColor;

            *isOpenShade = NO;
            
        }];
        if (weakself.isLoadTitles == NO) {
            [weakself setUpAllTitle];
            weakself.isLoadTitles = YES;
        };
//
//
//        [self setUpTitleScale:^(CGFloat *titleScale) { //titleScale范围在0到1之间  <0 或者 > 1 则默认不缩放 默认设置titleScale就开启缩放，不设置则关闭
//            *titleScale = 0.3;
//        }];
        
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark - 添加所有子控制器
- (void)setUpAllChildViewController:(NSArray*)arr;
{
    for (NSInteger i = 0; i < arr.count; i++) {
        TypeBaseViewController *vc = [[TypeBaseViewController alloc]init];
        vc.title = [arr[i] objectForKey:@"name"];
        vc.titleStr = [arr[i] objectForKey:@"name"];
        vc.idStr = [arr[i] objectForKey:@"id"];
        vc.index = [NSString stringWithFormat:@"%zd",i];
        [self addChildViewController:vc];
    }
}
- (UISearchBar *)searchview{
    if (_search == nil) {
        
        //        self.navigationItem.leftBarButtonItem = nil;
        UIButton* zbarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        zbarBtn.frame = CGRectMake(0, 0, 30, 30);
        [zbarBtn setImage:[UIImage imageNamed:@"homezbar"] forState:UIControlStateNormal];
        zbarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [zbarBtn addTarget:self action:@selector(leftNavBarClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:zbarBtn];
        self.navigationItem.leftBarButtonItem = left;
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth-60, 30)];
        //加上搜索栏
        _search = [[HXSearchBar alloc] initWithFrame:titleView.bounds];
        _search.backgroundColor = [UIColor clearColor];
        _search.delegate = self;
        //输入框提示
        _search.placeholder = @"搜索你想要的";
        //光标颜色
        _search.cursorColor = [UIColor blackColor];
        //TextField
        _search.searchBarTextField.layer.masksToBounds = YES;
        _search.searchBarTextField.layer.cornerRadius = 15;
//        _search.searchBarTextField.layer.borderColor = UIColorFromRGB(0xececec).CGColor;
//        _search.searchBarTextField.layer.borderWidth = 1.0;
        
        //清除按钮图标
        _search.clearButtonImage = [UIImage imageNamed:@"demand_delete"];
        
        //去掉取消按钮灰色背景
        _search.hideSearchBarBackgroundImage = YES;
        [titleView addSubview:_search];
        self.navigationItem.titleView = titleView;
    }
    return _search;
}
- (void)leftNavBarClick:(UIButton*)sender{
    [Command isloginRequest:^(bool str) {
        if (str) {
            //登录成功
            [self initWithQRCodeController];
        }else{
            //登录失败
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录后才可以进行扫描" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                MYYLoginViewController* vc = [[MYYLoginViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    
    
}
//扫一扫
- (void)initWithQRCodeController{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusDenied){
        if (IS_VAILABLE_IOS8) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相机权限受限" message:@"请在iPhone的\"设置->隐私->相机\"选项中,允许\"蛋事\"访问您的相机." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([self canOpenSystemSettingView]) {
                    [self systemSettingView];
                }
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"相机权限受限" message:@"请在iPhone的\"设置->隐私->相机\"选项中,允许\"拇指营销\"访问您的相机." delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
            [alert show];
        }
        
        return;
    }
    
    QRCodeController *qrcodeVC = [[QRCodeController alloc] init];
    qrcodeVC.view.alpha = 0;
    [qrcodeVC setDidReceiveBlock:^(NSString *result) {
        NSSLog(@"%@", result);
        //        if ([result isEqualToString:@"login"]){
        [self saomaloginRequest:(result)];
        
        //        }
    }];
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [del.window.rootViewController addChildViewController:qrcodeVC];
    [del.window.rootViewController.view addSubview:qrcodeVC.view];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        qrcodeVC.view.alpha = 1;
    } completion:^(BOOL finished) {
    }];
    
}
//扫描登录
- (void)saomaloginRequest:(NSString*)uuid{
    /*
     mallLogin?action=saomaMallLogin
     */
    NSString* accountname= [[NSUserDefaults standardUserDefaults]objectForKey:ACCOUNTNAME];
    NSString* pwd = [[NSUserDefaults standardUserDefaults]objectForKey:PASSWORD];
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"accountname\":\"%@\",\"password\":\"%@\",\"uuid\":\"%@\"}",accountname,pwd,uuid]};
    [HTNetWorking postWithUrl:@"mallLogin?action=saomaMallLogin" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            
            MYYSaoMiaoLoginViewController *login = [[MYYSaoMiaoLoginViewController alloc]init];
            login.hidesBottomBarWhenPushed = YES;
            login.uuid = uuid;
            [self.navigationController pushViewController:login animated:YES];
            
        }else if ([str rangeOfString:@"false"].location!=NSNotFound){
            [Command customAlert:@"提示用户不存在"];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}
#pragma mark - UISearchBar Delegate
//已经开始编辑时的回调
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    //    HXSearchBar *sear = (HXSearchBar *)searchBar;
    //    //取消按钮
    //    sear.cancleButton.backgroundColor = [UIColor clearColor];
    //    [sear.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    //    [sear.cancleButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    //    sear.cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"搜索" forState:UIControlStateNormal];
            [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
}

//编辑文字改变的回调
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"searchText:%@",searchText);
}

//搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_search resignFirstResponder];// 放弃第一响应者
    MYYTypeDetailsViewController* vc = [[MYYTypeDetailsViewController alloc]init];
    if (!IsEmptyValue(_search.text)) {
        vc.controller = @"search";
        vc.pronameLIKE = _search.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self.view endEditing:YES];
}

//取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_search resignFirstResponder];// 放弃第一响应者
    MYYTypeDetailsViewController* vc = [[MYYTypeDetailsViewController alloc]init];
    if (!IsEmptyValue(_search.text)) {
        vc.controller = @"search";
        vc.pronameLIKE = _search.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self.view endEditing:YES];
    
}
/**
 *  是否可以打开设置页面
 *
 */
- (BOOL)canOpenSystemSettingView {
    if (IS_VAILABLE_IOS8) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

/**
 *  跳到系统设置页面
 */
- (void)systemSettingView {
    if (IS_VAILABLE_IOS8) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

@end
