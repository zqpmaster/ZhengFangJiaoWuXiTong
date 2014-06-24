//
//  Login.m
//  LogicAndDataLayer
//
//  Created by ZQP on 14-6-22.
//  Copyright (c) 2014年 study. All rights reserved.
//

#import "Login.h"
#import "TFHpple.h"
#import "UserInfoManager.h"

@interface Login ()
@property (strong, nonatomic) AFHTTPRequestOperationManager *afnetWorking;
@property (copy,nonatomic) NSString *viewState;

@property (strong,nonatomic) NSString *numberId;
@property(strong,nonatomic)NSString *userName;
//@property (nonatomic,strong) NSDictionary* cookieDictionary;

@end
@implementation Login{
    
}
- (void)viewDidLoad
{
    //        [self acquireViewStare];
    [self shuaXinYanZhengMa:nil];
}
-(void)acquireViewStare{
    __weak typeof(self) tempSelf=self;//success在主线程
    dispatch_async(queue, ^{
    [tempSelf.afnetWorking GET:@"http://172.21.96.64/default2.aspx" parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
                 
                 NSData *data=responseObject;
                 NSString *transStr=[[NSString alloc]initWithData:data encoding:enc];
                 
                 NSString *utf8HtmlStr = [transStr stringByReplacingOccurrencesOfString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">" withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
                 NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
                 TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:htmlDataUTF8];
                 NSArray *elements  = [xpathParser searchWithXPathQuery:@"//input[@name='__VIEWSTATE']"];
                 
                 // Access the first cell
                 int count=[elements count];
                 for (int i=0; i<count; i++) {
                     TFHppleElement *element = [elements objectAtIndex:i];
                     tempSelf.viewState=[element objectForKey:@"value"];
                     //                  [self huoDevs];
                     NSLog(@"1提取到得viewstate为%@",tempSelf.viewState);
                     [tempSelf loginMet];
                     
                     
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Error: %@", [error debugDescription]);
             }];//获取登陆后的网页
    //    NSLog(@"1提取到得viewstate为%@",viewstates);
    //    self.viewState=viewstates;
    });
//    NSLog(@"2提取到得viewstate为%@",self.viewState);
    
}
-(void)shuaXinYanZhengMa:(void(^)(UIImage* image))handleImage{
    __weak typeof(self) tempSelf=self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *UrlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: @"http://172.21.96.64/CheckCode.aspx"]];
        //提交Cookie，上一行的NSURLRequest被改为NSMutableURLRequest
        
        if(tempSelf.afnetWorking.cookieDictionary) {
            [UrlRequest setHTTPShouldHandleCookies:NO];
            
            [UrlRequest setAllHTTPHeaderFields:tempSelf.afnetWorking.cookieDictionary];
        }
        //end
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:UrlRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response: %@", responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (responseObject&&handleImage) {
                    handleImage(responseObject);
                }
            });
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        [requestOperation start];
        // 显示验证码
    });
    
}

- (void)login {
    if (!self.viewState) {
        NSLog(@"没有viewstate");
            [self acquireViewStare];
    }else{
        NSLog(@"有state%@直接登录",self.viewState);
            [self loginMet];
    }
}
-(void)loginMet{
    //    [self acquireViewStare];
    //
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    //
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    //
    //    manager.requestSerializer.stringEncoding = enc;
    //    manager.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    //   manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //
    NSString *xueHaoSe=self.xueHao.text;
    NSDictionary *parameters = @{@"__VIEWSTATE":self.viewState,@"txtUserName": self.xueHao.text,@"TextBox2":self.miMa.text,@"txtSecretCode":self.yanZhengMa.text,@"RadioButtonList1":@"学生",@"Button1":@""};
    __weak typeof(self) tempSelf=self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [tempSelf.afnetWorking POST:@"http://172.21.96.64/default2.aspx" parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
                  
                  NSData *data=responseObject;
                  NSString *transStr=[[NSString alloc]initWithData:data encoding:enc];
                  
                  NSLog(@"biaodantijiaochenggong:%ld，%@",(long)operation.response.statusCode,transStr);//提交表单
                  tempSelf.text.text=transStr;
                  //          NSString *html=[[NSString alloc]initWithData:operation.responseData encoding:enc];
                  //          NSData *data=[ dataUsingEncoding:NSUTF8StringEncoding];
                  //          NSURL *htmlUrl = [NSURL URLWithString:@"http://172.21.96.66/default2.aspx"];
                  //          NSString *htmlString = [NSString stringWithData:operation.responseData];
                  //          NSData *htmlData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                  //          NSData *data= [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:@"http://172.21.96.64/default2.aspx"]];
                  //          NSURL *url=[[NSBundle mainBundle]URLForResource:@"xxxaaa.html" withExtension:@"html"];
                  //          NSData *data= [NSData dataWithContentsOfURL:url];
                  //
                  NSString *utf8HtmlStr = [transStr stringByReplacingOccurrencesOfString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">" withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
                  NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
                  TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:htmlDataUTF8];
                  NSArray *elements  = [xpathParser searchWithXPathQuery:@"//span[@id='xhxm']"];
                  
                  // Access the first cell
                  NSUInteger count=[elements count];
                  for (int i=0; i<count; i++) {
                      TFHppleElement *element = [elements objectAtIndex:i];
                      
                      // Get the text within the cell tag
                      NSString *content = [element text];
                      NSString *ta=[element tagName];
                      //              NSLog(@"之前%@",self.viewState);
                      //              self.viewState=[element objectForKey:@"value"];
                      //              NSLog(@"之后%@",self.viewState);
                      NSString *namess=[content substringFromIndex:10];
                      tempSelf.userName=[namess substringToIndex:[namess length]-2];
                      NSLog(@"学号姓名为%@%@%@",content,ta,namess);
                  }
                  //Get all the cells of the 2nd row of the 3rd table
                  tempSelf.numberId=xueHaoSe;
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", @"???");
              }];
    });
}
//实例化
-(AFHTTPRequestOperationManager*)afnetWorking{
    if (!_afnetWorking) {
        
        _afnetWorking=[AFHTTPRequestOperationManager manager];
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        _afnetWorking.responseSerializer.stringEncoding=enc;
        _afnetWorking.requestSerializer.stringEncoding = enc;
        _afnetWorking.responseSerializer=[AFHTTPResponseSerializer serializer];
        _afnetWorking.requestSerializer = [AFHTTPRequestSerializer serializer];

    }
    return _afnetWorking;
}
-(void)setNumberId:(NSString *)numberId{
    if (_numberId!=numberId) {
        _numberId = numberId
        UserInfoManager *manager=[UserInfoManager shareManagerMet];
        manager.navBarXueHao=_numberId
    }

}
-(void)setUserName:(NSString *)userName{
    if (_userName!=userName) {
        _userName=userName;
        UserInfoManager *manager=[UserInfoManager shareManagerMet];
        manager.userName=_userName;
    }

}

@end
