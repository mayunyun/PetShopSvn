//
//  MYYRegisterSubmitViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/5.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYRegisterSubmitViewController.h"
#import "RegistReferModel.h"
#import "ProvinceModel.h"

@interface MYYRegisterSubmitViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITextField * _accountname;
    UITextField * _custname;
    UITextField* _pwdField;
   // UITextField* _againPwdField;
    UITextField* _phoneField;
    NSMutableArray* _downBtnArray;
    UIView* _popView;
    UIButton* _hide_keHuPopViewBut;
    NSString* _provinceid;
    NSMutableArray* _provinceDataArray;
    NSString* _cityid;
    NSMutableArray* _cityDataArray;
    NSString* _countryid;
    NSMutableArray* _countryDataArray;
    //NSString* _xiaoquid;
    //NSMutableArray* _viliageDataArray;
    NSString* _chargerid;
    NSString* _chargername;
    NSMutableArray* _chargeDataArray;
    NSString* _recommenderid;
    NSString* _recommendername;
    NSString* _typeId;

    
}
@property (nonatomic,strong)UITableView* proTableView;
@end

@implementation MYYRegisterSubmitViewController
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
    _downBtnArray = [NSMutableArray arrayWithCapacity:5];
    _provinceDataArray = [[NSMutableArray alloc]init];
    _cityDataArray = [[NSMutableArray alloc]init];
    _countryDataArray = [[NSMutableArray alloc]init];
    //_viliageDataArray = [[NSMutableArray alloc]init];
    _chargeDataArray = [[NSMutableArray alloc]init];
    self.title = @"注册";
    
    [self creatUI];
}

- (void)creatUI
{
    // 1.设置背景色
    UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    bgimage.image = [UIImage imageNamed:@"loginBG"];
    bgimage.userInteractionEnabled = YES;
    [self.view addSubview:bgimage];
    
    // 2.添加子视图
    UIScrollView* bgSView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    bgSView.contentSize = CGSizeMake(kScreen_Width, 714);
    bgSView.showsVerticalScrollIndicator = NO;
    bgSView.showsHorizontalScrollIndicator = NO;
    [bgimage addSubview:bgSView];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(20, 10, mScreenWidth-40, 530)];
    bgview.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.8];
    bgview.layer.cornerRadius=7;
    [bgSView addSubview:bgview];
    //用户名
    UIImageView *accountnameImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10+17*MYWIDTH, 15, 18)];
    accountnameImage.image = [UIImage imageNamed:@"02020"];
    [bgview addSubview:accountnameImage];
    
    _accountname = [[UITextField alloc]initWithFrame:CGRectMake(50, 10, bgview.width - 70, 54)];
    _accountname.delegate = self;
//    _accountname.secureTextEntry = YES;
    _accountname.placeholder = @"请输入用户名";
    _accountname.font = [UIFont systemFontOfSize:14];
    _accountname.keyboardType = UIKeyboardTypeDefault;//数字英文键盘
    _accountname.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    [bgview addSubview:_accountname];
    UIView* accountnameLine = [[UIView alloc]initWithFrame:CGRectMake(20, _accountname.bottom, bgview.width-40, 1)];
    accountnameLine.backgroundColor = LineColor;
    [bgview addSubview:accountnameLine];
    //姓名
    UIImageView *custnameImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, accountnameLine.bottom+15*MYWIDTH, 15, 18)];
    custnameImage.image = [UIImage imageNamed:@"02020"];
    [bgview addSubview:custnameImage];
    
    _custname = [[UITextField alloc]initWithFrame:CGRectMake(50, accountnameLine.bottom, bgview.width - 70, 54)];
    _custname.delegate = self;
