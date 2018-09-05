//
//  MYYHomeViewController.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/3/24.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "NewHomeViewController.h"
#import "SDCycleScrollView.h"//banner
#import "HomeIconsCollectionView.h"
#import "HomeHeaderTableViewCell.h"
#import "HomeYouLikeCollectionView.h"
#import "HomeLineCollectionView.h"
#import "MYYTypeDetailsViewController.h"
#import "MYYDetailsAndCommentViewController.h"
#import "HXSearchBar.h"
#import "HomeBannerModel.h"
#import "HomeTypeModel.h"
#import "HomeProNewModel.h"
#import "HomeFavorableModel.h"
#import "CommandModel.h"
#import "MYYHomeNoticeViewController.h"
#import "MYYMineRechargeViewController.h"
#import "MYYTypeViewController.h"
#import "NewTypeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeController.h"
#import "MYYLoginViewController.h"
#import "MYYSaoMiaoLoginViewController.h"
#import "HomeYouLikeCollectionViewCell.h"
#import "HomeFavorableModel.h"
#import "Reachability.h"

#define KScreenSize [UIScreen mainScreen].bounds.size
#define IsIphone6P KScreenSize.width==414
#define IsIphone6 KScreenSize.width==375
#define IsIphone5S KScreenSize.height==568



#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define Start_X          5.0f      // 第一个按钮的X坐标
//#define Start_Y          90.0f     // 第一个按钮的Y坐标
#define Width_Space      2.0f      // 2个按钮之间的横间距
#define Height_Space     5.0f     // 竖间距
#define Button_Height   70*MYWIDTH    // 高
#define Button_Width    (mScreenWidth-10-2*2)/3    // 宽
@interface NewHomeViewController ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>
{
    NSString *_versionUrl;
    MBProgressHUD* _hud;
    HXSearchBar *_search;//搜索
    NSInteger _page;
    NSMutableArray* _bannerDataArray;
    NSMutableArray* _typeDataArray;
    NSMutableArray* _favorableDataArray;
    NSMutableArray* _activeDataArray;
    NSMutableArray* _hotProDataArray;
    NSMutableArray* _youLikeDataArray;
    NSMutableArray* _fomalProDataArray;
    NSMutableArray* _newProDataArray;
    NSMutableArray* _noticeDataArray;
}
@property(nonatomic,strong)UICollectionView *collection;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView2;
@property (nonatomic,strong)HomeIconsCollectionView* iconsCollView;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView4;
@end

@implementation NewHomeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    _page = 1;
    [self dataRequest];
}
//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;// 推荐使用
    //通知中心注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

    _bannerDataArray = [[NSMutableArray alloc]init];
    _typeDataArray = [[NSMutableArray alloc]initWithCapacity:5];
    _favorableDataArray = [[NSMutableArray alloc]init];
    _activeDataArray = [[NSMutableArray alloc]init];
    _hotProDataArray = [[NSMutableArray alloc]init];
    _youLikeDataArray = [[NSMutableArray alloc]init];
    _fomalProDataArray = [[NSMutableArray alloc]init];
    _newProDataArray = [[NSMutableArray alloc]init];
    _noticeDataArray = [[NSMutableArray alloc]init];
    _page = 1;

    //    进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //    _hud.labelText = @"网络不给力，正在加载中...";
    [_hud showAnimated:YES];
    //    [self creatNavUI];
    [self searchview];
    [self creatUI];
    [self dataRequest];
    [self versionRequest];
    
}
- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status==ReachableViaWiFi||status==ReachableViaWWAN) {
        _page = 1;
        [self dataRequest];
        
    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)creatUI
{
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
    layout.headerReferenceSize =CGSizeMake(mScreenWidth, mScreenHeight-64-49);
    layout.minimumInteritemSpacing = 0; //列间距
    layout.minimumLineSpacing = 0;//行间距
    _collection =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight-64-49) collectionViewLayout:layout];
    if (statusbarHeight>20) {
        layout.headerReferenceSize =CGSizeMake(mScreenWidth, mScreenHeight-88-49-34);
        _collection.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight-88-49-34);
    }
    _collection.delegate =self;
    _collection.dataSource =self;
    _collection.backgroundColor = UIColorFromRGB(0xF0F0F0);
    [self.view addSubview:_collection];
    
    [_collection registerNib:[UINib nibWithNibName:@"HomeYouLikeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeYouLikeCollectionViewCellID"];
    
    // 注册头视图
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerKing"];
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerheader1"];
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerheader2"];
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerheader3"];
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerheader4"];

    
    //     下拉刷新
    _collection.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self dataRequest];
        // 结束刷新
        [_collection.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _collection.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _collection.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [self formalProDataRequest];
        [_collection.mj_footer endRefreshing];
        
    }];
    //_collection.mj_footer.hidden = YES;
}

