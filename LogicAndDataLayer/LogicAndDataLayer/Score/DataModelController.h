//
//  DataModelController.h
//  JiaoWuGuanLi
//
//  Created by Zinzie on 14-2-10.
//  Copyright (c) 2014年 Zinzie. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DataModel;
@interface DataModelController : NSObject
@property (nonatomic,strong) NSMutableArray *chengJiList;
@property (nonatomic,strong) NSMutableArray *chengjiListAll;
@property (nonatomic, strong)NSString *scoreOfYear;

//-(NSUInteger)countOfChengJiList;
//-(DataModel *)objectInChengJiListAtIndex:(NSUInteger)index;
//-(void)addchengjiListWithChengji:(DataModel *)chengJi;
-(void)removeAllObjects;
-(void)refreshModal;
@end
