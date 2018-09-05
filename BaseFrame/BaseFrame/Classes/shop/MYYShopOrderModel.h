//
//  MYYShopOrderModel.h
//  BaseFrame
//
//  Created by apple on 17/5/11.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYYShopOrderModel : NSObject

@property(nonatomic,copy)NSString *custid;
@property(nonatomic,copy)NSString *proid;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *proname;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *specification;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *autoname;
@property(nonatomic,copy)NSString *money;
@property(nonatomic,copy)NSString *jxproid;
@property(nonatomic,copy)NSString *secondtoremainder;
@property(nonatomic,copy)NSString *maintosecond;
@property(nonatomic,copy)NSString *prono;
@property(nonatomic,copy)NSString *mainunitname;
@property(nonatomic,copy)NSString *mainunitid;
@property(nonatomic,copy)NSString *remainderunitname;
@property(nonatomic,copy)NSString *remainderunitid;
@property(nonatomic,copy)NSString *secondunitname;
@property(nonatomic,copy)NSString *secondunitid;

/*
 {
 autoname = "70ceb689f78e435587c44ca8efcc6d6d.png";
 count = 1;
 jxproid = 417;
 maintosecond = 200;
 mainunitid = 197;
 mainunitname = "\U4ef6";
 money = 3420;
 price = 3420;
 proid = 101;
 proname = "H\U963f\U82ef\U8fbe\U5511\U7247";
 remainderunitid = 304;
 remainderunitname = "\U5305";
 secondtoremainder = 20;
 secondunitid = 178;
 secondunitname = "\U76d2";
 specification = "0.2*1 \U7247/\U888b*2 \U888b/\U76d2*10\U76d2/\U5305*20\U5305/\U4ef6";
 type = 0;
 }
 */

@end
