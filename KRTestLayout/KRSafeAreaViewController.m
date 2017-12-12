//
//  KRSafeAreaViewController.m
//  KRTestLayout
//
//  Created by RK on 2017/12/12.
//  Copyright © 2017年 RK. All rights reserved.
//

#import "KRSafeAreaViewController.h"

@interface KRSafeAreaViewController ()

@end

@implementation KRSafeAreaViewController

#pragma mark life

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    testLabel.text = @"测试";
    testLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:testLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    /**
     * 在iOS 11 iPhone 8 无navgationbar 打印如下
     * 2017-12-12 17:34:37.382000+0800 KRTestLayout[7756:1637921] {20, 0, 0, 0}
     * 2017-12-12 17:34:37.382157+0800 KRTestLayout[7756:1637921] {0, 0, 0, 0}
     *
     * 在iOS 11 iPhone X 无navgationba 打印如下
     * 2017-12-12 17:35:18.205627+0800 KRTestLayout[7801:1646680] {44, 0, 34, 0}
     * 2017-12-12 17:35:18.205811+0800 KRTestLayout[7801:1646680] {0, 0, 0, 0}
     */
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    NSLog(@"%@", NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
    NSLog(@"%@", NSStringFromUIEdgeInsets(self.additionalSafeAreaInsets));
    /**
     * 在iOS 11 iPhone 8 有navgationbar 打印如下
     * 2017-12-12 17:27:34.789117+0800 KRTestLayout[7520:1607431] {64, 0, 0, 0}
     * 2017-12-12 17:27:34.789314+0800 KRTestLayout[7520:1607431] {0, 0, 0, 0}
     *
     * 在iOS 11 iPhone X 有navgationbar 打印如下
     * 2017-12-12 17:30:55.503033+0800 KRTestLayout[7633:1623120] {88, 0, 34, 0}
     *  2017-12-12 17:30:55.503169+0800 KRTestLayout[7633:1623120] {0, 0, 0, 0}
     */
}


@end
