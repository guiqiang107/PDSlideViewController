//
//  PDLeftViewController.m
//  Panda
//
//  Created by guiq on 2017/5/28.
//  Copyright © 2017年 com.Xpand. All rights reserved.
//  侧滑左侧控制器

#import "PDLeftViewController.h"
#import "PDInfoViewController.h"
#import "PDSlideViewController.h"
@interface PDLeftViewController ()

@end

@implementation PDLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor purpleColor];
    [btn setTitle:@"click" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 100, 200, 80);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)btnClick{
    
    [[PDSlideViewController slideVC] hideLeftVC];
    PDInfoViewController *vc = [[PDInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
