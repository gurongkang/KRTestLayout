//
//  KREdgesForExtendedLayoutViewController.m
//  KRTestLayout
//
//  Created by RK on 2017/12/11.
//  Copyright © 2017年 RK. All rights reserved.
//

#import "KREdgesForExtendedLayoutViewController.h"

@interface KREdgesForExtendedLayoutViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSArray *_dataArray;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation KREdgesForExtendedLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //automaticallyAdjustsScrollViewInsets 为YES edgesForExtendedLayout这个属性没啥影响
//    self.automaticallyAdjustsScrollViewInsets = YES;
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    //automaticallyAdjustsScrollViewInsets 为NO edgesForExtendedLayout
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    _dataArray = @[@"1", @"2", @"2", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14"];
    
    [self.view addSubview:self.tableView];
    
    [self registerTableViewCell];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"kTestlayoutCell" forIndexPath:indexPath];
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.contentView.backgroundColor = [UIColor blueColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        KREdgesForExtendedLayoutViewController *vc = [[KREdgesForExtendedLayoutViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark tableView

- (void)registerTableViewCell {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kTestlayoutCell"];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
    }
    
    return _tableView;
}

@end
