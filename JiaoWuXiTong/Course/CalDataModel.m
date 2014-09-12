//
//  CalDataModel.m
//  JiaoWuGuanLi
//
//  Created by Zinzie on 14-4-16.
//  Copyright (c) 2014年 Zinzie. All rights reserved.
//

#import "CalDataModel.h"

@implementation CalDataModel



-(id)initWithmingCheng:(NSString *)mingCheng jiaoShi:(NSString *)jiaoShi shiJian:(NSString *)shiJian laoShi:(NSString *)laoShi xingQi:(NSUInteger *)xingQi kaiShiZhou:(NSUInteger *)kaiShiZhou jieShuZhou:(NSUInteger *)jieShuZhou{
    self = [super init];
    if (self) {
        _mingCheng = mingCheng;
        _jiaoShi = jiaoShi;
        _shiJian = shiJian;
        _laoShi = laoShi;
        _kaiShiZhou = kaiShiZhou;
        _jieShuZhou = jieShuZhou;
        _xingQi = xingQi;
        return self;
    }
    return nil;

    
}

@end