- (UISearchBar *)searchview{
    if (_search == nil) {
        UIButton* zbarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        zbarBtn.frame = CGRectMake(0, 0, 30, 30);
        [zbarBtn setImage:[UIImage imageNamed:@"homezbar"] forState:UIControlStateNormal];
        zbarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [zbarBtn addTarget:self action:@selector(leftNavBarClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:zbarBtn];
        self.navigationItem.leftBarButtonItem = left;
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth-60, 30)];
        //加上 搜索栏
        _search = [[HXSearchBar alloc] initWithFrame:titleView.bounds];
        _search.backgroundColor = [UIColor clearColor];
        _search.delegate = self;
        //输入框提示
        _search.placeholder = @"搜你想要的";
        //光标颜色
        _search.cursorColor = [UIColor blackColor];
        //TextField
        _search.searchBarTextField.layer.cornerRadius = 15;
        _search.searchBarTextField.layer.masksToBounds = YES;
        //        _search.searchBarTextField.layer.borderColor = [UIColor whiteColor].CGColor;
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
    NSSLog(@">>><<<%@",params);
    [HTNetWorking postWithUrl:@"mallLogin?action=saomaMallLogin" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSSLog(@">>>%@",str);
        
        if ([str rangeOfString:@"false"].location!=NSNotFound){
            [Command customAlert:@"提示用户不存在"];
        }else{
            MYYSaoMiaoLoginViewController *login = [[MYYSaoMiaoLoginViewController alloc]init];
            login.hidesBottomBarWhenPushed = YES;
            login.uuid = uuid;
            [self.navigationController pushViewController:login animated:YES];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HomeSelarCellID = @"HomeYouLikeCollectionViewCellID";
    //在这里注册自定义的XIBcell 否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"HomeYouLikeCollectionViewCell" bundle: [NSBundle mainBundle]];
    [_collection registerNib:nib forCellWithReuseIdentifier:HomeSelarCellID];
    
    HomeYouLikeCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeSelarCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [self framAdd:cell];
    
    HomeFavorableModel* model;
    if (indexPath.section==1) {
        if (_favorableDataArray.count!=0) {
            model = _favorableDataArray[indexPath.row];
        }
    }else if (indexPath.section==2){
        if (_hotProDataArray.count!=0) {
            model = _hotProDataArray[indexPath.row];

        }
    }else if (indexPath.section==3){
        if (_youLikeDataArray.count!=0) {
            model = _youLikeDataArray[indexPath.row];
        }
    }else if (indexPath.section==4){
        if (_fomalProDataArray.count!=0) {
            model = _fomalProDataArray[indexPath.row];
        }
    }
    model.proname = [self convertNull:model.proname];
    model.specification = [self convertNull:model.specification];

    model.minsaleprice = [self convertNull:model.minsaleprice];
    model.secondunitname = [self convertNull:model.secondunitname];
    
    cell.titleLabel.text = nil;
    cell.imgView.image = nil;
    cell.priceLabel.text = nil;
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.proname];
    cell.guigeLab.text = [NSString stringWithFormat:@"%@",model.specification];
    [cell setstockcount:model.jxproid maintosecond:model.maintosecond];
    
    if (!IsEmptyValue(model.saleprice)) {
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@/%@",model.minsaleprice,model.secondunitname];
    }else{
        cell.priceLabel.text = [NSString stringWithFormat:@"￥0/%@",model.secondunitname];
    }
    NSString* url = HTImgUrl;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",url,@"productimages",model.autoname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
    //        cell.titleLabel.text = @"笨鸡蛋";
    //        cell.imgView.image = [UIImage imageNamed:@"00"];
    //        cell.priceLabel.text = @"￥ 10.00";
    [cell setTransVaule:^(BOOL isClick) {
        [Command isloginRequest:^(bool islogin) {
            if (islogin) {
                if (indexPath.section == 3) {
                    [self addYouLikeCarRequest:model];
                }else{
                    [self addCarRequest:model];
                }
            }else{
                [self showAlertViewWithTitle:@"亲，加入购物车需要您登录！" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] buttonClick:^(UIAlertController *alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        
                    }else if (buttonIndex == 1){
                        MYYLoginViewController* vc = [[MYYLoginViewController alloc]init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }];
            }
        }];
    }];

    return cell;
    
}


//格式话小数 四舍五入类型
- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

- (void)framAdd:(id)sender
{
    CALayer *layer = [sender layer];
    layer.borderColor = SecondBackGorundColor.CGColor;
    layer.borderWidth = .5f;
    
}

-(NSString*)convertNull:(id)object{
    
    // 转换空串
    
    if ([object isEqual:[NSNull null]]) {
        return @"";
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else if (object==nil){
        return @"";
    }
    return object;
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //400*kScreen_Width/714
    return CGSizeMake(kScreen_Width/2, (kScreen_Width/2-8)*4/3);

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section==0) {
        if (IsIphone5S) {
            return CGSizeMake(mScreenWidth,kScreen_Width*556/720+200+50);
        }else if (IsIphone6){
            return CGSizeMake(mScreenWidth,kScreen_Width*556/720+240+50);
        }else if (IsIphone6P){
            return CGSizeMake(mScreenWidth,kScreen_Width*556/720+260+50);
        }
    }
    return CGSizeMake(mScreenWidth,40+200);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else if (section==1){
        if (_favorableDataArray.count<4) {
            return _favorableDataArray.count;
        }
    }else if (section==2){
        if (_hotProDataArray.count<4) {
            return _hotProDataArray.count;
        }
    }else if (section==3){
        if (_youLikeDataArray.count<4) {
            return _youLikeDataArray.count;
        }
    }else if (section==4){
        return _fomalProDataArray.count;
    }
    return 4;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
#pragma mark ----- 重用的问题
    
    if (indexPath.section==0) {
    
        UICollectionReusableView *header;
        if (header==nil) {
            header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerKing" forIndexPath:indexPath];
        }
        header.backgroundColor = [UIColor whiteColor];
        for (UIView *view in header.subviews) { [view removeFromSuperview]; }

        UIView *headview;
        if (headview==nil) {
            if (IsIphone5S) {
                headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth,kScreen_Width*556/720+200+50)];
            }else if (IsIphone6){
                headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth,kScreen_Width*556/720+240+50)];
            }else if (IsIphone6P){
               headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth,kScreen_Width*556/720+260+50)];
            }
            
            [header addSubview:headview];
        }
        //banner
        // 情景二：采用网络图片实现
        NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]init];
        for (HomeBannerModel* model in _bannerDataArray) {
            NSString *serverAddress = HTImgUrl;
            if (![model.phoneautoname isEqualToString:@""]) {
                
                NSString* imageurl = [NSString stringWithFormat:@"%@%@%@",serverAddress,model.folder,model.phoneautoname];
                [imagesURLStrings addObject:imageurl];
            }
            
        }
        // 网络加载 --- 创建带标题的图片轮播器
        self.cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width*556/720) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        self.cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        self.cycleScrollView2.currentPageDotColor = NavBarItemColor; // 自定义分页控件小圆标颜色
        [headview addSubview:self.cycleScrollView2];
        self.cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
        
        //icon
        
