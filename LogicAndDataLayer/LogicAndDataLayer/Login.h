//
//  Login.h
//  LogicAndDataLayer
//
//  Created by ZQP on 14-6-22.
//  Copyright (c) 2014年 study. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Login : NSObject

-(void)acquireViewStare;

-(void)shuaXinYanZhengMa:(void(^)(UIImage* image))handleImage;

- (void)login;
@end
