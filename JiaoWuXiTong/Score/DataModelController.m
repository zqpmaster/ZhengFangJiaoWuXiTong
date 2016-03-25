//
//  DataModelController.m
//  JiaoWuGuanLi
//
//  Created by Zinzie on 14-2-10.
//  Copyright (c) 2014年 Zinzie. All rights reserved.
//

#import "DataModelController.h"
#import "DataModel.h"
#import "TFHpple.h"
#import "UserInfoManager.h"
#import "AFNetworking.h"

@interface DataModelController ()
@property(nonatomic,strong)NSString *viewState;
@property(nonatomic,strong)NSMutableArray *chengJiCache;
@property(nonatomic,strong)NSString *urlScore;
@end
@implementation DataModelController

-(void)setChengJiList:(NSMutableArray *)chengJiList{
    @synchronized(_chengJiList){
        _chengJiList = [chengJiList mutableCopy];
        if (self.scoreOfYear) {
            NSMutableIndexSet *set=[[NSMutableIndexSet alloc]init];
            for (DataModel *modals in _chengJiList) {
                if (![modals.year isEqualToString:self.scoreOfYear]) {
                    [set addIndex:[self.chengJiList indexOfObject:modals]];
                }
            }
            [self.chengJiList removeObjectsAtIndexes:set];
        }
    }
}

-(id)init{
    if (self = [super init]) {
        self.chengJiList = [[NSMutableArray alloc]init];
        self.chengjiListAll=[[NSMutableArray alloc]init];
        [self jiaZaiChengJi];
        
        return self;
    }
    return nil;
}


-(void)jiaZaiChengJi{//第一次加载
    [self getViewStateInScorePage];
    
}
-(void)getViewStateInScorePage{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.stringEncoding=enc;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.stringEncoding = enc;
    UserInfoManager *userInfo=[UserInfoManager shareManager];
    NSString *uName=userInfo.name;
    NSString *zhangHao=userInfo.xueHao;
    if(uName!=nil&&zhangHao!=nil){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *parameters2 = @{@"xh":zhangHao,@"xm":uName,@"gnmkdm":@"N121605"};
            //        [manager GET:@"http://172.21.96.64/xscjcx.aspx?xh=11024132&xm=%D5%C5%C8%AB%C5%F4&gnmkdm=N121605" parameters:nil
            [manager GET:@"http://172.21.96.64/xscjcx.aspx?" parameters:parameters2
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     //              NSLog(@"huoqushuju: %ld",(long)operation.response.statusCode);
                     //                  NSLog(@"数据：%d",operation.response.statusCode);
                     NSURL *urlLinshi=operation.request.URL;
                     self.urlScore=urlLinshi.absoluteString;
                     NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
                     
                     NSData *data=responseObject;
                     NSString *transStr=[[NSString alloc]initWithData:data encoding:enc];
                     
                     NSString *utf8HtmlStr = [transStr stringByReplacingOccurrencesOfString:@"<meta content=\"text/html; charset=gb2312\" http-equiv=\"Content-Type\">" withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
                     NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
                     TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:htmlDataUTF8];
                     //                  NSArray *elements  = [xpathParser searchWithXPathQuery:@"//table[@class='datelist']/tr[2]/td"];
                     NSArray *elements  = [xpathParser searchWithXPathQuery:@"//input[@name='__VIEWSTATE']"];
                     
                     
                     // Access the first cell
                     
                     TFHppleElement *element = [elements objectAtIndex:0];
                     self.viewState=[element objectForKey:@"value"];
                     NSLog(@"1提取到得viewstate为%@",self.viewState);
                     //                      NSDictionary *parameters = @{@"__EVENTTARGET":@"",@"__EVENTARGUMENT":@"",@"__VIEWSTATE":self.viewState,@"btn_zcj": @"历年成绩"};
                     [self refreshModal];
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"Error: %@", [error debugDescription]);
                 }];//获取登陆后的网页
        });
        
    }
    
    
    
}

