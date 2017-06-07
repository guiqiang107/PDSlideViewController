//
//  UIViewController+PDNavigationBar.h
//  Panda
//
//  Created by guiq on 2017/5/28.
//  Copyright © 2017年 com.Xpand. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PDCallBack)();

@interface UIViewController (PDNavigationBar)

//自定义navigationBar
@property(nonatomic, strong) UIView *navigationBar;

//标题
@property(nonatomic, strong) UIButton *middleButton;

//返回按钮
@property(nonatomic, strong) UIButton *leftButton;

//左边按钮点击回调
@property(nonatomic, strong) PDCallBack leftHandle;

//右边按钮
@property(nonatomic, strong) UIButton *rightButton;

//右边按钮点击回调
@property(nonatomic, strong) PDCallBack rightHandle;

/*
 *  创建只有标题的NavigationBar
 */
- (void)pd_setNavigationBarTitle:(NSString *)title;

/*
 *  用图标创建自定义NavigationBar,不需要的控件传nil
 */
- (void)pd_setNavigationBarTitle:(NSString *)title leftIcon:(NSString *)leftIcon leftHandle:(PDCallBack)leftHandle rightIcon:(NSString *)rightIcon rightHandle:(PDCallBack)rightHandle;

/*
 *  用标题创建自定义NavigationBar,不需要的控件传nil
 */
- (void)pd_setNavigationBarTitle:(NSString *)title leftTitle:(NSString *)leftTitle leftHandle:(PDCallBack)leftHandle rightTitle:(NSString *)rightTitle rightHandle:(PDCallBack)rightHandle;

@end