//    _custname.secureTextEntry = YES;
    _custname.placeholder = @"请输入姓名";
    _custname.font = [UIFont systemFontOfSize:14];
    _custname.keyboardType = UIKeyboardTypeDefault;//数字英文键盘
    _custname.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    [bgview addSubview:_custname];
    UIView* custnameLine = [[UIView alloc]initWithFrame:CGRectMake(20, _custname.bottom, bgview.width-40, 1)];
    custnameLine.backgroundColor = LineColor;
    [bgview addSubview:custnameLine];
    //登录密码
    UIImageView *titleimage1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, custnameLine.bottom+17*MYWIDTH, 15, 18)];
    titleimage1.image = [UIImage imageNamed:@"02020"];
    [bgview addSubview:titleimage1];
    
    _pwdField = [[UITextField alloc]initWithFrame:CGRectMake(50, custnameLine.bottom, bgview.width - 70, 54)];
    _pwdField.delegate = self;
    _pwdField.secureTextEntry = YES;
    _pwdField.placeholder = @"请输入登录密码";
    _pwdField.font = [UIFont systemFontOfSize:14];
    _pwdField.keyboardType = UIKeyboardTypeASCIICapable;//数字英文键盘
    _pwdField.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    [bgview addSubview:_pwdField];
    UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(20, _pwdField.bottom, bgview.width-40, 1)];
    line1.backgroundColor = LineColor;
    [bgview addSubview:line1];
    
//    _againPwdField = [[UITextField alloc]initWithFrame:CGRectMake(_pwdField.left, line1.bottom, _pwdField.width, 54)];
//    _againPwdField.delegate = self;
//    _againPwdField.secureTextEntry = YES;
//    _againPwdField.placeholder = @"请输入确认密码";
//    _againPwdField.font = [UIFont systemFontOfSize:14];
//    _againPwdField.keyboardType = UIKeyboardTypeASCIICapable;
//    _againPwdField.enablesReturnKeyAutomatically = YES;
//    [bgview addSubview:_againPwdField];
//    UIView* line1_1 = [[UIView alloc]initWithFrame:CGRectMake(_againPwdField.left, _againPwdField.bottom, line1.width, 1)];
//    line1_1.backgroundColor = LineColor;
//    [bgview addSubview:line1_1];
    
    UIImageView *titleimage2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, line1.bottom+15*MYWIDTH, 15, 18)];
    titleimage2.image = [UIImage imageNamed:@"手机"];
    [bgview addSubview:titleimage2];
    _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(_pwdField.left, line1.bottom, _pwdField.width, _pwdField.height)];
    _phoneField.delegate = self;
    _phoneField.placeholder = @"请输入推荐人手机号（可选）";
    _phoneField.font = [UIFont systemFontOfSize:14];
    _phoneField.keyboardType = UIKeyboardTypeASCIICapable;
    [bgview addSubview:_phoneField];
    UIView* line2 = [[UIView alloc]initWithFrame:CGRectMake(line1.left, _phoneField.bottom, line1.width, 1)];
    line2.backgroundColor = LineColor;
    [bgview addSubview:line2];
