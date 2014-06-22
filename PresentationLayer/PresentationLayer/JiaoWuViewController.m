//
//  JiaoWuViewController.m
//  JiaoWuXiTong
//
//  Created by ZQP on 14-2-7.
//  Copyright (c) 2014年 ZQP. All rights reserved.
//

#import "JiaoWuViewController.h"
#import "FenShuViewController.h"
#import "KeBiaoViewController.h"
@interface JiaoWuViewController ()
@property (weak, nonatomic) IBOutlet UITextField *xueHao;
@property (weak, nonatomic) IBOutlet UITextField *miMa;
@property (weak, nonatomic) IBOutlet UITextField *yanZhengMa;
@property (weak, nonatomic) IBOutlet UIImageView *yanZhengMaImageView;
@property (weak, nonatomic) IBOutlet UITextView *text;
//@property (nonatomic,strong) NSDictionary* cookieDictionary;

@end
@implementation JiaoWuViewController{
}
- (void)viewDidLoad
{
//        [self acquireViewStare];
    }
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)TextField_DidEndOnExit:(id)sender {
    // 隐藏键盘.
    [sender resignFirstResponder];
}
- (IBAction)shuaXinYanZhengMaImageView:(id)sender {

}
@end

