//
//  UIViewController+PDNavigationBar.m
//  Panda
//
//  Created by guiq on 2017/5/28.
//  Copyright © 2017年 com.Xpand. All rights reserved.
//

#import "UIViewController+PDNavigationBar.h"
#import <objc/runtime.h>

@implementation UIViewController (PDNavigationBar)

- (void)pd_setNavigationBarTitle:(NSString *)title
{
    [self setNavigationBarTitle:title leftIcon:nil leftTitle:nil leftHandle:nil rightIcon:nil rightTitle:nil rightHandle:nil];
}

- (void)pd_setNavigationBarTitle:(NSString *)title leftIcon:(NSString *)leftIcon leftHandle:(PDCallBack)leftHandle rightIcon:(NSString *)rightIcon rightHandle:(PDCallBack)rightHandle
{
     [self setNavigationBarTitle:title leftIcon:leftIcon leftTitle:nil leftHandle:leftHandle rightIcon:rightIcon rightTitle:nil rightHandle:rightHandle];
}

- (void)pd_setNavigationBarTitle:(NSString *)title leftTitle:(NSString *)leftTitle leftHandle:(PDCallBack)leftHandle rightTitle:(NSString *)rightTitle rightHandle:(PDCallBack)rightHandle;
{
    [self setNavigationBarTitle:title leftIcon:nil leftTitle:leftTitle leftHandle:leftHandle rightIcon:nil rightTitle:rightTitle rightHandle:rightHandle];
}

- (void)setNavigationBarTitle:(NSString *)title leftIcon:(NSString *)leftIcon leftTitle:(NSString *)leftTitle leftHandle:(PDCallBack)leftHandle rightIcon:(NSString *)rightIcon rightTitle:(NSString *)rightTitle rightHandle:(PDCallBack)rightHandle{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.navigationController && self.navigationController.navigationBar) {
        [self.navigationController.navigationBar removeFromSuperview];
    }
    
    if (self.navigationBar != nil) {
        [self.navigationBar removeFromSuperview];
    }
    
    // 自定义UIView代替导航栏
    self.navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    self.navigationBar.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.navigationBar];
    
    
    //返回按钮
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 100, 44)];
    [self.leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.leftButton setAdjustsImageWhenHighlighted:NO];
    self.leftButton.contentMode = UIViewContentModeLeft;
    self.leftButton.hidden = YES;
    [self.navigationBar addSubview:self.leftButton];
    
    if (self.navigationController.viewControllers.count > 1) {
        self.leftButton.hidden = NO;
    }
    
    if (leftIcon) {
        UIImage *leftImage = [UIImage imageNamed:leftIcon];
        [self.leftButton setImage:leftImage forState:UIControlStateNormal];
        self.leftButton.imageEdgeInsets = UIEdgeInsetsMake(5, 16, 0, self.leftButton.frame.size.width - leftImage.size.width - 16);
        self.leftButton.hidden = NO;
    }
    else if(leftTitle){
        [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
        [self.leftButton.titleLabel sizeToFit];
        self.leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, self.leftButton.frame.size.width - self.leftButton.titleLabel.bounds.size.width-16, 0, 16);
        self.leftButton.hidden = NO;
    }else{
        UIImage *backImage = [UIImage imageNamed:@"ic_back"];
        [self.leftButton setImage:backImage forState:UIControlStateNormal];
        self.leftButton.imageEdgeInsets = UIEdgeInsetsMake(5, 16, 0, self.leftButton.frame.size.width - backImage.size.width - 16);
    }
    
    //标题
    self.middleButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 20, [UIScreen mainScreen].bounds.size.width-200, 44)];
    self.middleButton.contentMode = UIViewContentModeCenter;
    [self.middleButton setTitle:title forState:UIControlStateNormal];
    self.middleButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [self.navigationBar addSubview:self.middleButton];
    
    //右边按钮
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-100, 20, 100, 44)];
    self.rightButton.contentMode = UIViewContentModeRight;
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
//    [self.rightButton setAdjustsImageWhenHighlighted:NO];
    [self.rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:self.rightButton];
    
    if (rightIcon) {
        UIImage *rightImage = [UIImage imageNamed:rightIcon];
        [self.rightButton setImage:rightImage forState:UIControlStateNormal];
        self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(5, self.rightButton.frame.size.width - rightImage.size.width - 16, 0, 16);
    }
    else if(rightTitle){
        [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
        [self.rightButton.titleLabel sizeToFit];
        self.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, self.rightButton.frame.size.width - self.rightButton.titleLabel.bounds.size.width-16, 0, 16);
    }
    
    self.leftHandle = leftHandle;
    self.rightHandle = rightHandle;
    
    //    self.leftButton.backgroundColor = [UIColor orangeColor];
    //    self.middleButton.backgroundColor = [UIColor blueColor];
    //    self.rightButton.backgroundColor = [UIColor purpleColor];
}

- (void)leftButtonClicked {
    if (self.leftHandle) {
        self.leftHandle();
    }else{
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)rightButtonClicked{
    if (self.rightHandle) {
        self.rightHandle();
    }
}

#pragma mark - 运行时关联属性
- (void)setNavigationBar:(UIView *)navigationBar {
    objc_setAssociatedObject(self,
                             @"pd_navigationBar",
                             navigationBar,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)navigationBar {
    return objc_getAssociatedObject(self, @"pd_navigationBar");
}

- (void)setMiddleButton:(UIButton *)middleButton {
    objc_setAssociatedObject(self,
                             @"pd_middleButton",
                             middleButton,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (UIButton *)middleButton {
    return objc_getAssociatedObject(self, @"pd_middleButton");
}

- (void)setLeftButton:(UIButton *)leftButton {
    objc_setAssociatedObject(self,
                             @"pd_leftButton",
                             leftButton,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)leftButton {
    return objc_getAssociatedObject(self, @"pd_leftButton");
}

- (void)setRightButton:(UIButton *)rightButton {
    objc_setAssociatedObject(self,
                             @"pd_rightButton",
                             rightButton,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)rightButton {
    return objc_getAssociatedObject(self, @"pd_rightButton");
}

- (void)setLeftHandle:(PDCallBack)leftHandle{
     objc_setAssociatedObject(self, @"pd_leftHandle", leftHandle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (PDCallBack)leftHandle{
    return objc_getAssociatedObject(self, @"pd_leftHandle");
}

- (void)setRightHandle:(PDCallBack)rightHandle{
    objc_setAssociatedObject(self, @"pd_rightHandle", rightHandle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (PDCallBack)rightHandle{
    return objc_getAssociatedObject(self, @"pd_rightHandle");
}

@end
