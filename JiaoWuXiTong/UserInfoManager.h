//
//  UserInfoManager.h
//  JiaoWuXiTong
//
//  Created by ZQP on 14-9-12.
//  Copyright (c) 2014年 ZQP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoManager : NSObject

+(instancetype)shareManager;

@property (strong,nonatomic)NSString *name;
@property (strong,nonatomic)NSString *xueHao;

@end
