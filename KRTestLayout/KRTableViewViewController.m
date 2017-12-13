//
//  KRSafeAreaTableViewViewController.m
//  KRTestLayout
//
//  Created by RK on 2017/12/12.
//  Copyright © 2017年 RK. All rights reserved.
//

#import "KRTableViewViewController.h"

@interface KRTableViewViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSArray *_dataArray;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation KRTableViewViewController

#pragma mark life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = @[@"1", @"2", @"2", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14"];
    
    [self.view addSubview:self.tableView];
    
    [self registerTableViewCell];
    
//    [self testAdjustContentInsetAutomatic];
//    [self testAdjustContentInsetScrollableAxes];
//    [self testAdjustContentInsetNever];
    [self testAdjustContentInsetAlways];
    
//    NSLog(@"------------viewDidLoad---------------");
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
//    NSLog(@"-----------viewWillLayoutSubviews----------------");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    NSLog(@"-----------viewDidLayoutSubviews----------------");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    NSLog(@"----------viewWillAppear-----------------");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NSLog(@"----------viewDidAppear-----------------");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];

//    NSLog(@"-----------viewWillDisappear----------------");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    NSLog(@"----------viewDidDisappear-----------------");
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
//    NSLog(@"----------viewSafeAreaInsetsDidChange-----------------");
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    NSLog(@"contentInset-> %@", NSStringFromUIEdgeInsets(self.tableView.contentInset));

    if (@available(iOS 11.0, *)) {
        NSLog(@"safeAreaInsets-> %@", NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
        NSLog(@"additionalSafeAreaInsets-> %@", NSStringFromUIEdgeInsets(self.additionalSafeAreaInsets));
        NSLog(@"adjustedContentInset-> %@", NSStringFromUIEdgeInsets(self.tableView.adjustedContentInset));
    }
    NSLog(@"----------------------------------");
}

#pragma mark adjustedContentInset 测试

- (void)testAdjustContentInsetAutomatic {
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        
        self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
//        2017-12-13 16:21:09.759001+0800 KRTestLayout[6338:1032624] contentInset-> {60, 0, 0, 0}
//        2017-12-13 16:21:09.759123+0800 KRTestLayout[6338:1032624] safeAreaInsets-> {64, 0, 0, 0}
//        2017-12-13 16:21:09.759214+0800 KRTestLayout[6338:1032624] additionalSafeAreaInsets-> {0, 0, 0, 0}
//        2017-12-13 16:21:09.759306+0800 KRTestLayout[6338:1032624] adjustedContentInset-> {124, 0, 0, 0}
        
        self.additionalSafeAreaInsets =  UIEdgeInsetsMake(120, 0, 0, 0);
//        2017-12-13 16:22:20.659263+0800 KRTestLayout[6368:1037697] contentInset-> {60, 0, 0, 0}
//        2017-12-13 16:22:20.659419+0800 KRTestLayout[6368:1037697] safeAreaInsets-> {184, 0, 0, 0}
//        2017-12-13 16:22:20.659537+0800 KRTestLayout[6368:1037697] additionalSafeAreaInsets-> {120, 0, 0, 0}
//        2017-12-13 16:22:20.659649+0800 KRTestLayout[6368:1037697] adjustedContentInset-> {244, 0, 0, 0}
    }
}

- (void)testAdjustContentInsetScrollableAxes {
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentScrollableAxes;
        
        self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
//        2017-12-13 16:30:01.264643+0800 KRTestLayout[6507:1064131] contentInset-> {60, 0, 0, 0}
//        2017-12-13 16:30:01.264804+0800 KRTestLayout[6507:1064131] safeAreaInsets-> {64, 0, 0, 0}
//        2017-12-13 16:30:01.264890+0800 KRTestLayout[6507:1064131] additionalSafeAreaInsets-> {0, 0, 0, 0}
//        2017-12-13 16:30:01.264983+0800 KRTestLayout[6507:1064131] adjustedContentInset-> {124, 0, 0, 0}
        
        self.tableView.scrollEnabled = NO;
//        2017-12-13 16:30:47.083295+0800 KRTestLayout[6539:1067398] contentInset-> {60, 0, 0, 0}
//        2017-12-13 16:30:47.083438+0800 KRTestLayout[6539:1067398] safeAreaInsets-> {0, 0, 0, 0}
//        2017-12-13 16:30:47.083549+0800 KRTestLayout[6539:1067398] additionalSafeAreaInsets-> {0, 0, 0, 0}
//        2017-12-13 16:30:47.083636+0800 KRTestLayout[6539:1067398] adjustedContentInset-> {60, 0, 0, 0}
    }
}

- (void)testAdjustContentInsetNever {
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
        
//        2017-12-13 16:33:20.537079+0800 KRTestLayout[6618:1080094] contentInset-> {60, 0, 0, 0}
//        2017-12-13 16:33:20.537246+0800 KRTestLayout[6618:1080094] safeAreaInsets-> {0, 0, 0, 0}
//        2017-12-13 16:33:20.537390+0800 KRTestLayout[6618:1080094] additionalSafeAreaInsets-> {0, 0, 0, 0}
//        2017-12-13 16:33:20.537490+0800 KRTestLayout[6618:1080094] adjustedContentInset-> {60, 0, 0, 0}
    }
}

- (void)testAdjustContentInsetAlways {
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
        self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
        
//        2017-12-13 16:35:05.990422+0800 KRTestLayout[6666:1088653] contentInset-> {60, 0, 0, 0}
//        2017-12-13 16:35:05.990543+0800 KRTestLayout[6666:1088653] safeAreaInsets-> {64, 0, 0, 0}
//        2017-12-13 16:35:05.990670+0800 KRTestLayout[6666:1088653] additionalSafeAreaInsets-> {0, 0, 0, 0}
//        2017-12-13 16:35:05.990771+0800 KRTestLayout[6666:1088653] adjustedContentInset-> {124, 0, 0, 0}
    }
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