//        _iconsCollView = [[HomeIconsCollectionView alloc]initWithFrame:CGRectMake(0, _cycleScrollView2.bottom, mScreenWidth, 210)];
//        //_iconsCollView.contentSize = CGSizeMake(mScreenWidth, 210);
//        _iconsCollView.delegate = self;
//        _iconsCollView.userInteractionEnabled = YES;
//        if (_typeDataArray.count != 0) {
//            _iconsCollView.dataArr = _typeDataArray;
//            [_iconsCollView reloadData];
//        }
//        [header addSubview:_iconsCollView];
//        _iconsCollView.backgroundColor = [UIColor clearColor];
        for (int i = 0; i<[_typeDataArray count]; i++) {
            NSInteger index = i % 3;
            NSInteger page = i / 3;
            HomeTypeModel* model = _typeDataArray[i];
            NSString* url = HTImgUrl;
            NSString* imageUrl = [NSString stringWithFormat:@"%@%@%@",url,model.folder,model.autoname];
            UIImageView *butimage = [[UIImageView alloc]initWithFrame:CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space+30)+_cycleScrollView2.bottom+10, Button_Width, Button_Height)];
            [butimage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
            butimage.tag = 10+i;
            butimage.userInteractionEnabled = YES;
            [butimage setContentScaleFactor:[[UIScreen mainScreen] scale]];
            butimage.contentMode =  UIViewContentModeScaleAspectFit;
            butimage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            butimage.clipsToBounds  = YES;
            [headview addSubview:butimage];

            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap:)];
            [butimage addGestureRecognizer:tapRecognizer];
            
            UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(index * (Button_Width + Width_Space) + Start_X, butimage.bottom, Button_Width, 30)];
            but.tag = i;
            [but setTitle:model.name forState:UIControlStateNormal];
            but.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
            but.titleLabel.font = [UIFont systemFontOfSize:14];
            [but setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [but addTarget:self action:@selector(Classbut:) forControlEvents:UIControlEventTouchUpInside];
            [headview addSubview:but];
        }
        
