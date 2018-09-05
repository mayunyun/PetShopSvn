//
//  TypeBaseViewController.m
//  BaseFrame
//
//  Created by LONG on 2017/12/1.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "TypeBaseViewController.h"
#import "NewTypeTableViewCell.h"
#import "MYYTypeItemsModel.h"
#import "MYYDetailsAndCommentViewController.h"
#import "MYYLoginViewController.h"
@interface TypeBaseViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong) UITableView *rightTableView;
@property(nonatomic,strong) NSMutableArray *itemsdataArray;

@end

@implementation TypeBaseViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self requestDataRightTableView];
    [self rightTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataRequest:) name:@"typeUpData" object:nil];
}
- (void)dataRequest:(NSNotification *)text{
    
    if ([text.userInfo[@"tag"] isEqualToString:_index]) {
        [self requestDataRightTableView];
    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"typeUpData" object:nil];
}
- (UITableView *)rightTableView{
    if (_rightTableView == nil){
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight-158)];
        if (statusbarHeight>20) {
            _rightTableView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight-158-24-34);
        }
        _rightTableView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.separatorStyle = NO;
        [_rightTableView registerNib:[UINib nibWithNibName:@"NewTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewTypeTableViewCell"];
        [self.view addSubview:_rightTableView];
        UIView *foodview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 8)];
        _rightTableView.tableFooterView = foodview;
        //     下拉刷新
        _rightTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestDataRightTableView];
            // 结束刷新
            [_rightTableView.mj_header endRefreshing];
            
        }];
        
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        _rightTableView.mj_header.automaticallyChangeAlpha = YES;
    }
    return _rightTableView;
}
- (void)requestDataRightTableView;
{
    if (_itemsdataArray == nil) {
        _itemsdataArray = [[NSMutableArray alloc]init];
    }else{
        [_itemsdataArray removeAllObjects];
    }
    
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"protypeidother\":\"%@\",\"sorts\":\"%@\"}",_idStr,@"zonghe"]};
    [HTNetWorking postWithUrl:@"mall/showproduct?action=loadProductInfo" refreshCache:YES params:params success:^(id response) {
        
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSSLog(@">>>>%@",array);
        //建立模型
        for (NSDictionary*dic in array) {
            MYYTypeItemsModel *model=[[MYYTypeItemsModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            //追加数据
            [self.itemsdataArray addObject:model];
        }
        [_rightTableView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
    
}
#pragma mark dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_itemsdataArray count];

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewTypeTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_itemsdataArray.count) {
        MYYTypeItemsModel *itemsModel = _itemsdataArray[indexPath.row];
        
        cell.titleLab.text = [NSString stringWithFormat:@"%@",itemsModel.proname];
        cell.guigeLab.text = [NSString stringWithFormat:@"%@",itemsModel.specification];
        cell.numerLab.text = [NSString stringWithFormat:@"￥%@     库存:%@",itemsModel.saleprice,@"0"];
        [cell setstockcount:itemsModel.jxproid price:itemsModel.minsaleprice secondunitname:itemsModel.secondunitname maintosecond:itemsModel.maintosecond];

        NSString *imageUrl = [NSString stringWithFormat:@"%@/productimages/%@",HTImgUrl,itemsModel.autoname];
        [cell.headerView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        cell.headerView.contentMode = UIViewContentModeScaleAspectFit;

        [cell.shopClickBut addTarget:self action:@selector(shopClickButAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.shopClickBut.tag = indexPath.row+130;
        
    }
    
    return cell;
}
//改变某字符串的大小
- (void)changeTextFont:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变大小之前的转换
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:text];
        //改变大小
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(location, length)];
        //赋值
        label.attributedText = str1;
    }
}
- (void)shopClickButAction:(UIButton *)but{
    MYYTypeItemsModel *itemsModel = _itemsdataArray[but.tag-130];

    [Command isloginRequest:^(bool islogin) {
        if (islogin) {
            [self addCarRequest:itemsModel];
        }else{
            UIAlertView *WXinstall=[[UIAlertView alloc]initWithTitle:@"亲，加入购物车需要您登录！" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];//一般在if判断中加入
            [WXinstall show];
        }
    }];
}
- (void)addCarRequest:(MYYTypeItemsModel*)model{
    /*
     /shoppingcart?action=addShoppingCart  添加购物车接口
     参数：proid,proname,price,count,type,specification
     */
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"price\":\"%@\",\"count\":\"%@\",\"type\":\"%@\",\"specification\":\"%@\",\"mainunitid\":\"%@\",\"mainunitname\":\"%@\",\"prono\":\"%@\"}",model.id,model.proname,model.saleprice,@"1",model.type,model.specification,model.mainunitid,model.mainunitname,model.prono]};
    [HTNetWorking postWithUrl:@"shoppingcart?action=addShoppingCart" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            [Command customAlert:@"加入购物车成功"];
        }else if ([str rangeOfString:@"false"].location!=NSNotFound){
            [Command customAlert:@"加入购物车失败"];
        }
    } fail:^(NSError *error) {
        
    }];
    
    
}
//监听点击事件 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
        if ([btnTitle isEqualToString:@"取消"]) {
                NSLog(@"你点击了取消");
        }else if ([btnTitle isEqualToString:@"确定"] ) {
                NSLog(@"你点击了确定");
            MYYLoginViewController* vc = [[MYYLoginViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
}
- (void)typeBut1Click:(UIButton *)but{
    
//    MYYTypeItemsModel *itemsmodel = _itemsdataArray[but.tag];
//    MYYDetailsAndCommentViewController *details = [[MYYDetailsAndCommentViewController alloc]init];
//    details.proid = [NSString stringWithFormat:@"%@",itemsmodel.id];
//    details.type = [NSString stringWithFormat:@"%@",itemsmodel.type];
//    details.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:details animated:YES];
}
#pragma mark delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130*MYWIDTH;

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYYTypeItemsModel *itemsmodel = _itemsdataArray[indexPath.row];
    MYYDetailsAndCommentViewController *details = [[MYYDetailsAndCommentViewController alloc]init];
    details.jxproid = [NSString stringWithFormat:@"%@",itemsmodel.jxproid];
    details.proid = [NSString stringWithFormat:@"%@",itemsmodel.id];
    details.type = [NSString stringWithFormat:@"%@",itemsmodel.type];
    details.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:details animated:YES];
}
@end
