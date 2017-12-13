//
//  KRRootViewController.m
//  KRTestLayout
//
//  Created by RK on 2017/12/11.
//  Copyright © 2017年 RK. All rights reserved.
//

#import "KRRootViewController.h"
#import "KREdgesForExtendedLayoutViewController.h"
#import "KRSafeAreaViewController.h"
#import "KRTableViewViewController.h"

@interface KRRootViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSArray *_dataArray;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation KRRootViewController

#pragma mark life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = @[@"edgesForExtendedLayout", @"safeArea", @"safeTableView"];
    
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
    
    if (indexPath.row == 1) {
        KRSafeAreaViewController *vc = [[KRSafeAreaViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row == 2) {
        KRTableViewViewController *vc = [[KRTableViewViewController alloc]init];
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
