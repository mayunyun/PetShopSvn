//
//  MYYShopOrderViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/9.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYShopOrderViewController.h"
#import "MYYShopOrderTableViewCell.h"
#import "MYYShopPayViewController.h"
#import "MYYShopOrderModel.h"
#import "MYYShopAddrModel.h"
#import "MYYAddManageViewController.h"
#import "MYYMinesearchAddressModel.h"
#import "JVShopcartBrandModel.h"
#import "MYYLoginViewController.h"
@interface MYYShopOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) MYYShopAddrModel* addrModel;

@end

@implementation MYYShopOrderViewController{
    
    UILabel        *_monlab;
    NSMutableArray* _dataArray;//订单商品
   
}
- (UITableView *)TableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight-45)];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"MYYShopOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MYYShopOrderTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (void)viewDidLoad {
    _addrModel = [[MYYShopAddrModel alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    self.navigationItem.title = @"确认订单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    
    [self TableView];
    [self fooderUIView];
    [self dataRequest];

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
    labe.text = @"实付金额:";
    labe.textColor = UIColorFromRGB(0x666666);
    [viewal addSubview:labe];
    
    _monlab = [[UILabel alloc]initWithFrame:CGRectMake(110, 12, 200, 20)];
    _monlab.textColor = UIColorFromRGB(0xE41D24);
    if (_next==0) {
        NSString* user= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:CUSTTYPEID]];
        if ([user isEqualToString:@"2"]) {
            _monlab.text = [NSString stringWithFormat:@"￥%.2f",[self.InfactPrice floatValue]];
        }else{
            _monlab.text = [NSString stringWithFormat:@"￥%.2f",[_proprice floatValue]*[_count intValue]];
        }
//        _monlab.text = self.InfactPrice;
        NSLog(@"价格………………%@数量……………………………………%@",_proprice,_count);
    }else{
        _monlab.text = [NSString stringWithFormat:@"￥%.2f",self.xiaojicount];
    }

    [viewal addSubview:_monlab];
    
    UIButton *monBut = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth - 100, 0, 100, 45)];
    [monBut setTitle:@"提交订单"forState:UIControlStateNormal];
    monBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [monBut setBackgroundColor:UIColorFromRGB(0xeb6876)];
    [monBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [monBut addTarget:self action:@selector(butwhihGo:) forControlEvents:UIControlEventTouchUpInside];
    [viewal addSubview:monBut];
    
}
//地址
- (UIView *)addressView{

    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 80)];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(8, 25, 30, 30)];
    image.image = [UIImage imageNamed:@"icon_location"];
    [view addSubview:image];
    UIImageView *imageyou = [[UIImageView alloc]initWithFrame:CGRectMake(mScreenWidth-30, 27.5, 25, 25)];
    imageyou.image = [UIImage imageNamed:@"iconfont-arrow"];
    [view addSubview:imageyou];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(45, 15, 100, 20)];
    name.text = [NSString stringWithFormat:@"收货人：%@",_addrModel.receivename];
    if (IsEmptyValue(_addrModel.receivename)) {
        if (IsEmptyValue(USENAME)) {
            name.text = [NSString stringWithFormat:@"收货人：%@",[[NSUserDefaults standardUserDefaults]objectForKey:USENAME]];
        }else{
            name.text = [NSString stringWithFormat:@"收货人：%@",[[NSUserDefaults standardUserDefaults]objectForKey:ACCOUNTNAME]];
        }
    }
    name.font = [UIFont systemFontOfSize:14];
    name.textColor = UIColorFromRGB(0x333333);
    CGSize maximumLabelSize = CGSizeMake(100, 20);
    CGSize expectSize = [name sizeThatFits:maximumLabelSize];
    name.frame = CGRectMake(40, 16, expectSize.width, expectSize.height);
    [view addSubview:name];
    
    UILabel *phonelab = [[UILabel alloc]initWithFrame:CGRectMake(name.size.width+55, 15, 100, 20)];
    phonelab.text = [NSString stringWithFormat:@"%@",_addrModel.receivephone];
    if (IsEmptyValue(_addrModel.receivephone)) {
        phonelab.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USERPHONE]];
    }
    phonelab.font = [UIFont systemFontOfSize:14];
    phonelab.textColor = UIColorFromRGB(0x333333);
    [view addSubview:phonelab];
    
    UILabel *addressLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 35, mScreenWidth-80, 40)];
    addressLab.text = [NSString stringWithFormat:@"收货地址: %@  %@%@%@%@",_addrModel.province,_addrModel.city,_addrModel.area,_addrModel.village,_addrModel.address];
    NSLog(@"%@",addressLab.text);
    if (IsEmptyValue(_addrModel.province)) {
        addressLab.text = @"收货地址:";
    }
    addressLab.font = [UIFont systemFontOfSize:12];
    addressLab.numberOfLines = 0;
    addressLab.textColor = UIColorFromRGB(0x666666);
    [view addSubview:addressLab];
    
    UIImageView *xian = [[UIImageView alloc]initWithFrame:CGRectMake(0, 78, mScreenWidth, 2)];
    xian.image = [UIImage imageNamed:@"组"];
    [view addSubview:xian];
    
    return view;
}