//        CGFloat appvieww=60*MYWIDTH;
//        CGFloat appviewh=60*MYWIDTH;
//        int totalColumns = 3;//列
//        //    间隙
//        CGFloat margin =(self.view.frame.size.width - totalColumns * appvieww) / (totalColumns + 1);
//
//        for (int i = 0; i<[_typeDataArray count]; i++) {
//            HomeTypeModel* model = _typeDataArray[i];
//
//            NSString* url = HTImgUrl;
//            NSString* imageUrl = [NSString stringWithFormat:@"%@%@%@",url,model.folder,model.autoname];
//
//            // 计算行号  和   列号
//            int row = i / totalColumns;
//            int col = i % totalColumns;
//            //根据行号和列号来确定 子控件的坐标
//            CGFloat cellX = margin + col * (appvieww + margin);
//            CGFloat cellY = _cycleScrollView2.bottom + 10 + row * (appviewh + margin);
//
//            UIImageView *butimage = [[UIImageView alloc]initWithFrame:CGRectMake(cellX, cellY, appvieww, appviewh)];
//            [butimage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
//            butimage.tag = 10+i;
//            butimage.userInteractionEnabled = YES;
//            [headview addSubview:butimage];
//
//            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap:)];
//            [butimage addGestureRecognizer:tapRecognizer];
//
//            UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(cellX-appvieww/2, butimage.bottom, appvieww*2, 30)];
//            but.tag = i;
//            [but setTitle:model.name forState:UIControlStateNormal];
//            but.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
//            but.titleLabel.font = [UIFont systemFontOfSize:14];
//            [but setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
//            [but addTarget:self action:@selector(Classbut:) forControlEvents:UIControlEventTouchUpInside];
//            [headview addSubview:but];
//
//        }
        UIView* line1;
        if (IsIphone5S) {
            line1 = [[UIView alloc]initWithFrame:CGRectMake(0, _cycleScrollView2.bottom+200, kScreen_Width, 0.5)];
        }else if (IsIphone6){
            line1 = [[UIView alloc]initWithFrame:CGRectMake(0, _cycleScrollView2.bottom+240, kScreen_Width, 0.5)];
        }else if (IsIphone6P){
            line1 = [[UIView alloc]initWithFrame:CGRectMake(0, _cycleScrollView2.bottom+260, kScreen_Width, 0.5)];
        }
        line1.backgroundColor = LineColor;
        [headview addSubview:line1];
        CALayer *layer1 = [line1 layer];
        layer1.borderColor = SecondBackGorundColor.CGColor;
        layer1.borderWidth = .5f;
        //公告
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, line1.bottom, 50, 40)];
        label.text = @"公告：";
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:15];
        [headview addSubview:label];
        // 情景三：图片配文字
        //            NSArray *titles = @[@"新建交流QQ群：185534916 ",
        //                                @"感谢您的支持，如果下载的",
        //                                @"如果代码在使用过程中出现问题",
        //                                @"您可以发邮件到gsdios@126.com"
        //                                ];
        NSMutableArray* titles = [[NSMutableArray alloc]init];
        if (!IsEmptyValue(_noticeDataArray)) {
            for (CommandModel* model in _noticeDataArray) {
                [titles addObject:model.name];
            }
        }
        // 网络加载 --- 创建只上下滚动展示文字的轮播器
        // 由于模拟器的渲染问题，如果发现轮播时有一条线不必处理，模拟器放大到100%或者真机调试是不会出现那条线的
        self.cycleScrollView4 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(60, line1.bottom, kScreen_Width - 60, 40) delegate:self placeholderImage:nil];
        self.cycleScrollView4.titleLabelBackgroundColor = [UIColor whiteColor];
        self.cycleScrollView4.titleLabelTextColor = [UIColor blackColor];
        self.cycleScrollView4.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.cycleScrollView4.onlyDisplayText = YES;
        
        NSMutableArray *titlesArray = [NSMutableArray new];
        [titlesArray addObjectsFromArray:titles];
        self.cycleScrollView4.titlesGroup = [titlesArray copy];
        
        [headview addSubview:self.cycleScrollView4];
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom, kScreen_Width, 10)];
        line.backgroundColor = UIColorFromRGB(0xF0f0F0);
        [headview addSubview:line];
        
        return header;

    }
    UICollectionReusableView *headerheader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[NSString stringWithFormat:@"headerheader%zd",indexPath.section] forIndexPath:indexPath];
    
    headerheader.backgroundColor = [UIColor whiteColor];
    for (UIView *view in headerheader.subviews) { [view removeFromSuperview]; }

    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 40)];
    lab.font = [UIFont systemFontOfSize:14];
    [headerheader addSubview:lab];
    lab.text = @"";

    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(mScreenWidth-35, 17, 25, 5)];
    image.image = [UIImage imageNamed:@"homemore"];
    [headerheader addSubview:image];
    
    UIImageView *banner = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, mScreenWidth, 200)];
    [headerheader addSubview:banner];
    
    if (indexPath.section==1) {
        lab.text = @"特惠产品";
        banner.image = [UIImage imageNamed:@"宠物banner01"];
    }else if (indexPath.section==2){
        lab.text = @"热卖产品";
        banner.image = [UIImage imageNamed:@"宠物banner02"];
    }else if (indexPath.section==3){
        lab.text = @"猜你喜欢";
        banner.image = [UIImage imageNamed:@"宠物banner03"];
    }else if (indexPath.section==4){
        lab.text = @"产品展示";
        banner.image = [UIImage imageNamed:@"宠物banner04"];
    }
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 40+200)];
    but.tag = indexPath.section+170;
    [but addTarget:self action:@selector(typebut:) forControlEvents:UIControlEventTouchUpInside];
    [headerheader addSubview:but];
    return headerheader;
}
- (void)typebut:(UIButton *)but{
    MYYTypeDetailsViewController* vc = [[MYYTypeDetailsViewController alloc]init];
    if (but.tag == 171) {
        vc.biaoshi = @"special";
    }
    else if (but.tag == 172){
        vc.biaoshi = @"hot";
    }else if (but.tag == 173){
        vc.biaoshi = @"like";
    }else if (but.tag == 174){
        vc.biaoshi = @"product";
    }
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)Classbut:(UIButton *)but{
    UINavigationController *temp = (UINavigationController *)[super.tabBarController.viewControllers objectAtIndex:1];
    NewTypeViewController *orderVC = (NewTypeViewController *)temp.topViewController;
    orderVC.controller = @"home";
    orderVC.row = but.tag;
    self.tabBarController.selectedIndex = 1;//跳转
}
- (void)SingleTap:(UITapGestureRecognizer*)recognizer  {
    UINavigationController *temp = (UINavigationController *)[super.tabBarController.viewControllers objectAtIndex:1];
    NewTypeViewController *orderVC = (NewTypeViewController *)temp.topViewController;
    orderVC.controller = @"home";
    orderVC.row = recognizer.view.tag-10;
    self.tabBarController.selectedIndex = 1;//跳转
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MYYDetailsAndCommentViewController* vc = [[MYYDetailsAndCommentViewController alloc]init];
    HomeFavorableModel* model;
    if (indexPath.section==1) {
        if (_favorableDataArray.count!=0) {
            model = _favorableDataArray[indexPath.row];
            vc.proid = [NSString stringWithFormat:@"%@",model.Id];
        }
    }else if (indexPath.section==2){
        if (_hotProDataArray.count!=0) {
            model = _hotProDataArray[indexPath.row];
            vc.proid = [NSString stringWithFormat:@"%@",model.Id];
        }
    }else if (indexPath.section==3){
        if (_youLikeDataArray.count!=0) {
            model = _youLikeDataArray[indexPath.row];
            vc.proid = [NSString stringWithFormat:@"%@",model.proid];
        }
    }else if (indexPath.section==4){
        if (_fomalProDataArray.count!=0) {
            model = _fomalProDataArray[indexPath.row];
            vc.proid = [NSString stringWithFormat:@"%@",model.Id];
        }
    }
    vc.jxproid = [NSString stringWithFormat:@"%@",model.jxproid];
    vc.type = [NSString stringWithFormat:@"%@",model.type];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (cycleScrollView == self.cycleScrollView2) {
        //        NSLog(@"---点击了专题第%ld张图片", (long)index);
        if (!IsEmptyValue(_bannerDataArray)&&_bannerDataArray.count>index) {
            MYYTypeDetailsViewController* vc = [[MYYTypeDetailsViewController alloc]init];
            HomeBannerModel* model = _bannerDataArray[index];
            if (!IsEmptyValue(model.Id)) {
                vc.controller = @"special";
                vc.specialid = [NSString stringWithFormat:@"%@",model.Id];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else if (cycleScrollView == self.cycleScrollView4){
        //        NSLog(@"---点击了公告第%ld张图片", (long)index);
        if (!IsEmptyValue(_noticeDataArray)&&_noticeDataArray.count>index) {
            MYYHomeNoticeViewController* noticeVC = [[MYYHomeNoticeViewController alloc]init];
            CommandModel* model = _noticeDataArray[index];
            noticeVC.noticeid = [NSString stringWithFormat:@"%@",model.Id];
            noticeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:noticeVC animated:YES];
        }
    }
}






- (void)dataRequest{
    [_hud hideAnimated:YES];
    [self bannerRequestData];
    [self typeDataRequest];
    [self favorableDataRequest];
    [self hotProDataRequest];
    [self youLikeDataRequest];
    [self formalProDataRequest];
    [self noticeDataRequest];
    
}

- (void)bannerRequestData{
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"mall/showproduct?action=subjectPic"] refreshCache:YES params:nil success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"专题返回arr%@",array);
        [_bannerDataArray removeAllObjects];
        for (NSDictionary* dict in array) {
            HomeBannerModel* model = [[HomeBannerModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_bannerDataArray addObject:model];
        }
        [_collection reloadData];

        
    } fail:^(NSError *error) {
        
    }];
}