//    NSArray* placeholderArray  = @[@"请选择所在省",@"请选择所在市",@"请选择所在县",@"请选择所在小区",@"请选择负责人"];
//    NSArray* leftLabelArray= @[@"省(可选)",@"市(可选)",@"县(可选)",@"小区(可选)",@"负责人(可选)"];
    NSArray* placeholderArray  = @[@"请选择所在省",@"请选择所在市",@"请选择所在县",@"请选择负责人",@"请选择客户类型"];
    NSArray* leftLabelArray= @[@"省(可选)",@"市(可选)",@"县(可选)",@"负责人(可选)",@"类型(必选)"];
    for (int i = 0; i < leftLabelArray.count; i++) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, line2.bottom+i*55, 100*MYWIDTH, _phoneField.height)];
        label.text = leftLabelArray[i];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0x666666);
        [bgview addSubview:label];
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:placeholderArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:GrayTitleColor forState:UIControlStateNormal];
        btn.frame = CGRectMake(label.right+8, label.top, bgview.width - 30 - label.width, _phoneField.height);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn addTarget:self action:@selector(downBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgview addSubview:btn];
        [_downBtnArray addObject:btn];
        if (i<leftLabelArray.count-1) {
            UIView* line = [[UIView alloc]initWithFrame:CGRectMake(line1.left, _phoneField.bottom+55*i+54, line1.width, 1)];
            line.backgroundColor = LineColor;
            [bgview addSubview:line];
        }
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(bgview.right - 60, _phoneField.bottom+(_phoneField.height - 5)*0.5+55*i, 10, 5)];
        imageView.image = [UIImage imageNamed:@"downBtn"];
        [bgview addSubview:imageView];
    }
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, bgview.bottom+2, mScreenWidth-40, 40)];
    label.text = @"办事处购买处单位为最大单位(件/箱)。代理购买单位为中间单位(盒/瓶)。消费者购买单位可选择。";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines= 2;
    [bgSView addSubview:label];
    
    UIButton* registBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    registBtn.frame = CGRectMake(20,label.bottom+45 , mScreenWidth-40, 45);
    registBtn.backgroundColor = NavBarItemColor;
    [registBtn setTitle:@"提交注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registBtn.layer.masksToBounds = YES;
    registBtn.layer.cornerRadius = 5;
    [bgSView addSubview:registBtn];
    [registBtn addTarget:self action:@selector(registBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downBtnClick:(UIButton*)sender{
    [_chargeDataArray removeAllObjects];
    if (sender == _downBtnArray[0]) {
        [self popViewUI:0];
        [_provinceDataArray removeAllObjects];
        _provinceid = @"";
        [_cityDataArray removeAllObjects];
        _cityid = @"";
        [_countryDataArray removeAllObjects];
        _countryid = @"";
//        [_viliageDataArray removeAllObjects];
//        _xiaoquid = @"";
//       _chargerid = @"";
        for (int i = 0 ; i < _downBtnArray.count-2 ;i++) {
            UIButton* btn = _downBtnArray[i];
            [btn setTitle:@" " forState:UIControlStateNormal];
        }
        [self provinceDataRequest];
    }else if (sender == _downBtnArray[1]){
        [self popViewUI:1];
        [_cityDataArray removeAllObjects];
        _cityid = @"";
        [_countryDataArray removeAllObjects];
        _countryid = @"";
//        [_viliageDataArray removeAllObjects];
//        _xiaoquid = @"";
//        [_chargeDataArray removeAllObjects];
//        _chargerid = @"";
        for (int i = 1 ; i < _downBtnArray.count-2 ;i++) {
            UIButton* btn = _downBtnArray[i];
            [btn setTitle:@" " forState:UIControlStateNormal];
        }
        [self cityDataRequest];
    }else if (sender == _downBtnArray[2]){
        [self popViewUI:2];
        [_countryDataArray removeAllObjects];
        _countryid = @"";
//        [_viliageDataArray removeAllObjects];
//        _xiaoquid = @"";
//        [_chargeDataArray removeAllObjects];
//        _chargerid = @"";
        for (int i = 2 ; i < _downBtnArray.count-2 ;i++) {
            UIButton* btn = _downBtnArray[i];
            [btn setTitle:@" " forState:UIControlStateNormal];
        }
        [self countyDataRequest];
    }
//    else if (sender == _downBtnArray[3]){
//        [self popViewUI:3];
//        [_viliageDataArray removeAllObjects];
//        _xiaoquid = @"";
//        [_chargeDataArray removeAllObjects];
//        _chargerid = @"";
//        for (int i = 3 ; i < _downBtnArray.count ;i++) {
//            UIButton* btn = _downBtnArray[i];
//            [btn setTitle:@" " forState:UIControlStateNormal];
//        }
//        [self villageDataRequest];
//   }
    else if (sender == _downBtnArray[3]){
        [self popViewUI:3];
        [_chargeDataArray removeAllObjects];
        _chargerid = @"";
        for (int i = 3 ; i < _downBtnArray.count-2 ;i++) {
            UIButton* btn = _downBtnArray[i];
            [btn setTitle:@" " forState:UIControlStateNormal];
        }
        [self personInChargeRequest];
    }
    else if (sender == _downBtnArray[4]){
        [self popViewUI:4];
        _typeId = @"";
        for (int i = 4 ; i < _downBtnArray.count-1 ;i++) {
            UIButton* btn = _downBtnArray[i];
            [btn setTitle:@" " forState:UIControlStateNormal];
        }
        [self.proTableView reloadData];
    }
}

- (void)registBtnClick:(UIButton*)sender{
    //self.phone,self.phone,self.phone,self.phone,_pwdField.text必填
    if (!IsEmptyValue(_pwdField.text)) {
        //if ([_pwdField.text isEqualToString:_againPwdField.text]) {
        if (IsEmptyValue(_accountname.text)) {
            [self customAlert:@"请填写用户名"];
            return;
        }
        if (IsEmptyValue(_custname.text)) {
            [self customAlert:@"请填写姓名"];
            return;
        }
        if (IsEmptyValue(_typeId)) {
            [self customAlert:@"请选择客户类型"];
            return;
        }
            if ([Command isPassword:_pwdField.text]) {
                if (!IsEmptyValue(self.phone)) {
                    if (!IsEmptyValue(_phoneField.text)) {
                        
                        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",_phoneField.text]};
                        [HTNetWorking postWithUrl:@"register?action=isExitsPhone" refreshCache:YES params:params success:^(id response) {
                            NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                            NSLog(@"推荐人%@",str);
                            if ([str rangeOfString:@"true"].location!=NSNotFound) {
                                [Command customAlert:@"推荐人不存在"];
                                
                            }else{
                                [self registDataForLoveDogRequest];
                                
                            }
                            
                        } fail:^(NSError *error) {
                            
                        }];
                    }else{
                         [self registDataForLoveDogRequest];
                    }
                }
            }else{
                [self customAlert:@"密码大于6位"];
            }
//        }else{
//            [self customAlert:@"两次密码输入不一致"];
//        }
    }else{
        [self customAlert:@"密码为空"];
    }
    
}

- (void)popViewUI:(NSInteger)tag{
    _popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreen_Width, kScreen_Height)];
    //        self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    _popView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [_popView addSubview:_hide_keHuPopViewBut];
    
    if (self.proTableView == nil) {
        self.proTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 80,kScreen_Width-20, kScreen_Height-174) style:UITableViewStylePlain];
        self.proTableView.backgroundColor = [UIColor whiteColor];
    }
    self.proTableView.dataSource = self;
    self.proTableView.delegate = self;
    self.proTableView.tag = 100+tag;
    self.proTableView.rowHeight = 80;
    [_popView addSubview:self.proTableView];
    //        [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:_popView];

}