- (UIView *)xiaojiView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 50)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 30)];
    lab.text = @"商品小计";
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = UIColorFromRGB(0x333333);
    [view addSubview:lab];
    
    UILabel *pay = [[UILabel alloc]initWithFrame:CGRectMake(mScreenWidth-90, 10, 80, 30)];
    
    if (_next==0) {
//        pay.text = [NSString stringWithFormat:@"￥%.2f",[_proprice floatValue]*[_count intValue]];
        NSString* user= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:CUSTTYPEID]];
        if ([user isEqualToString:@"2"]) {
            pay.text = [NSString stringWithFormat:@"￥%.2f",[self.InfactPrice floatValue]];
        }else{
            pay.text = [NSString stringWithFormat:@"￥%.2f",[_proprice floatValue]*[_count intValue]];
        }
    }else{
        pay.text = [NSString stringWithFormat:@"￥%.2f",self.xiaojicount];
    }
    pay.font = [UIFont systemFontOfSize:13];
    pay.textAlignment = NSTextAlignmentRight;
    pay.textColor = UIColorFromRGB(0x333333);
    [view addSubview:pay];
    return view;
}
#pragma mark 订单提交
- (void)butwhihGo:(UIButton *)but{
    [Command isloginRequest:^(bool flag) {
        if (flag) {
            if (IsEmptyValue(_addrModel.cityid)||IsEmptyValue(_addrModel.areaid)||IsEmptyValue(_addrModel.villageid)) {
                [self showAlert:@"请完善您详细的收货地址"];
                return ;
            }
            if (_dataArray.count == 0) {
                [self showAlert:@"商品数据出现错误"];
                return;
            }
            /*
             订单提交：/myorder?action=addMyOrder   参数：custid，custname，custphone，custaddress，totalcount，totalmoney，provinceid，cityid,areaid,villageid  字表
             proid，proname,specification,price,count,money,type
             */
            NSMutableArray * jxproList = [NSMutableArray new];//判断库存
            NSMutableString* mustr = [[NSMutableString alloc]init];
            NSInteger totalcount = 0;
            CGFloat totalmoney = 0.0;
            int i = 0;
            
            if (self.next == 1) {//数据来自购物车
                for (MYYShopOrderModel* model in _dataArray) {
                
                    JVShopcartBrandModel *brandmodel = _dataArr[i];
                    i++;
                    NSString* user= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:CUSTTYPEID]];
                    NSString *jxdanweiid;
                    NSString *jxdanweiname;
                    NSString *jxprice;
                    NSString *jxcout;
                    NSString *jxcount;
                    NSString *jxtype;
                    NSString *price;
                    if ([user isEqualToString:@"1"]) {
                        jxdanweiid = [NSString stringWithFormat:@"%@",model.remainderunitid];
                        jxdanweiname = [NSString stringWithFormat:@"%@",model.mainunitname];
                        jxprice = [NSString stringWithFormat:@"%.2f",[model.price floatValue]/[model.maintosecond floatValue]];
                        jxcout = [NSString stringWithFormat:@"%zd",brandmodel.count*[model.maintosecond intValue]/[model.secondtoremainder intValue]];
                        jxcount = [NSString stringWithFormat:@"%zd",brandmodel.count*[model.maintosecond intValue]/[model.secondtoremainder intValue]];
                        jxtype = @"2";
                        price = [NSString stringWithFormat:@"%.2f",[model.price floatValue]/[model.secondtoremainder floatValue]];

                    }else if ([user isEqualToString:@"2"]){
                        jxdanweiid = [NSString stringWithFormat:@"%@",model.secondunitid];
                        jxdanweiname = [NSString stringWithFormat:@"%@",model.secondunitname];
                        jxprice = [NSString stringWithFormat:@"%.2f",[model.price floatValue]/[model.maintosecond floatValue]];
                        jxcout = [NSString stringWithFormat:@"%zd",brandmodel.count];
                        jxcount = [NSString stringWithFormat:@"%zd",brandmodel.count];
                        jxtype = @"2";
                        price = [NSString stringWithFormat:@"%.2f",[model.price floatValue]/[model.maintosecond floatValue]];

                    }else{
                        jxdanweiid = [NSString stringWithFormat:@"%@",model.mainunitid];
                        jxdanweiname = [NSString stringWithFormat:@"%@",model.mainunitname];
                        jxprice = [NSString stringWithFormat:@"%.2f",[model.price floatValue]];
                        jxcout = [NSString stringWithFormat:@"%zd",brandmodel.count];
                        jxcount = [NSString stringWithFormat:@"%zd",brandmodel.count*[model.maintosecond intValue]];
                        jxtype = @"1";
                        price = [NSString stringWithFormat:@"%.2f",[model.price floatValue]];
                    }
                    NSString* str = [NSString stringWithFormat:@"{\"table\":\"pro_order_detail\",\"proid\":\"%@\",\"proname\":\"%@\",\"specification\":\"%@\",\"price\":\"%@\",\"count\":\"%zd\",\"money\":\"%.2f\",\"type\":\"%@\",\"jxdanweiid\":\"%@\",\"jxdanweiname\":\"%@\",\"jxprice\":\"%@\",\"jxtype\":\"%@\",\"jxcount\":\"%@\"},",model.proid,model.proname,model.specification,price,brandmodel.count,[price floatValue]*brandmodel.count,model.type,jxdanweiid,jxdanweiname,jxprice,jxtype,jxcout];
                    
                    [mustr appendString:str];
                    totalcount += [[NSString stringWithFormat:@"%zd",brandmodel.count] integerValue];
                    totalmoney += [[NSString stringWithFormat:@"%.2f",[price floatValue]*brandmodel.count] floatValue];
                     NSLog(@"提交订单的model是-----%@+++++%@",model,brandmodel);
                    
                    NSMutableDictionary * jxproDic =[[NSMutableDictionary alloc]init];
                    [jxproDic setObject:model.proname forKey:@"proname"];
                    [jxproDic setObject:model.jxproid forKey:@"jxproid"];
                    [jxproDic setObject:jxcount forKey:@"count"];
                    [jxproList addObject:jxproDic];
                }
            }
            else if (self.next == 0){//数据来自商品立即购买
                MYYShopOrderModel* model  =  _dataArray[0];
        
                NSString* user= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:CUSTTYPEID]];
                NSString *jxdanweiid;
                NSString *jxdanweiname;
                NSString *jxprice;
                NSString *jxcout;
                NSString *jxcount;
                NSString *jxtype;
                NSString *price;
                if ([user isEqualToString:@"1"]) {
                    jxdanweiid = [NSString stringWithFormat:@"%@",model.remainderunitid];
                    jxdanweiname = [NSString stringWithFormat:@"%@",model.mainunitname];
                    jxprice = [NSString stringWithFormat:@"%.2f",[model.price floatValue]/[model.maintosecond floatValue]];
                    jxcout = [NSString stringWithFormat:@"%zd",[model.count integerValue]*[model.maintosecond intValue]/[model.secondtoremainder intValue]];
                    jxcount = [NSString stringWithFormat:@"%zd",[model.count integerValue]*[model.maintosecond intValue]/[model.secondtoremainder intValue]];
                    jxtype = @"2";
                    price = [NSString stringWithFormat:@"%.2f",[model.price floatValue]/[model.secondtoremainder floatValue]];
                    
                }else if ([user isEqualToString:@"2"]){
                    jxdanweiid = [NSString stringWithFormat:@"%@",model.secondunitid];
                    jxdanweiname = [NSString stringWithFormat:@"%@",model.secondunitname];
                    jxprice = [NSString stringWithFormat:@"%.2f",[model.price floatValue]/[model.maintosecond floatValue]];
                    jxcout = [NSString stringWithFormat:@"%zd",[model.count integerValue]];
                    jxcount = [NSString stringWithFormat:@"%zd",[model.count integerValue]];
                    jxtype = @"2";
                    price = [NSString stringWithFormat:@"%.2f",[model.price floatValue]/[model.maintosecond floatValue]];
                    
                }else{
                    jxdanweiid = [NSString stringWithFormat:@"%@",model.mainunitid];
                    jxdanweiname = [NSString stringWithFormat:@"%@",model.mainunitname];
                    jxprice = [NSString stringWithFormat:@"%.2f",[model.price floatValue]];
                    jxcout = [NSString stringWithFormat:@"%zd",[model.count integerValue]];
                    jxcount = [NSString stringWithFormat:@"%zd",[model.count integerValue]*[model.maintosecond intValue]];
                    jxtype = @"1";
                    price = [NSString stringWithFormat:@"%.2f",[model.price floatValue]];
                }
                NSString* str = [NSString stringWithFormat:@"{\"table\":\"pro_order_detail\",\"proid\":\"%@\",\"proname\":\"%@\",\"specification\":\"%@\",\"price\":\"%@\",\"count\":\"%@\",\"money\":\"%.2f\",\"type\":\"%@\",\"jxdanweiid\":\"%@\",\"jxdanweiname\":\"%@\",\"jxprice\":\"%@\",\"jxtype\":\"%@\",\"jxcount\":\"%@\",\"prono\":\"%@\"},",model.proid,model.proname,model.specification,price,model.count,[price floatValue]*[model.count integerValue],model.type,jxdanweiid,jxdanweiname,jxprice,jxtype,jxcout,model.prono];
                [mustr appendString:str];
                totalcount = [[NSString stringWithFormat:@"%@",model.count] integerValue];
                totalmoney = [[NSString stringWithFormat:@"%.2f",[price floatValue]*[model.count integerValue]] floatValue];
                
                NSMutableDictionary * jxproDic =[[NSMutableDictionary alloc]init];
                [jxproDic setObject:model.proname forKey:@"proname"];
                [jxproDic setObject:model.jxproid forKey:@"jxproid"];
                [jxproDic setObject:jxcount forKey:@"count"];
                [jxproList addObject:jxproDic];
            }
           
            NSString* prostr = mustr;
            if (prostr.length!=0) {
                NSRange range = {0,prostr.length - 1};
                prostr = [prostr substringWithRange:range];
            }
            NSLog(@"%@",mustr);
            NSString * addressString = [NSString stringWithFormat:@"%@%@%@%@%@",_addrModel.province,_addrModel.city,_addrModel.area,_addrModel.village,_addrModel.address];
            NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"table\":\"pro_order\",\"custid\":\"%@\",\"custname\":\"%@\",\"custphone\":\"%@\",\"receivename\":\"%@\",\"receivephone\":\"%@\",\"custaddress\":\"%@\",\"totalcount\":\"%@\",\"totalmoney\":\"%@\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"villageid\":\"%@\",\"proList\":[%@]}",_addrModel.custid,_addrModel.custname,_addrModel.phone,_addrModel.receivename,_addrModel.receivephone,addressString,[NSString stringWithFormat:@"%li",(long)totalcount],[NSString stringWithFormat:@"%.2f",totalmoney],_addrModel.provinceid,_addrModel.cityid,_addrModel.areaid,_addrModel.villageid,prostr]};
           
            NSLog(@"提交订单的参数是-----%@",params);
            NSMutableDictionary *jxproListDic = [[NSMutableDictionary alloc]init];
            [jxproListDic setValue:jxproList forKey:@"jxproList"];
            NSDictionary* KCparams = @{@"data":[self dictionaryToJson:jxproListDic]};//
            
            //判断库存
            
            [HTNetWorking postWithUrl:[NSString stringWithFormat:@"%@withUnLog/location?action=searchstockcount",jingXinYaoYe_Code_YZY] refreshCache:YES params:KCparams success:^(id response) {
                NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                NSLog(@"判断库存返回数据%@",str);
                if ([str rangeOfString:@"true"].location!=NSNotFound) {
                    
                    [HTNetWorking postWithUrl:@"myorder?action=addMyOrder" refreshCache:YES showHUD:@"" params:params success:^(id response) {
                        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                        NSLog(@"提交订单返回数据%@",str);
                        if (!IsEmptyValue(str)) {
                            if ([str rangeOfString:@"false"].location!=NSNotFound) {
                                
                            }else{
                                NSString*string =@"orderno:";
                                NSString*money = @"totalmoney:";
                                NSRange range = [str rangeOfString:string];//匹配得到的下标
                                NSRange range1 = [str rangeOfString:money];
                                NSLog(@"rang:%@\n,range1%@",NSStringFromRange(range),NSStringFromRange(range1));
                                NSRange noRange = NSMakeRange(range.location+range.length, range1.location - range.location - range.length);
                                NSRange mRange = NSMakeRange(range1.location+range1.length, str.length - 1 - range1.location - range1.length);
                                NSString* nostr = [str substringWithRange:noRange];//截取范围类的字符串
                                NSString* moneystr = [str substringWithRange:mRange];
                                NSLog(@"截取的值为：%@,%@",nostr,moneystr);
                                //[Command customAlert:@"加入订单成功"];
                                MYYShopPayViewController *shopPay = [[MYYShopPayViewController alloc]init];
                                shopPay.payMoney = [NSString stringWithFormat:@"%.2f",totalmoney];
                                shopPay.orderId = [NSString stringWithFormat:@"%@",nostr];
                                
                                shopPay.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:shopPay animated:YES];
                            }
                        }
                        
                    } fail:^(NSError *error) {
                        
                    }];
                    
                    
                }else{
                    //[self showAlert:str];
                    [self showAlertViewWithTitle:@"提示" message:str buttonArray:nil cancelButton:@"确定" buttonEvent:^(NSInteger buttonIndex) {
                        
                    }];
                }
            } fail:^(NSError *error) {
                
            }];
            
            
        }else{
            NSLog(@"登录失败");
            MYYLoginViewController* vc = [[MYYLoginViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return _dataArray.count+2;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }else if (indexPath.section == 1){
        if (_next==0&&indexPath.row==1) {
            return 90;
        }else if(_next==1){
            if (indexPath.row == 0 || indexPath.row == _dataArray.count+1) {
                return 50;
            }else{
                return 90;
            }
        }
    }
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    // 通过不同标识创建cell实例
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//
//    }
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section == 0) {
        [cell.contentView addSubview:[self addressView]];
    }else if (indexPath.section == 2){
        [cell.contentView addSubview:[self xiaojiView]];
    }else{
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"自营店"];
            cell.textLabel.text = @"爱宠自营";
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            UILabel *xian = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, mScreenWidth, 1)];
            xian.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [cell.contentView addSubview:xian];
        }else if (indexPath.row ==_dataArray.count+1){
            
            cell.textLabel.text = @"商家配送";
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
        }else{
            MYYShopOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYYShopOrderTableViewCell" forIndexPath:indexPath];
            if (!IsEmptyValue(_dataArray)) {
                MYYShopOrderModel *model = _dataArray[indexPath.row-1];
                JVShopcartBrandModel *brandmodel = _dataArr[indexPath.row-1];
                NSString* user= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:CUSTTYPEID]];
                if (self.next == 0) {
                    if ([user isEqualToString:@"2"]) {
                        [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HTImgUrl,@"productimages/",model.autoname]]];
                        cell.titleName.text = [NSString stringWithFormat:@"%@",model.proname];
                        cell.priceLab.text = [NSString stringWithFormat:@"￥%.2f",[self.price floatValue]];
                        cell.countLab.text = [NSString stringWithFormat:@"x%zd",[self.count integerValue]];
                    }else{
                        [cell setDataCount:[self.count integerValue] WithModel:model gouWuCheModel:brandmodel];
                    }
                }else{
                    [cell setDataCount:[self.count integerValue] WithModel:model gouWuCheModel:brandmodel];
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        MYYAddManageViewController *addmanage = [[MYYAddManageViewController alloc]init];
        addmanage.controller = @"1";
        [addmanage setTransVaule:^(MYYMinesearchAddressModel * model) {
            
            _addrModel.custname = model.custname;
            _addrModel.phone = model.phone;
            _addrModel.province = model.province;
            _addrModel.city = model.city;
            _addrModel.area = model.area;
            _addrModel.address = model.address;
            _addrModel.custid = model.custid;
            _addrModel.provinceid = model.provinceid;
            _addrModel.cityid = model.cityid;
            _addrModel.village = model.village;
            _addrModel.areaid = model.areaid;
            _addrModel.villageid = model.villageid;
            [_tableView reloadData];
        }];
        [self.navigationController pushViewController:addmanage animated:YES];
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 10)];
    header.backgroundColor = UIColorFromRGB(0xf0f0f0);
    return header;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 40;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
    
}