- (void)typeDataRequest{
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"mall/showproduct?action=getProductTress"] refreshCache:YES params:nil success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"分类数据arr%@",array);
        [_typeDataArray removeAllObjects];
        for (NSDictionary* dict in array) {
            HomeTypeModel* model = [[HomeTypeModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_typeDataArray addObject:model];

        }
        [_collection reloadData];

        
    } fail:^(NSError *error) {
        
    }];
}

- (void)favorableDataRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"biaoshi\":\"special\",\"sorts\":\"zonghe\"}"]};
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"mall/showproduct?action=loadProductInfo"] refreshCache:YES params:params success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"特惠数据arr%@",array);
        [_favorableDataArray removeAllObjects];
        for (NSDictionary* dict in array) {
            HomeFavorableModel* model = [[HomeFavorableModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_favorableDataArray addObject:model];
        }
        [_collection reloadData];
    } fail:^(NSError *error) {
        
    }];
}



- (void)hotProDataRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"biaoshi\":\"hot\",\"sorts\":\"zonghe\"}"]};
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"mall/showproduct?action=loadProductInfo"] refreshCache:YES params:params success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"热卖数据arr%@",array);
        [_hotProDataArray removeAllObjects];
        for (NSDictionary* dict in array) {
            HomeFavorableModel* model = [[HomeFavorableModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_hotProDataArray addObject:model];
        }
        [_collection reloadData];

        
    } fail:^(NSError *error) {
        
    }];
}
- (void)youLikeDataRequest{
//    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"biaoshi\":\"like\",\"sorts\":\"zonghe\"}"]};
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"mall/showproduct?action=proLike"] refreshCache:YES params:nil success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"猜你喜欢数据arr%@",array);
        [_youLikeDataArray removeAllObjects];
        for (NSDictionary* dict in array) {
            HomeFavorableModel* model = [[HomeFavorableModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_youLikeDataArray addObject:model];
        }
        [_collection reloadData];

        
    } fail:^(NSError *error) {
        
    }];
}
- (void)formalProDataRequest{
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"8",@"params":[NSString stringWithFormat:@"{\"biaoshi\":\"product\",\"sorts\":\"zonghe\"}"]};
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"mall/showproduct?action=loadProductInfo"] refreshCache:YES params:params success:^(id response) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"正常数据arr%@",dic);
        if (_page==1) {
            [_fomalProDataArray removeAllObjects];
        }
        for (NSDictionary* dict in dic[@"rows"]) {
            HomeFavorableModel* model = [[HomeFavorableModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_fomalProDataArray addObject:model];

        }
        [_collection reloadData];

        
    } fail:^(NSError *error) {
        
    }];
}


