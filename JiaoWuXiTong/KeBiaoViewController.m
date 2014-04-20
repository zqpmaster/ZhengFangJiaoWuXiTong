//
//  KeBiaoViewController.m
//  JiaoWuXiTong
//
//  Created by ZQP on 14-2-24.
//  Copyright (c) 2014年 ZQP. All rights reserved.
//

#import "KeBiaoViewController.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "CalDataModel.h"
#import "JiaoWuAppDelegate.h"

@interface KeBiaoViewController ()
@property (weak, nonatomic) IBOutlet UITextView *keBiao;
@property (strong, nonatomic) NSArray *allClasses;


@end

@implementation KeBiaoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//
    AFHTTPRequestOperationManager *manager2 = [AFHTTPRequestOperationManager manager];
    
    manager2.responseSerializer = [AFHTTPResponseSerializer serializer];
    JiaoWuAppDelegate *mainDele=[[UIApplication sharedApplication]delegate];
    NSString *uName=mainDele.userName;
    NSString *zhangHao=mainDele.navBarXueHao;
    if(uName!=nil&&zhangHao!=nil){
    NSDictionary *parameters2 = @{@"xh":zhangHao,@"xm":uName,@"gnmkdm":@"N121603"};
    [manager2 GET:@"http://172.21.96.64/xskbcx.aspx?xh=11024132&xm=%D5%C5%C8%AB%C5%F4&gnmkdm=N121603" parameters:parameters2
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"huoqushuju: %ld",(long)operation.response.statusCode);
              NSLog(@"数据：%@",operation.responseString);
              self.keBiao.text=operation.responseString;
              NSString *utf8HtmlStr = [operation.responseString stringByReplacingOccurrencesOfString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">" withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
              NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
              TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:htmlDataUTF8];
              NSArray *elements  = [xpathParser searchWithXPathQuery:@"//table[@id='Table1']/tr/td/child::text()"];
              
              // Access the first cell
              NSUInteger count=[elements count];
              NSMutableArray *allContents=[NSMutableArray array];
              for (int i=0; i<count; i++) {

              TFHppleElement *element = [elements objectAtIndex:i];
              
              // Get the text within the cell tag
              NSString *content = [element text];
              NSString *ta=[element tagName];
                  NSDictionary *dic=[element attributes];
                  NSString *nodeContent=[element content];
              NSLog(@"课程为%@%@",nodeContent,ta);
                  [allContents addObject:nodeContent];
              }

              [self sortData:allContents];
              
              [allContents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
              NSLog(@"%@",obj);
              }];


          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", [error debugDescription]);
          }];//获取登陆后的网页

    
    }
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)sortData:(NSMutableArray*)arrayData{
    
    __block NSMutableIndexSet* indexSet=[NSMutableIndexSet indexSet];
    [arrayData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"%@",obj);
        NSString *string=obj;
        if([string isEqualToString:@" "]||[string hasPrefix:@"星期"]||[string isEqualToString:@"上午"]||[string isEqualToString:@"下午"]||[string isEqualToString:@"早晨"]||[string isEqualToString:@"晚上"]){
            [indexSet addIndex:idx];
        }
        if([string hasPrefix:@"第"]&&[string hasSuffix:@"节"]){
            [indexSet addIndex:idx];
        }
        if([string isEqualToString:@"时间"]){
            [indexSet addIndex:idx];
        }

        
    }];
    [arrayData removeObjectsAtIndexes:indexSet];
    long count=arrayData.count;
    if(count%4==0){
        NSLog(@"一共有%lu节课程",count/4);
        NSMutableArray *cach=[NSMutableArray array];
        for(int i=0;i<arrayData.count/4;i++){
            CalDataModel *model=[[CalDataModel alloc]initWithmingCheng:arrayData[i*4] jiaoShi:arrayData[i*4+3] shiJian:arrayData[i*4+1] laoShi:arrayData[i*4+2] xingQi:0 kaiShiZhou:0 jieShuZhou:0];
            [cach addObject:model];
        }
        self.allClasses=[[NSArray alloc]initWithArray:cach];
    }
}
@end
