//
//  CourseViewModel.h
//  JiaoWuXiTong
//
//  Created by ZQP on 14-9-17.
//  Copyright (c) 2014年 ZQP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveViewModel.h"

@interface CourseViewModel :RVMViewModel

@property(nonatomic, readonly) RACSignal *updatedContentSignal;

-(NSInteger)numberOfSections;
-(NSInteger)numberOfItemsInSection:(NSInteger)section;
-(NSString *)titleAtIndexPath:(NSIndexPath *)indexPath;

//

@end