- (void)noticeDataRequest{
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"/notice?action=getNotice"] refreshCache:YES params:nil success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"公告数据arr%@",array);
        [_noticeDataArray removeAllObjects];
        for (NSDictionary* dict in array) {
            CommandModel* model = [[CommandModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_noticeDataArray addObject:model];
        }
        [_collection reloadData];

        
    } fail:^(NSError *error) {
        
    }];
}
-(void)addYouLikeCarRequest:(HomeFavorableModel*)model{
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"price\":\"%@\",\"count\":\"%@\",\"type\":\"%@\",\"specification\":\"%@\",\"mainunitid\":\"%@\",\"mainunitname\":\"%@\",\"prono\":\"%@\"}",model.proid,model.proname,model.saleprice,@"1",model.type,model.specification,model.mainunitid,model.mainunitname,model.prono]};
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
- (void)addCarRequest:(HomeFavorableModel*)model{
    /*
     /shoppingcart?action=addShoppingCart  添加购物车接口
     参数：proid,proname,price,count,type,specification
     */
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"price\":\"%@\",\"count\":\"%@\",\"type\":\"%@\",\"specification\":\"%@\",\"mainunitid\":\"%@\",\"mainunitname\":\"%@\",\"prono\":\"%@\"}",model.Id,model.proname,model.saleprice,@"1",model.type,model.specification,model.mainunitid,model.mainunitname,model.prono]};
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


