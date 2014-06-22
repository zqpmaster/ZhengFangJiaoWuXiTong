//
//  DataModel.m
//  JiaoWuGuanLi
//
//  Created by Zinzie on 14-2-10.
//  Copyright (c) 2014年 Zinzie. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

-(id)initWithName:(NSString *)name mark:(NSString *)mark jidian:(NSString *)jidian attribute:(NSString *)attribute number:(NSString *)number teacher:(NSString *)teacher year:(NSString *)year term:(NSString *)term xueFen:(NSString *)xuefen xueYuan:(NSString *)xueYuan{
    self = [super init];
    if (self) {
        _name = name;
        _mark = mark;
        _jidian = jidian;
        _attribute = attribute;
        _number = number;
        _teacher = teacher;
        _year = year;
        _term = term;
        _xueFen = xuefen;
        _xueYuan = xueYuan;
        return self;
    }
    return nil;
}
@end
