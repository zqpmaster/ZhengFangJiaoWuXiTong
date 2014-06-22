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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