- (void)closePop{
    [_popView removeFromSuperview];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 100:{
            return _provinceDataArray.count;
        }break;
        case 101:{
            return _cityDataArray.count;
        }break;
        case 102:{
            return _countryDataArray.count;
        }break;
//        case 103:{
//            return _viliageDataArray.count;
//        }break;
        case 103:{
            return _chargeDataArray.count;
        }break;
        case 104:{
            return 3;
        }break;
        default:return 0;
            break;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    switch (tableView.tag) {
        case 100:{
            if (!IsEmptyValue(_provinceDataArray)) {
                ProvinceModel* model = _provinceDataArray[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",model.areaname];
            }else{
                cell.textLabel.text = @"";
            }
        }break;
        case 101:{
            if (!IsEmptyValue(_cityDataArray)) {
                CityModel* model = _cityDataArray[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",model.areaname];
            }else{
                cell.textLabel.text = @"";
            }
        }break;
        case 102:{
            if (!IsEmptyValue(_countryDataArray)) {
                ContryModel* model = _countryDataArray[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",model.areaname];
            }else{
                cell.textLabel.text = @"";
            }
        }break;
//        case 103:{
//            if (!IsEmptyValue(_viliageDataArray)) {
//                ViligeModel* model = _viliageDataArray[indexPath.row];
//                cell.textLabel.text = [NSString stringWithFormat:@"%@",model.areaname];
//            }else{
//                cell.textLabel.text = @"";
//            }
//        }break;
        case 103:{
            if (!IsEmptyValue(_chargeDataArray)) {
                ChargeModel* model = _chargeDataArray[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",model.accountname];
            }else{
                cell.textLabel.text = @"";
            }
        }break;
        case 104:{
            NSArray *arr = @[@"办事处",@"代理",@"消费者"];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",arr[indexPath.row]];
        }break;
        default:break;
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 100:{
            if (!IsEmptyValue(_provinceDataArray)) {
                ProvinceModel* model = _provinceDataArray[indexPath.row];
                _provinceid = [NSString stringWithFormat:@"%@",model.areaid];
                UIButton* btn = _downBtnArray[tableView.tag-100];
                [btn setTitle:[NSString stringWithFormat:@"%@",model.areaname] forState:UIControlStateNormal];
                [_popView removeFromSuperview];
            }
        }break;
        case 101:{
            if (!IsEmptyValue(_cityDataArray)) {
                CityModel* model = _cityDataArray[indexPath.row];
                _cityid = [NSString stringWithFormat:@"%@",model.areaid];
                UIButton* btn = _downBtnArray[tableView.tag-100];
                [btn setTitle:[NSString stringWithFormat:@"%@",model.areaname] forState:UIControlStateNormal];
                [_popView removeFromSuperview];
            }
        }break;
        case 102:{
            if (!IsEmptyValue(_countryDataArray)) {
                ContryModel* model = _countryDataArray[indexPath.row];
                _countryid = [NSString stringWithFormat:@"%@",model.areaid];
                UIButton* btn = _downBtnArray[tableView.tag-100];
                [btn setTitle:[NSString stringWithFormat:@"%@",model.areaname] forState:UIControlStateNormal];
                [_popView removeFromSuperview];
            }
        }break;
//        case 103:{
//            if (!IsEmptyValue(_viliageDataArray)) {
//                ViligeModel* model = _viliageDataArray[indexPath.row];
//                _xiaoquid = [NSString stringWithFormat:@"%@",model.areaid];
//                UIButton* btn = _downBtnArray[tableView.tag-100];
//                [btn setTitle:[NSString stringWithFormat:@"%@",model.areaname] forState:UIControlStateNormal];
//                [_popView removeFromSuperview];
//            }
//        }break;
        case 103:{
            if (!IsEmptyValue(_chargeDataArray)) {
                ChargeModel* model = _chargeDataArray[indexPath.row];
                _chargerid = [NSString stringWithFormat:@"%@",model.accountid];
                _chargername = [NSString stringWithFormat:@"%@",model.accountname];
                UIButton* btn = _downBtnArray[tableView.tag-100];
                [btn setTitle:[NSString stringWithFormat:@"%@",model.accountname] forState:UIControlStateNormal];
                [_popView removeFromSuperview];
            }
        }break;
        case 104:{
            NSArray *arr = @[@"办事处",@"代理",@"消费者"];
            _typeId = [NSString stringWithFormat:@"%zd",indexPath.row];
            UIButton* btn = _downBtnArray[tableView.tag-100];
            [btn setTitle:[NSString stringWithFormat:@"%@",arr[indexPath.row]] forState:UIControlStateNormal];
            [_popView removeFromSuperview];
            
        }break;
        default:break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _pwdField) {
        if (![Command isPassword:_pwdField.text]) {
            [Command customAlert:@"密码长度6-20位"];
        }
//    }else if (textField == _againPwdField){
//        if (![Command isPassword:_againPwdField.text]) {
//            [Command customAlert:@"密码长度6-20位"];
//        }
//        if (![_pwdField.text isEqualToString:_againPwdField.text]) {
//            [Command customAlert:@"两次输入密码不一致"];
//        }
    }else if (textField == _phoneField){
        if (!IsEmptyValue(_phoneField.text)) {
            [self referrerDataRequest];
        }
    }
}

- (void)referrerDataRequest{
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",_phoneField.text]};
    [HTNetWorking postWithUrl:@"register?action=isExitsPhone" refreshCache:YES  params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"推荐人%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            [Command customAlert:@"推荐人不存在"];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            if (!IsEmptyValue(array)) {
                NSDictionary* dict = array[0];
                RegistReferModel* model = [[RegistReferModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                _recommenderid = [NSString stringWithFormat:@"%@",model.Id];
                _recommendername = [NSString stringWithFormat:@"%@",model.name];
            }
        }
        
    } fail:^(NSError *error) {
        
    }];
}


- (void)provinceDataRequest{
    [HTNetWorking postWithUrl:@"register?action=loadProvince" refreshCache:YES params:nil success:^(id response) {
//        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
//        NSLog(@"县数据%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            [_provinceDataArray removeAllObjects];
            for (NSDictionary* dict in array) {
                ProvinceModel* model = [[ProvinceModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_provinceDataArray addObject:model];
            }
        }
        [self.proTableView reloadData];

    } fail:^(NSError *error) {
        
    }];
}

- (void)cityDataRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"provinceid\":\"%@\"}",_provinceid]};
    [HTNetWorking postWithUrl:@"register?action=loadCity" refreshCache:YES params:params success:^(id response) {
//        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
//        NSLog(@"市数据%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            [_cityDataArray removeAllObjects];
            for (NSDictionary* dict in array) {
                CityModel* model = [[CityModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_cityDataArray addObject:model];
            }
        }
        [self.proTableView reloadData];

    } fail:^(NSError *error) {
        
    }];
}