#pragma mark -－－－－－－－－－－－－－－ 版本更新－－－－－－－－－－－－－－－－－－－－－－－－－－－
//版本更新
- (void)versionRequest{
    /*lxpub/app/version?
     
     action=getVersionInfo
     project=lx
     联祥           applelianxiang
     京新           applejingxin
     易软通         appleyiruantong
     华抗           applehuakang
     济南智圣医疗    applejnzsyl
     圣地宝         applesdb
     康普善         applekps
     金易销         applejyx
     中抗           applezk
     */
    NSString *project;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    NSLog(@"app名字%@",appName);
    
    if ([appName isEqualToString:@"徒河食品"]) {
        project = @"appletuheshipin";
    }
    if ([appName isEqualToString:@"华抗药业"]) {
        project = @"applehuakang";
    }
    if ([appName isEqualToString:@"京新药业"]) {
        project = @"applejingxin";
    }
    if ([appName isEqualToString:@"中抗药业"]) {
        project = @"applezk";
    }
    if ([appName isEqualToString:@"联祥网络"]) {
        project = @"applelianxiang";
    }
    if ([appName isEqualToString:@"金易销"]) {
        project = @"applejyx";
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@:8004/lxpub/app/version",Ver_Address];
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
    NSDictionary *parameters = @{@"action":@"getVersionInfo",@"project":[NSString stringWithFormat:@"%@",@"appleaichong"]};
    
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:parameters success:^(id response) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"版本信息:%@",dic);
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDic));
        NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
        NSLog(@"当前版本号%@",appVersion);
        NSString *version = dic[@"app_version"];
        NSString *nessary = dic[@"app_necessary"];
        NSLog(@"请求版本号%@",appVersion);
        _versionUrl = dic[@"app_url"];
        //[self showAlert];
        if ([version isEqualToString:appVersion]) {
            
        }else if(![version isEqualToString:appVersion]){
            if ([nessary isEqualToString:@"0"]) {
                
                [self showAlert];
            }else if([nessary isEqualToString:@"1"]){
                
                [self showAlert1];
            }
        }
    } fail:^(NSError *error) {
        NSLog(@"更新检测请求失败");
    }];
    
    //    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //
    //
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //
    //    }];
}
//选择更新
- (void)showAlert{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                    message:@"发现新版本，是否马上更新？"
                                                   delegate:self
                                          cancelButtonTitle:@"以后再说"
                                          otherButtonTitles:@"下载", nil];
    alert.tag = 10001;
    [alert show];
    
}
//强制更新
- (void)showAlert1{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                    message:@"发现新版本，是否马上更新？"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"下载", nil];
    alert.tag = 10002;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 拼接url 防止读取缓存
    NSString *sign = [NSString stringWithFormat:@"%zi",[self getRandomNumber:1 to:1000]];
    if (alertView.tag==10001) {
        if (buttonIndex==1) {
            NSString *str = [NSString stringWithFormat:@"itms-services://?v=%@&action=download-manifest&url=%@",sign,_versionUrl];
            //            NSString *str1 = @"https://www.pgyer.com/lOJg";//http://www.pgyer.com/CxLm
            //            NSURL *url = [NSURL URLWithString:str1];
            NSURL *url = [NSURL URLWithString:str];
            
            [[UIApplication sharedApplication]openURL:url];
            
        }
        
    }else if (alertView.tag == 10002){
        
        if (buttonIndex == 0) {
            
            NSString *str = [NSString stringWithFormat:@"itms-services://?v=%@&action=download-manifest&url=%@",sign,_versionUrl];
            
            //            NSString *str1 = @"https://www.pgyer.com/lOJg";
            //            NSURL *url = [NSURL URLWithString:str1];
            
            NSURL *url = [NSURL URLWithString:str];
            [[UIApplication sharedApplication]openURL:url];
            
        }
    }else if (alertView.tag == 10003){
        if (buttonIndex == 1) {
            if (SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            }
        }
    }
}

-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}



@end


