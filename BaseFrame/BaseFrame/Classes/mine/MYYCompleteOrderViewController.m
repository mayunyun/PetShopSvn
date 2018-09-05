//
//  MYYCompleteOrderViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYCompleteOrderViewController.h"
#import "MYYMyOrterTableViewCell.h"
#import "MYYCoderCommentViewController.h"//评价

@interface MYYCompleteOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation MYYCompleteOrderViewController{
    NSMutableArray *_prolistArr;
    NSInteger _page;

}


- (UITableView *)TableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight-104)];
        if (statusbarHeight>20) {
            _tableView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight-104-24-34);
        }
        if (self.mark==1) {
            _tableView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight);
        }
        _tableView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"MYYMyOrterTableViewCell" bundle:nil] forCellReuseIdentifier:@"MYYMyOrterTableViewCell"];
        [self.view addSubview:_tableView];
        //下拉刷新
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            if (!IsEmptyValue(_dataArr)) {
                [_dataArr removeAllObjects];
            }
            [self dataRequest];
            [_tableView.mj_header endRefreshing];
            
        }];
        //
        _tableView.mj_header.automaticallyChangeAlpha = YES;
        //
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _page ++;
            [self dataRequest];
            [_tableView.mj_footer endRefreshing];
        }];
    }
    return _tableView;
}
- (void)viewDidLoad {
    self.navigationItem.title = @"待评价";
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArr = [[NSMutableArray alloc]init];
    _prolistArr = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    _page=1;
    [self TableView];
    [self dataRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi) name:@"orderUpData4" object:nil];
}

- (void)tongzhi{
    
    _page = 1;
    [self dataRequest];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderUpData4" object:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (_prolistArr.count>indexPath.row) {
//        NSArray* prolist = _prolistArr[indexPath.row];
//        return 120 + prolist.count*70;
//    }
//    return 190;
    if (_dataArr.count) {
        MYYMyOrderModel *model = _dataArr[indexPath.row];
        if (!IsEmptyValue(_prolistArr)) {
            for (NSArray* arr in _prolistArr) {
                if (!IsEmptyValue(arr)) {
                    MYYMyOrderClassModer* classModel = arr[0];
                    if ([[NSString stringWithFormat:@"%@",model.Id] integerValue] == [[NSString stringWithFormat:@"%@",classModel.orderid] integerValue]) {
                        return 120 + arr.count*70;
                        
                    }
                }
            }
            
        }
    }
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYYMyOrterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYYMyOrterTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArr.count) {
        MYYMyOrderModel *model = _dataArr[indexPath.row];
        [cell configModel:model];
        cell.nextBut.tag = indexPath.row;
        [cell.nextBut addTarget:self action:@selector(commentBut:) forControlEvents:UIControlEventTouchUpInside];
//        if (_prolistArr.count>indexPath.row) {
//            cell.prolistArr = _prolistArr[indexPath.row];
//        }
        if (!IsEmptyValue(_prolistArr)) {
            for (NSArray* arr in _prolistArr) {
                if (!IsEmptyValue(arr)) {
                    MYYMyOrderClassModer* classModel = arr[0];
                    if ([[NSString stringWithFormat:@"%@",model.Id] integerValue] == [[NSString stringWithFormat:@"%@",classModel.orderid] integerValue]) {
                        cell.prolistArr = arr;
                        
                    }
                }
            }
        }
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)dataRequest{
    if (_page == 1) {
        [_dataArr removeAllObjects];
    }
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"orderstatus\":\"%@\"}",@"3"],@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"10"};
    [HTNetWorking postWithUrl:@"myorder?action=searchMyOrder" refreshCache:YES params:params success:^(id response) {
        //NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = [dict objectForKey:@"rows"];
        NSLog(@"%@",array);
        if (!IsEmptyValue(array)) {
            for (NSDictionary*dic in array) {
                MYYMyOrderModel *model=[[MYYMyOrderModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [_dataArr addObject:model];
                [self dataOrder:model.Id];
            }
        }
        [_tableView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
}
- (void)dataOrder:(NSString *)strid{
    
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"orderid\":\"%@\"}",strid]};
    if (_page==1) {
        [_prolistArr removeAllObjects];
    }
    [HTNetWorking postWithUrl:@"myorder?action=searchMyOrderDetail" refreshCache:YES params:params success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            for (NSDictionary*dic in array) {
                MYYMyOrderClassModer *model=[[MYYMyOrderClassModer alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [arr addObject:model];
            }
            [_prolistArr addObject:arr];
            
        }
        [_tableView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)commentBut:(UIButton *)but{
    MYYCoderCommentViewController *coder = [[MYYCoderCommentViewController alloc]init];
    MYYMyOrderModel *model = _dataArr[but.tag];
    if (!IsEmptyValue(_prolistArr)) {
        for (NSArray* arr in _prolistArr) {
            if (!IsEmptyValue(arr)) {
                MYYMyOrderClassModer* classModel = arr[0];
                if ([[NSString stringWithFormat:@"%@",model.Id] integerValue] == [[NSString stringWithFormat:@"%@",classModel.orderid] integerValue]) {
                    coder.orderArr = arr;
                    [self.navigationController pushViewController:coder animated:YES];
                }
            }
        }
    }
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
