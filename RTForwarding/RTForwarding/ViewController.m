//
//  ViewController.m
//  RTForwarding
//
//  Created by wbx_iMac on 2017/12/7.
//  Copyright © 2017年 DaverZhou. All rights reserved.
//

#import "ViewController.h"

#import "UIScrollView+RTForwarding.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    
    CGSize main = [UIScreen mainScreen].bounds.size;
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, main.width, main.height - 64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor orangeColor];
    tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:tableView];
    

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tableID = @"tableID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tableID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableID];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

@end
