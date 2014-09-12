//
//  UserInfoManager.m
//  JiaoWuXiTong
//
//  Created by ZQP on 14-9-12.
//  Copyright (c) 2014年 ZQP. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager

+(instancetype)shareManager{
    static UserInfoManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[UserInfoManager alloc]init];
    });
    return manager;
}

@end