- (void)countyDataRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"cityid\":\"%@\"}",_cityid]};
    [HTNetWorking postWithUrl:@"register?action=loadCountry" refreshCache:YES params:params success:^(id response) {
//        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
//        NSLog(@"县数据%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            [_countryDataArray removeAllObjects];
            for (NSDictionary* dict in array) {
                ContryModel* model = [[ContryModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_countryDataArray addObject:model];
            }
        }
        [self.proTableView reloadData];

    } fail:^(NSError *error) {
        
    }];
}
//- (void)villageDataRequest{
//    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"countryid\":\"%@\"}",_countryid]};
//    [HTNetWorking postWithUrl:@"register?action=loadXiaoqu" refreshCache:YES params:params success:^(id response) {
//        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
//        NSLog(@"小区数据%@",str);
//        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
//        if (!IsEmptyValue(array)) {
//            [_viliageDataArray removeAllObjects];
//            for (NSDictionary* dict in array) {
//                ViligeModel* model = [[ViligeModel alloc]init];
//                [model setValuesForKeysWithDictionary:dict];
//                [_viliageDataArray addObject:model];
//            }
//        }
//        [self.proTableView reloadData];
//
//    } fail:^(NSError *error) {
//
//    }];
//}

- (void)personInChargeRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"xiaoquid\":\"%@\"}",@""]};
    [HTNetWorking postWithUrl:@"register?action=loadChargeid" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"负责人数据%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            [_chargeDataArray removeAllObjects];
            for (NSDictionary* dict in array) {
                ChargeModel* model = [[ChargeModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_chargeDataArray addObject:model];
            }
        }
        [self.proTableView reloadData];

    } fail:^(NSError *error) {
        
    }];
}
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
-(void)registDataForLoveDogRequest{
    _provinceid = [Command convertNull:_provinceid];
    _cityid = [Command convertNull:_cityid];
    _countryid = [Command convertNull:_countryid];
    _chargerid = [Command convertNull:_chargerid];

    //_xiaoquid = [Command convertNull:_xiaoquid];
    if ([_provinceid isEqualToString:@""]) {
        _provinceid = @"0";
    }
    if ([_cityid isEqualToString:@""]) {
        _cityid = @"0";
    }
    if ([_countryid isEqualToString:@""]) {
        _countryid = @"0";
    }
    if (![_chargerid isEqualToString:@""]) {
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"chargeid\":\"%@\"}",_chargerid]};
        NSLog(@"%@",params);
        [HTNetWorking postWithUrl:@"register?action=loadChargeidJX" refreshCache:YES showHUD:@"" params:params success:^(id response) {
            //            NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
            NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            if (!IsEmptyValue(array)) {
                NSLog(@"%@",array);
                NSString * accountid = array[0][@"accountid"];
                NSString * accountname = array[0][@"accountname"];
                NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"receivername\":\"%@\",\"name\":\"%@\",\"custphone\":\"%@\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"accountid\":\"%@\",\"accountname\":\"%@\"}",_custname.text,_accountname.text,self.phone,[NSString stringWithFormat:@"%@",_provinceid],[NSString stringWithFormat:@"%@",_cityid],[NSString stringWithFormat:@"%@",_countryid],accountid,accountname]};
                NSLog(@"注册爱宠的接口参数%@",params);
                NSString * stringUrl = [NSString stringWithFormat:@"%@withUnLog/location?action=addacCustomer",jingXinYaoYe_Code_YZY];
                //http://118.190.47.231/jx
                [HTNetWorking postWithUrl:stringUrl refreshCache:YES params:params success:^(id response) {
                    NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                    if ([self isPureInt:str]) {
                        [self registDataRequest:str];
                    }else{
                        [self customAlert:str];
                    }
                } fail:^(NSError *error) {
                    
                }];
            }
        } fail:^(NSError *error) {
            
        }];
    }else{
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"receivername\":\"%@\",\"name\":\"%@\",\"custphone\":\"%@\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"accountid\":\"%@\",\"accountname\":\"%@\"}",_custname.text,_accountname.text,self.phone,[NSString stringWithFormat:@"%@",_provinceid],[NSString stringWithFormat:@"%@",_cityid],[NSString stringWithFormat:@"%@",_countryid],@"",@""]};
        NSLog(@"注册爱宠的接口参数%@",params);
        NSString * stringUrl = [NSString stringWithFormat:@"%@withUnLog/location?action=addacCustomer",jingXinYaoYe_Code_YZY];
        //http://118.190.47.231/jx
        [HTNetWorking postWithUrl:stringUrl refreshCache:YES params:params success:^(id response) {
            NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
            if ([self isPureInt:str]) {
                [self registDataRequest:str];
            }else{
                [self customAlert:str];
            }
        } fail:^(NSError *error) {
            
        }];
    }
    
}
- (void)registDataRequest:(NSString *)jxid{
    /*
     （custname，phone，name，accountname）此值都为电话号码，password（必填），isvalid="1"，score="0"，balance="0"，provinceid，cityid，areaid
     ，villageid，chargerid（负责人id）chargername（负责人名称），recommenderid（推荐人id），recommendername（推荐人名称）
     */
    _chargerid = [Command convertNull:_chargerid];
    _provinceid = [Command convertNull:_provinceid];
    _cityid = [Command convertNull:_cityid];
    _countryid = [Command convertNull:_countryid];
    //_xiaoquid = [Command convertNull:_xiaoquid];
    _chargername = [Command convertNull:_chargername];
    _recommenderid = [Command convertNull:_recommenderid];
    _recommendername = [Command convertNull:_recommendername];
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"custname\":\"%@\",\"phone\":\"%@\",\"name\":\"%@\",\"accountname\":\"%@\",\"password\":\"%@\",\"isvalid\":\"1\",\"score\":\"0\",\"balance\":\"0\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"villageid\":\"%@\",\"chargerid\":\"%@\",\"chargername\":\"%@\",\"recommenderid\":\"%@\",\"jxid\":\"%@\",\"recommendername\":\"%@\",\"custtypeid\":\"%@\"}",_custname.text,self.phone,self.phone,_accountname.text,_pwdField.text,_provinceid,_cityid,_countryid,@"",_chargerid,_chargername,_recommenderid,jxid,_recommendername,_typeId]};
    NSLog(@"注册参数%@",params);
    [HTNetWorking postWithUrl:@"register?action=addCoustomer" refreshCache:YES showHUD:@"" params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",self.phone] forKey:USERPHONE];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",_pwdField.text] forKey:PASSWORD];
            
            NSArray* array = self.navigationController.viewControllers;
            UIViewController *viewCtl = self.navigationController.viewControllers[array.count - 1 - 2];
            [self.navigationController popToViewController:viewCtl animated:YES];
        }else{
            [self customAlert:@"注册失败"];
        }
    } fail:^(NSError *error) {
        
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}


@end
