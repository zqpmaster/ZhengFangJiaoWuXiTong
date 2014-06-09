//
//  FenShuViewController.m
//  JiaoWuXiTong
//
//  Created by ZQP on 14-2-24.
//  Copyright (c) 2014年 ZQP. All rights reserved.
//

#import "FenShuViewController.h"
#import "TFHpple.h"

@interface FenShuViewController ()
//@property (nonatomic,strong) NSMutableArray *notes;
//
//@property (nonatomic, strong) NSString *currentTagName;
@end

@implementation FenShuViewController{
}

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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    AFHTTPRequestOperationManager *manager2 = [AFHTTPRequestOperationManager manager];
//   NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    manager2.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager2.responseSerializer.stringEncoding=enc;
//    manager2.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager2.requestSerializer.stringEncoding = enc;
    //
    
    [manager2 GET:@"http://172.21.96.64/xscjcx.aspx?xh=11024132&xm=%D5%C5%C8%AB%C5%F4&gnmkdm=N121605" parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              NSLog(@"huoqushuju: %ld",(long)operation.response.statusCode);
              NSLog(@"数据：%@",operation.responseString);
              self.fenShu.text=operation.responseString;
              NSString *utf8HtmlStr = [operation.responseString stringByReplacingOccurrencesOfString:@"<meta content=\"text/html; charset=gb2312\" http-equiv=\"Content-Type\">" withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
              NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
              TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:htmlDataUTF8];
              NSArray *elements  = [xpathParser searchWithXPathQuery:@"//table[@class='datelist']/tr[2]/td"];
              
              // Access the first cell
              NSUInteger count=[elements count];
              for (int i=0; i<count; i++) {
                  
                  TFHppleElement *element = [elements objectAtIndex:i];
                  
                  // Get the text within the cell tag
                  NSString *content = [element text];
//                  NSString *ta=[element tagName];
                  NSLog(@"未通过成绩为%@",content);
              }

//  
//              NSString *utf8HtmlStr = [operation.responseString stringByReplacingOccurrencesOfString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">" withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
//              NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
//              TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:htmlDataUTF8];
//              NSArray *elements  = [xpathParser searchWithXPathQuery:@"//title"];
//              
//              // Access the first cell
//              NSUInteger count=[elements count];
//              for (int i=0; i<count; i++) {
//                  TFHppleElement *element = [elements objectAtIndex:i];
//                  //
//                  //              // Get the text within the cell tag
//                  NSString *content = [element text];
////                  NSString *ta=[element tagName];
////                  NSString *view=[element objectForKey:@"value"];
//                  NSLog(@"学号姓名为%@",content);
//
//              }
//              
//
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", [error debugDescription]);
          }];//获取登陆后的网页

	// Do any additional setup after loading the view.
   
    // 获取xml文件的路径
//    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"users" ofType:@"xhtml"];
//    // 转化为Data
//    NSData *data = [[NSData alloc] initWithContentsOfFile:xmlPath];
    // 初始化
    
    });
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma - mark 开始解析时
//文档开始的时候触发


@end
