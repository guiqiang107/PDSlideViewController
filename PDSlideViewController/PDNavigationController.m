//
//  PDNavigationController.m
//  Panda
//
//  Created by guiq on 2017/5/25.
//  Copyright © 2017年 com.Xpand. All rights reserved.
//

#import "PDNavigationController.h"

@interface PDNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation PDNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //添加全屏返回手势
    [self addFullScreenPopGes];
}

/*
 *  添加全屏返回手势,在不需要的页面可以设置interactivePopGestureRecognizer.enabled属性控制
 */
- (void)addFullScreenPopGes{
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.childViewControllers.count > 1 && self.interactivePopGestureRecognizer.enabled) {
        return YES;
    }
    return NO;
}

#pragma mark 控制状态栏的样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
