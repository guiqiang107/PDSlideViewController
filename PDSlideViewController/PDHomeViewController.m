//
//  PDHomeViewController.m
//  Panda
//
//  Created by guiq on 2017/5/25.
//  Copyright © 2017年 com.Xpand. All rights reserved.
//  侧滑主控制器

#import "PDHomeViewController.h"
#import "PDInfoViewController.h"
#import "PDSlideViewController.h"
#import "PDLeftViewController.h"
#import "UIViewController+PDNavigationBar.h"

@interface PDHomeViewController ()


@end

@implementation PDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1、设置导航栏
    [self pd_setNavigationBarTitle:@"首页" leftIcon:@"messagePersonal" leftHandle:^{
        
        [[PDSlideViewController slideVC] showLeftVC];
    } rightIcon:@"messageActive" rightHandle:^{
        
        PDInfoViewController *vc = [[PDInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}

@end
