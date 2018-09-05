//
//  MYYDetailProCommentModel.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface MYYDetailProCommentModel : BaseModel
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* proid;
@property (nonatomic,strong)NSString* proname;
@property (nonatomic,strong)NSString* custid;
@property (nonatomic,strong)NSString* custname;
@property (nonatomic,strong)NSString* comments;
@property (nonatomic,strong)NSString* scores;
@property (nonatomic,strong)NSString* createtime;
@property (nonatomic,strong)NSString* type;
/*
 {"id":12,"proid":27,"proname":"金蛋","custid":23,"custname":"song","comments":"法第三方师傅师傅的说法","scores":"2","createtime":"2017-05-08 15:25:21","type":0}
 */
@end
