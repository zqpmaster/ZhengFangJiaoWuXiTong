//
//  UserInfoManager.m
//  LogicAndDataLayer
//
//  Created by ZQP on 14-6-22.
//  Copyright (c) 2014年 study. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager

static UserInfoManager *_shareManageVar;
+ (instancetype)shareManagerMet {
    if (!_shareManageVar) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareManageVar = [[self alloc] init];
        });
    }
    return _shareManageVar;
}

@end
