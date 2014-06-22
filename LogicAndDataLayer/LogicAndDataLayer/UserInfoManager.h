//
//  UserInfoManager.h
//  LogicAndDataLayer
//
//  Created by ZQP on 14-6-22.
//  Copyright (c) 2014年 study. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoManager : NSObject

@property (strong,nonatomic) NSString *navBarXueHao;
@property (strong, nonatomic)NSString *userName;

+ (instancetype)shareManagerMet;

@end
