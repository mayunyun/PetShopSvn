//
//  MYYDetailEveryoneModel.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface MYYDetailEveryoneModel : BaseModel

@property (nonatomic,strong)NSString* type;
@property (nonatomic,strong)NSString* proid;
@property (nonatomic,strong)NSString* jxproid;
@property (nonatomic,strong)NSString* proname;
@property (nonatomic,strong)NSString* count;
@property (nonatomic,strong)NSString* price;
@property (nonatomic,strong)NSString* autoname;
@property (nonatomic,strong)NSString* mainunitname;
@property (nonatomic,strong)NSString* secondunitname;



/*
 {"type":1,"proid":18,"proname":"本家蛋","count":12,"price":100,"autoname":"911c5a847b8a4e0a9ee00720eb61d939.jpg"}
 */
@end
