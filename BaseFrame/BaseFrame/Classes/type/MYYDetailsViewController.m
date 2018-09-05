//
//  MYYDetailsViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/4.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYDetailsViewController.h"
#import "MYYDetailsWebModel.h"

@interface MYYDetailsViewController ()<UIWebViewDelegate>
{
    UIWebView* _webView;
    CGFloat _documentHeight;
    MBProgressHUD* _hud;
    MYYDetailsWebModel* _promodel;
}
@end

@implementation MYYDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = YES;
    _promodel = [[MYYDetailsWebModel alloc]init];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, kScreen_Height - 64 - 40)];
    if (statusbarHeight>20) {
        _webView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight-88-40-34);
    }
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
//    _webView.scrollView.scrollEnabled = NO;
    _webView.scrollView.contentSize = CGSizeMake(kScreen_Width, kScreen_Height);
    [self.view addSubview:_webView];
    [self dataRequest];
}
- (void)setUpViewDetails{
    [self dataRequest];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:
     @"<style type=\"text/css\"> img {"
     "width:100%;"
     "height:auto;"
     "}"
     "p {"
     "word-wrap:break-word;"
     "}"
     "</style>"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    CGFloat documentHeight= [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    NSLog(@"webView的高度-----%f",documentHeight);
    _documentHeight = documentHeight;
    _webView.scrollView.contentSize = CGSizeMake(kScreen_Width - 20, documentHeight);
    [_hud hideAnimated:YES];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    //进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //_hud.labelText = @"网络不给力，正在加载中...";
    [_hud showAnimated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nonnull NSError *)error
{
    NSLog(@"didFailLoadWithError===%@", error);
}


- (void)dataRequest{
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"type\":\"%@\"}",self.proid,self.type]};
    [HTNetWorking postWithUrl:@"mall/showproduct?action=productDetail" refreshCache:YES params:params success:^(id response) {
        //NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            NSDictionary* dict = array[0];
            [_promodel setValuesForKeysWithDictionary:dict];
            NSLog(@"详情%@",array);
            NSString* linkCss = @"<style type=\"text/css\"> img {"
            "width:100%;"
            "height:auto;"
            "}"
            "</style>";
            NSString* baseurl = HTImgUrl;
            NSString* imageurl = [self replaceAllOthers:baseurl];
            if (!IsEmptyValue(_promodel.note)) {
                [_webView loadHTMLString:[NSString stringWithFormat:@"%@%@",_promodel.note,linkCss] baseURL:[NSURL URLWithString:imageurl]];
            }
        }
       
    } fail:^(NSError *error) {
        
    }];
}


//请求到的是字符串需要处理一下
- (NSString *)replaceAllOthers:(NSString *)responseString
{
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"/danshi1" withString:@""];
    return returnString;
}

@end
