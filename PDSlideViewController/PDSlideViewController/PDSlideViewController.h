//
//  PDSlideViewController.h
//  Panda
//
//  Created by guiq on 2017/5/28.
//  Copyright © 2017年 com.Xpand. All rights reserved.
//  侧滑控制器

#import <UIKit/UIKit.h>

@interface PDSlideViewController : UIViewController

@property(nonatomic,strong) UIViewController *leftVC;
@property(nonatomic,strong) UIViewController * homeVC;

/**
 *  默认屏幕宽度*0.8
 */
@property(nonatomic,assign) CGFloat leftViewWidth;

+ (PDSlideViewController *)slideVC;

- (void)showLeftVC;

- (void)hideLeftVC;

@end
