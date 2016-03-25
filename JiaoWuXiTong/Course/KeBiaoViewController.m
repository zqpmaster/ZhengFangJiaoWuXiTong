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
#import "CourseViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface KeBiaoViewController ()
@property (weak, nonatomic) IBOutlet UITextView *keBiao;
@property (strong,nonatomic) CourseViewModel *viewModel;

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
    self.viewModel=[[CourseViewModel alloc]init];
    __weak typeof(self) weakSelf=self;
    [self.viewModel.updatedContentSignal subscribeNext:^(id x) {
        __strong typeof(self) strongSelf=weakSelf;
        [strongSelf.tableView reloadData];
    }];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    self.viewModel.active=YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:@"courseCell"];
    cell.textLabel.text=[self.viewModel titleAtIndexPath:indexPath];
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel numberOfItemsInSection:0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.viewModel numberOfSections];;
}
@end