-(void)refreshModal{//更新
    if(self.viewState!=nil&&self.urlScore!=nil){
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.stringEncoding=enc;
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer.stringEncoding = enc;
        NSDictionary *parameters = @{@"__VIEWSTATE":self.viewState,@"ddlXN":@"",@"ddlXQ":@"",@"ddl_kcxz":@"",@"btn_zcj": @"历年成绩"};
        [manager POST:self.urlScore parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
                  
                  NSData *data=responseObject;
                  NSString *transStr=[[NSString alloc]initWithData:data encoding:enc];
                  
                  NSLog(@"biaodantijiaochenggong:%ld，%@",(long)operation.response.statusCode,transStr);//提交表单
                  NSString *utf8HtmlStr = [transStr stringByReplacingOccurrencesOfString:@"<meta content=\"text/html; charset=gb2312\" http-equiv=\"Content-Type\">" withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
                  NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
                  [self arrangeData:htmlDataUTF8];
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", [error description]);
              }];
        
    }else{
        [self getViewStateInScorePage];
    }
    
    
}
-(void)arrangeData:(NSData*)scoreData{
    
    TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:scoreData];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//table[@class='datelist']/tr/td"];
    // Access the first cell
    NSUInteger count=[elements count];
    [self.chengJiCache removeAllObjects];
    for (int i=0; i<count; i++) {
        TFHppleElement *element = [elements objectAtIndex:i];
        // Get the text within the cell tag
        NSString *content = [element text];
        if(content==nil){
            content=@"没有值";
        }
        [self.chengJiCache addObject:content];
        
        //                                    NSString *ta=[element tagName];
        //                                    NSLog(@"成绩为%@%@",content,ta);
    }
    
    //Get all the cells of the 2nd row of the 3rd table
    long countCache=[self.chengJiCache count];
    if(countCache>15){
        NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 15)];
        [self.chengJiCache removeObjectsAtIndexes:indexes];
        [self.chengJiList removeAllObjects];
        for(int i=0; i<(countCache-15)/15;i++){
            //                                    NSLog(@"%@",[self.chengJiCache objectAtIndex:i]);
            DataModel *scoreModal = [[DataModel alloc]initWithName:[self.chengJiCache objectAtIndex:3+i*15]
                                                              mark:[self.chengJiCache objectAtIndex:8+i*15]
                                                            jidian:[self.chengJiCache objectAtIndex:7+i*15]
                                                         attribute:[self.chengJiCache objectAtIndex:4+i*15]
                                                            number:[self.chengJiCache objectAtIndex:2+i*15]
                                                           teacher:@"刘际洪"
                                                              year:[self.chengJiCache objectAtIndex:0+i*15]
                                                              term:[self.chengJiCache objectAtIndex:1+i*15]
                                                            xueFen:[self.chengJiCache objectAtIndex:6+i*15]
                                                           xueYuan:[self.chengJiCache objectAtIndex:12+i*15]];
            [self addchengjiListWithChengji:scoreModal];
            
        }
        self.chengJiList=[self.chengjiListAll mutableCopy];
        
    }
    
}
-(NSUInteger)countOfChengJiList{
    return [self.chengJiList count];
}

-(DataModel *)objectInChengJiListAtIndex:(NSUInteger)index{
    return [self.chengJiList objectAtIndex:index];
}

-(void)addchengjiListWithChengji:(DataModel *)chengJi{
    [self.chengjiListAll addObject:chengJi];
}
-(NSMutableArray *)chengJiCache{
    if(!_chengJiCache){
        _chengJiCache=[[NSMutableArray alloc]init];
    }
    return _chengJiCache;
}
-(void)removeAllObjects{
    //    [self.chengjiListAll removeAllObjects];
    [self.chengJiList removeAllObjects];
}
-(void)setScoreOfYear:(NSString *)scoreOfYear{
    if (_scoreOfYear!=scoreOfYear) {
        _scoreOfYear=scoreOfYear;
        self.chengJiList=[self.chengjiListAll mutableCopy];
        //        NSMutableIndexSet *set=[[NSMutableIndexSet alloc]init];
        //        for (DataModel *modals in self.chengJiList) {
        //            if (![modals.year isEqualToString:scoreOfYear]) {
        //                [set addIndex:[self.chengJiList indexOfObject:modals]];
        //            }
        //        }
        //        [self.chengJiList removeObjectsAtIndexes:set];
    }
}
@end