- (void)dataRequest{
    NSDictionary* addrparams = @{@"data":[NSString stringWithFormat:@"{\"id\":\"\"}"]};
    [HTNetWorking postWithUrl:@"myorder?action=searchAddressM" refreshCache:YES params:addrparams success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSSLog(@"默认地址请求%@",str);
        if (!IsEmptyValue(array)) {
            NSDictionary* dict = array[0];
            [_addrModel setValuesForKeysWithDictionary:dict];
        }
        [_tableView reloadData];
    } fail:^(NSError *error) {
        NSLog(@"默认地址请求失败");
    }];
    //
    NSDictionary* params;
    if (self.next == 1) {//数据来自购物车
        NSString *gouwucheID = [[NSString alloc]init];

        NSLog(@"%@",self.dataArr);
        for (JVShopcartBrandModel *brandModel in self.dataArr) {
            gouwucheID = [gouwucheID stringByAppendingFormat:@"%@,",brandModel.id];
        }
        params = @{@"data":[NSString stringWithFormat:@"{\"shoppingcardids\":\"%@\"}", [gouwucheID substringToIndex:[gouwucheID length]- 1]]};
    }else if (self.next == 0){//数据来自商品立即购买
        self.Id = [Command convertNull:self.Id];
        params = @{@"data":[NSString stringWithFormat:@"{\"type\":\"%@\",\"proid\":\"%@\",\"shoppingcardids\":\"%@\",\"count\":\"%@\",\"id\":\"%@\"}",self.type,self.proid,@"",self.count,self.Id]};
    }
    NSLog(@"%@",params);


    [HTNetWorking postWithUrl:@"myorder?action=searchProDetai" refreshCache:YES params:params success:^(id response) {
       // NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@">>>>%@",str);

        if (!IsEmptyValue(array)) {
            NSLog(@"%@",array);
            //建立模型
            for (NSDictionary*dic in array) {
                MYYShopOrderModel *model=[[MYYShopOrderModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [_dataArray addObject:model];
            }

        }
        [_tableView reloadData];
    } fail:^(NSError *error) {
        NSLog(@"购物车请求失败");
    }];
}
//字典转json格式字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
