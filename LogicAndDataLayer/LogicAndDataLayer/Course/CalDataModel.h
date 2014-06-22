//
//  CalDataModel.h
//  JiaoWuGuanLi
//
//  Created by Zinzie on 14-4-16.
//  Copyright (c) 2014年 Zinzie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalDataModel : NSObject

@property (nonatomic,copy) NSString *mingCheng;
@property (nonatomic,copy) NSString *jiaoShi;
@property (nonatomic) NSUInteger *xingQi;//周几
@property (nonatomic) NSString *shiJian;//第几节课
@property (nonatomic) NSUInteger *kaiShiZhou;//开始结束周
@property (nonatomic) NSUInteger *jieShuZhou;
@property (nonatomic,copy) NSString *laoShi;



-(id)initWithmingCheng:(NSString *)mingCheng
               jiaoShi:(NSString *)jiaoShi
               shiJian:(NSString *)shiJian
                laoShi:(NSString *)laoShi
                xingQi:(NSUInteger *)xingQi
            kaiShiZhou:(NSUInteger *)kaiShiZhou
            jieShuZhou:(NSUInteger *)jieShuZhou;
@end
