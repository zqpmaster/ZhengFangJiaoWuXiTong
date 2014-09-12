//
//  DataModel.h
//  JiaoWuGuanLi
//
//  Created by Zinzie on 14-2-10.
//  Copyright (c) 2014年 Zinzie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *mark; //成绩
@property (nonatomic,copy) NSString *jidian; //绩点
@property (nonatomic,copy) NSString *attribute; //课程性质
@property (nonatomic,copy) NSString *number; //课程编号
@property (nonatomic,copy) NSString *teacher; //教师
@property (nonatomic,copy) NSString *year; //学年
@property (nonatomic,copy) NSString *term;  //学期
@property (nonatomic,copy) NSString *xueFen; //学分
@property (nonatomic,copy) NSString *xueYuan; //开设学院


-(id)initWithName:(NSString *)name
             mark:(NSString *)mark
           jidian:(NSString *)jidian
        attribute:(NSString *)attribute
           number:(NSString *)number
          teacher:(NSString *)teacher
             year:(NSString *)year
             term:(NSString *)term
           xueFen:(NSString *)xuefen
          xueYuan:(NSString *)xueYuan;
@end
