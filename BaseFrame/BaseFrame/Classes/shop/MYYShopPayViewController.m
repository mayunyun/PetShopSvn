//
//  MYYShopPayViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/9.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYShopPayViewController.h"
#import "MYYMineRechargeViewController.h"
#import "Paydetail.h"
#import "RegistReferModel.h"
#import "JVShopcartBrandModel.h"
#import "MYYFaHuoViewController.h"
#import "MYYPayMentOrderViewController.h"
#import "MYYGoodsOrderViewController.h"
@interface MYYShopPayViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString* _balanceStr;
    
}
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation MYYShopPayViewController{
    UILabel       *_monlab;
    UIButton      *_AlipayBut;//支付宝
    UIButton      *_WeiXinBut;//微信
    UIButton      *_ZhangHuYuE;//账户余额支付
    UIButton      *_HuoDaoFK;//货到付款
}

- (UITableView *)TableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight-45)];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.scrollEnabled =NO; //设置tableview 不能滚动
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"MYYShopOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MYYShopOrderTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (void)viewDidLoad {
    self.navigationItem.title = @"选择支付方式";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    [self TableView];
    [self fooderUIView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBaseAliPayTrue:) name:AliPayTrue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBaseWXPayTrue:) name:WXPayTrue object:nil];
    
}

//json格式字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}
//字典转json格式字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self searchUserInfoRequest];
}

- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliPayTrue object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WXPayTrue object:nil];
}
- (void)fooderUIView{
    
    //
    UIView *viewal = [[UIView alloc]initWithFrame:CGRectMake(0, mScreenHeight-45, mScreenWidth, 45)];
    viewal.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewal];
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 1)];
    xian.backgroundColor = UIColorFromRGB(0xefefef);
    [viewal addSubview:xian];
    UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(8, 12, 110, 20)];
    labe.text = @"需付款:";
    labe.textColor = UIColorFromRGB(0x666666);
    [viewal addSubview:labe];
    
    _monlab = [[UILabel alloc]initWithFrame:CGRectMake(110, 12, 200, 20)];
    _monlab.textColor = UIColorFromRGB(0xE41D24);
    _monlab.text = [NSString stringWithFormat:@"￥%@",self.payMoney];
    [viewal addSubview:_monlab];
    
    UIButton *monBut = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth - 100, 0, 100, 45)];
    [monBut setTitle:@"确定"forState:UIControlStateNormal];
    monBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [monBut setBackgroundColor:UIColorFromRGB(0xeb6876)];
    [monBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [monBut addTarget:self action:@selector(butGo:) forControlEvents:UIControlEventTouchUpInside];
    [viewal addSubview:monBut];
    
}
- (void)butGo:(UIButton *)but{
    NSLog(@"钱数%@,订单号%@",_payMoney,_orderId);
    if (_AlipayBut.selected == YES) {
        [Paydetail zhiFuBaoname:@"测试" titile:@"测试" price:_payMoney orderId:_orderId notice:@"0"];
        
    }else if (_WeiXinBut.selected == YES){////@"0.01"
        [Paydetail wxname:@"爱宠商城订单" titile:_orderId price:_payMoney orderId:_orderId notice:@"0"];
    }else if(_ZhangHuYuE.selected == YES){
        [self zhanghuRequest];
    }else if (_HuoDaoFK.selected == YES){
        [self huodaoRequest];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 3;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    // 通过不同标识创建cell实例
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"yue"];
//            cell.textLabel.text = @"账户余额(可用余额￥0.00)";
            cell.textLabel.text = [NSString stringWithFormat:@"账户余额(可用余额￥%.2f)",[_balanceStr floatValue]];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            UILabel *xian = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, mScreenWidth, 1)];
            xian.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [cell.contentView addSubview:xian];
            if (_ZhangHuYuE == nil) {
                _ZhangHuYuE = [UIButton buttonWithType:UIButtonTypeCustom];
            }
            _ZhangHuYuE .frame = CGRectMake(mScreenWidth-50, 10, 30, 30);
            
            [_ZhangHuYuE setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
            [_ZhangHuYuE setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
            if (_HuoDaoFK.selected || _AlipayBut.selected || _WeiXinBut.selected) {
                _ZhangHuYuE.selected = NO;
            }else{
                _ZhangHuYuE.selected = YES;
            }
            [_ZhangHuYuE addTarget:self action:@selector(ZhangHuYuEButAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_ZhangHuYuE];
        }else if (indexPath.row == 1){
            cell.imageView.image = [UIImage imageNamed:@"货到付款"];
            cell.textLabel.text = @"物流代收";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            UILabel *xian = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, mScreenWidth, 1)];
            xian.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [cell.contentView addSubview:xian];
            
            if (_HuoDaoFK == nil) {
                _HuoDaoFK = [UIButton buttonWithType:UIButtonTypeCustom];
            }
            _HuoDaoFK .frame = CGRectMake(mScreenWidth-50, 10, 30, 30);
            
            [_HuoDaoFK setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
            [_HuoDaoFK setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
            if (_ZhangHuYuE.selected || _AlipayBut.selected || _WeiXinBut.selected) {
                _HuoDaoFK.selected = NO;
            }else{
                _HuoDaoFK.selected = YES;
            }
            [_HuoDaoFK addTarget:self action:@selector(HuoDaoFKButAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_HuoDaoFK];
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            cell.imageView.image = [UIImage imageNamed:@"充值"];
            cell.textLabel.text = @"账户余额充值";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            
            UIButton * payBut = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth-80, 10, 50, 30)];
            [payBut setTitle:@"充值" forState:UIControlStateNormal];
            [payBut setTitleColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1] forState:UIControlStateNormal];
            payBut.titleLabel.font = [UIFont systemFontOfSize:13];
            [payBut addTarget:self action:@selector(goPayButAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:payBut];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"在线支付";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            UILabel *xian = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, mScreenWidth, 1)];
            xian.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [cell.contentView addSubview:xian];
        }else if (indexPath.row == 1){
            cell.imageView.image = [UIImage imageNamed:@"支付宝"];
            cell.textLabel.text = @"支付宝";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            UILabel *xian = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, mScreenWidth, 1)];
            xian.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [cell.contentView addSubview:xian];
            
            if (_AlipayBut == nil) {
                _AlipayBut = [UIButton buttonWithType:UIButtonTypeCustom];
            }
            _AlipayBut .frame = CGRectMake(mScreenWidth-50, 10, 30, 30);
        
            [_AlipayBut setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
            [_AlipayBut setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
            if (_ZhangHuYuE.selected || _HuoDaoFK.selected || _WeiXinBut.selected) {
                _AlipayBut.selected = NO;
            }else{
                _AlipayBut.selected = YES;
            }
            [_AlipayBut addTarget:self action:@selector(AlipayButAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_AlipayBut];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"微信"];
            cell.textLabel.text = @"微信支付";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            
            if (_WeiXinBut == nil) {
                _WeiXinBut = [UIButton buttonWithType:UIButtonTypeCustom];
            }
            _WeiXinBut .frame = CGRectMake(mScreenWidth-50, 10, 30, 30);
            
            [_WeiXinBut setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
            [_WeiXinBut setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
            if (_ZhangHuYuE.selected || _AlipayBut.selected || _HuoDaoFK.selected) {
                _WeiXinBut.selected = NO;
            }else{
                _WeiXinBut.selected = YES;
            }
            [_WeiXinBut addTarget:self action:@selector(WeiXinButAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_WeiXinBut];
        }
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 10)];
    header.backgroundColor = UIColorFromRGB(0xf0f0f0);
    return header;
}

- (void)goPayButAction{
    MYYMineRechargeViewController* vc = [[MYYMineRechargeViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)AlipayButAction{
    _AlipayBut.selected = YES;
    _HuoDaoFK.selected = NO;
    _ZhangHuYuE.selected = NO;
    _WeiXinBut.selected = NO;
}
- (void)WeiXinButAction{
    _WeiXinBut.selected = YES;
    _HuoDaoFK.selected = NO;
    _AlipayBut.selected = NO;
    _ZhangHuYuE.selected = NO;

}
- (void)ZhangHuYuEButAction{
    _ZhangHuYuE.selected = YES;
    _HuoDaoFK.selected = NO;
    _AlipayBut.selected = NO;
    _WeiXinBut.selected = NO;

}
- (void)HuoDaoFKButAction{
    _HuoDaoFK.selected = YES;
    _ZhangHuYuE.selected = NO;
    _AlipayBut.selected = NO;
    _WeiXinBut.selected = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchUserInfoRequest{
/*
 /mallLogin?action=searchUserInfo"
 */
    [HTNetWorking postWithUrl:@"mallLogin?action=searchUserInfo" refreshCache:YES params:nil success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"账户余额%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            RegistReferModel* model = [[RegistReferModel alloc]init];
            [model setValuesForKeysWithDictionary:array[0]];
            _balanceStr = [NSString stringWithFormat:@"%@",model.balance];
        }
        [_tableView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
    
}
-(void)getLoadDataBaseAliPayTrue:(NSNotification *)notice{
    /*
     {
     result = "{"alipay_trade_app_pay_response":{"code":"10000","msg":"Success","app_id":"2016020201135575","auth_app_id":"2016020201135575","charset":"utf-8","timestamp":"2017-09-11 12:07:04","total_amount":"0.01","trade_no":"2017091121001004730285476459","seller_id":"2088911120626880","out_trade_no":"a259a638a2494216bdad-62"},"sign":"avQ9kA4WQR8XqkDbFUPtNgNtSDV79dKGYo4xfxNClRdXolGr5zvDaRS+3zpECgGK9bQIP1/kkTb/T27S3F7JUxd65aMkMarWECIlu31KYqUBso1HQoIInEh+zU/UzWlQWDQgqlI7bXbAmiSnR5mpXWhiT4k0TrqXoa8UH3WZwLI=","sign_type":"RSA"}";
     resultStatus = "9000";
     memo = ""
     }
     
     {
     result = "";
     resultStatus = "6001";
     memo = "用户中途取消"
     }
     */
    if (notice.userInfo) {
        if ([[notice.userInfo objectForKey:@"resultStatus"] intValue] == 9000 ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"充值成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            [self commitDataForOrderWithPaidType:@"爱宠商城支付宝支付"];

        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:[notice.userInfo objectForKey:@"memo"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
}
-(void)getLoadDataBaseWXPayTrue:(NSNotification *)notice{
    [self commitDataForOrderWithPaidType:@"爱宠商城微信支付"];
}

-(void)commitDataForOrderWithPaidType:(NSString *)paidType{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];

    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"orderno\":\"%@\"}",_orderId]};
    [HTNetWorking postWithUrl:@"/myorder?action=getOrderInfo" refreshCache:YES params:params success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            
            if (array.count) {
                [dic setObject:[array[0] objectForKey:@"totalcount"] forKey:@"orderCount"];
                [dic setObject:[array[0] objectForKey:@"custaddress"] forKey:@"receiveaddr"];
                [dic setObject:[array[0] objectForKey:@"custname"] forKey:@"custName"];
                [dic setObject:@"146" forKey:@"salerid"];
                [dic setObject:@"0" forKey:@"orderStatus"];
                [dic setObject:[array[0] objectForKey:@"totalmoney"] forKey:@"orderMoney"];
                [dic setObject:[array[0] objectForKey:@"totalmoney"] forKey:@"returnordermoney"];
                [dic setObject:@"审批结束" forKey:@"spnodename"];
                [dic setObject:[array[0] objectForKey:@"custaddress"] forKey:@"custaddr"];
                [dic setValue:paidType forKey:@"paidtype"];
                [dic setObject:@"0" forKey:@"daidai"];
                [dic setObject:[array[0] objectForKey:@"custid"] forKey:@"custid"];
                [dic setObject:@"1" forKey:@"spStatus"];
                [dic setObject:@"0" forKey:@"daishoumoney"];
                [dic setObject:[array[0] objectForKey:@"receivename"] forKey:@"receiver"];
                [dic setObject:[array[0] objectForKey:@"receivephone"] forKey:@"receivertel"];
                [dic setObject:@"3" forKey:@"addType"];
                [dic setObject:[array[0] objectForKey:@"logisticsid"] forKey:@"logisticsid"];
                [dic setObject:@"0" forKey:@"creditLine"];
                [dic setObject:@"爱宠商城" forKey:@"saler"];
                [dic setObject:@"0" forKey:@"logisticsname"];
                [self dataRequestForProInfo:[array[0] objectForKey:@"id"] WithDic:dic AndWithOrderNo:_orderId AndWithMoney:[array[0] objectForKey:@"totalmoney"]];
                
            }
            
        }
    } fail:^(NSError *error) {
        
    }];
    
    
    
    
    

}
-(void)dataRequestForProInfo:(NSString *)orderid WithDic:(NSMutableDictionary *)dic AndWithOrderNo:(NSString *)orderno AndWithMoney:(NSString *)money{
    
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"orderid\":\"%@\"}",orderid]};
    [HTNetWorking postWithUrl:@"/myorder?action=getOrderDetailInfo" refreshCache:YES params:params success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            NSMutableArray * jxproList = [NSMutableArray new];
            for (NSDictionary * dict in array) {
                NSMutableDictionary * jxproDic =[[NSMutableDictionary alloc]init];
                NSString *jxmoney = [NSString stringWithFormat:@"%.2f",[dict[@"jxprice"] floatValue]*[dict[@"jxcount"] integerValue]];
                
                [jxproDic setObject:@"125" forKey:@"saletype"];
                [jxproDic setObject:dict[@"specification"] forKey:@"specification"];
                [jxproDic setObject:dict[@"jxprice"] forKey:@"singleprice"];
                [jxproDic setObject:dict[@"jxdanweiid"] forKey:@"prounitid"];
                [jxproDic setObject:dict[@"jxproid"] forKey:@"proid"];
                [jxproDic setObject:dict[@"proname"] forKey:@"proname"];
                [jxproDic setObject:dict[@"jxprice"] forKey:@"saledprice"];
                [jxproDic setObject:dict[@"jxtype"] forKey:@"type"];
                [jxproDic setObject:jxmoney forKey:@"totalmoney"];
                [jxproDic setObject:dict[@"jxdanweiname"] forKey:@"prounitname"];
                [jxproDic setObject:@"pro_orderDetail" forKey:@"table"];
                [jxproDic setObject:dict[@"prono"] forKey:@"prono"];
                [jxproDic setObject:dict[@"jxcount"] forKey:@"remaincount"];
                [jxproDic setObject:dict[@"jxcount"] forKey:@"maincount"];
                [jxproDic setObject:jxmoney forKey:@"saledmoney"];
                [jxproList addObject:jxproDic];
            }
            
            [dic setValue:jxproList forKey:@"jxproList"];
            
            //正式地址ip http://118.190.47.231/jx
            //    测试地址ip http://192.168.1.45:8080/jingxin
            NSDictionary* params = @{@"data":[self dictionaryToJson:dic]};
            NSLog(@"提交京新数据库参数%@",params);
            
            [HTNetWorking postWithUrl:[NSString stringWithFormat:@"%@withUnLog/location?action=addOrder",jingXinYaoYe_Code_YZY] refreshCache:YES params:params success:^(id response) {
                NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                NSLog(@"提交京新数据库订单返回的内容%@",str);
                if ([str rangeOfString:@"true"].location!=NSNotFound) {
                    MYYGoodsOrderViewController* vc = [[MYYGoodsOrderViewController alloc]init];
                    vc.mark = 1;
                    vc.controller = @"pay";
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [self showAlert:str];
                    
                }
            } fail:^(NSError *error) {
                
            }];
            
        }
    } fail:^(NSError *error) {
        
    }];
    
}
- (void)zhanghuRequest{
    /*
     zhifubao?action=yueZhiFu
     */
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"orderno\":\"%@\"}",self.orderId]};
    [HTNetWorking postWithUrl:@"zhifubao?action=yueZhiFu" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"余额支付%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            [self commitDataForOrderWithPaidType:@"爱宠商城余额支付"];
            
        }else{
            [self showAlert:str];
        }
    } fail:^(NSError *error) {
        
    }];

}

- (void)huodaoRequest{
    /*
     zhifubao?action=xianXiaZhiFu
     */
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"orderno\":\"%@\"}",self.orderId]};
    [HTNetWorking postWithUrl:@"zhifubao?action=xianXiaZhiFu" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"线下支付%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            [self commitDataForOrderWithPaidType:@"爱宠商城物流代收"];
        }else{
            [self showAlert:str];
        }
    } fail:^(NSError *error) {
        NSLog(@"请求失败返回的信息%@",error);
    }];

}

@end
