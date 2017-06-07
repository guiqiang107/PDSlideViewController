//
//  PDSlideViewController.m
//  Panda
//
//  Created by guiq on 2017/5/28.
//  Copyright © 2017年 com.Xpand. All rights reserved.
//

#import "PDSlideViewController.h"

typedef NS_ENUM(NSInteger, PDSlideShowState) {
    PDSlideShowStateMain, 
    PDSlideShowStateLeft
};

@interface PDSlideViewController ()

/**
 *  添加的滑动手势view
 */
@property(nonatomic,strong) UIView * gestureView;

//向右拖动手势
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *rightGesture;

//向左边拖动手势
@property (nonatomic, strong) UIPanGestureRecognizer *leftGesture;

//单击手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

//显示控制器状态
@property (nonatomic, assign) PDSlideShowState showState;

@end

@implementation PDSlideViewController

#pragma public method
+ (PDSlideViewController *)slideVC{
    UINavigationController *rootNavc = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    PDSlideViewController *slideVC = (PDSlideViewController *)rootNavc.topViewController;
    return slideVC;
}

- (void)showLeftVC{
    if (!_leftVC) {
        return;
    }
    
    if (_showState == PDSlideShowStateLeft) {
        [self hideLeftViewController:YES];
    }else{
        [self showLeftViewController];
    }
}

- (void)hideLeftVC{
    if (_showState == PDSlideShowStateLeft ) {
        [self hideLeftViewController:YES];
    }
}

#pragma mark - viewDidLoad
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUp];
}

- (void)setUp {
    
    self.leftViewWidth = self.view.bounds.size.width * 0.8;
    self.duration = 0.25;
    
    if (self.leftVC)  {
        [self addLeftViewController];
    }
    
    [self addMainViewController];
}

//添加左边控制器
- (void)addLeftViewController {
    
    _leftVC.view.frame = CGRectMake(-_leftViewWidth, 0, _leftViewWidth, self.view.frame.size.height);
    [self.view addSubview:_leftVC.view];
    [self addChildViewController:_leftVC];
}

//添加主控制器
- (void)addMainViewController {
    
    //左滑手势
    _rightGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
    
    //右滑手势
    _rightGesture.edges = UIRectEdgeLeft;
    _leftGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwip:)];
    
    //单击手势
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    
    //最上层添加一层手势层
    _gestureView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _gestureView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _gestureView.alpha = 0;
    
    _homeVC.view.frame = [UIScreen mainScreen].bounds;
    [_homeVC.view addSubview:_gestureView];
    [self.view addSubview:_homeVC.view];
    [self addChildViewController:_homeVC];
    
    [self setupMainViewControllerGesture];
}

#pragma mark - 手势响应方法
- (void)rightSwipe:(UIScreenEdgePanGestureRecognizer *)sender{
    
    //将蒙版手势view移动到最上层
    [_homeVC.view bringSubviewToFront:_gestureView];
    
    CGPoint pt = [sender translationInView:sender.view];
    CGRect mainViewFrame = _homeVC.view.frame;
    mainViewFrame.origin.x += pt.x;
//    NSLog(@"rightSwipe：%.f,%.f,%.f",pt.x,pt.y,_homeVC.view.frame.origin.x);
    if (mainViewFrame.origin.x <= _leftViewWidth && mainViewFrame.origin.x >= 0) {
        
        _homeVC.view.frame = mainViewFrame;
        [self changeOriginX:_leftVC.view addX:pt.x];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (_homeVC.view.frame.origin.x > _leftViewWidth/2.0){
            [self showLeftViewController];
        }else {
            [self hideLeftViewController:YES];
        }
    }
    
    [sender setTranslation:CGPointZero inView:sender.view];
    
}

- (void)leftSwip:(UIPanGestureRecognizer *)sender{
    
    CGPoint pt = [sender translationInView:sender.view];
//    NSLog(@"leftSwip：%.f,%.f,---%.f",pt.x,pt.y,_homeVC.view.frame.origin.x);
    
    CGRect mainViewFrame = _homeVC.view.frame;
    mainViewFrame.origin.x += pt.x;
    
    if (mainViewFrame.origin.x <= _leftViewWidth && mainViewFrame.origin.x > 0) {
        
        _homeVC.view.frame = mainViewFrame;
        [self changeOriginX:_leftVC.view addX:pt.x];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (_homeVC.view.frame.origin.x > _leftViewWidth/2.0){
            [self showLeftViewController];
        } else {
            [self hideLeftViewController:YES];
        }
    }

    [sender setTranslation:CGPointZero inView:sender.view];
}

- (void)tapGesture:(UITapGestureRecognizer *)sender{
    [self hideLeftVC];
}

#pragma mark - private
- (void)changeOriginX:(UIView *)changeView addX:(CGFloat)addX {
    CGRect rect      = changeView.frame;
    rect.origin.x   += addX;
    changeView.frame = rect;
    
    [self setGestureViewAlpha];
}

//主控制器添加手势
- (void)setupMainViewControllerGesture {
    
    if (_showState == PDSlideShowStateMain) {

        [_homeVC.view addGestureRecognizer:_rightGesture];  //主控制器添加右滑显示leftVC手势
        [_gestureView removeGestureRecognizer:_tapGesture];  //蒙层移除点击隐藏leftVC手势
        [_gestureView removeGestureRecognizer:_leftGesture];  //蒙层移除左滑隐藏leftVC手势
        
    }else if (_showState == PDSlideShowStateLeft){
        
        [_gestureView addGestureRecognizer:_leftGesture]; // //蒙层添加左滑隐藏leftVC手势
        [_gestureView addGestureRecognizer:_tapGesture]; //蒙层添加左滑隐藏leftVC手势
        [_homeVC.view removeGestureRecognizer:_rightGesture];  //主控制器移除右滑显示leftVC手势
    }
}

- (void)setGestureViewAlpha{
    CGFloat alpha = _homeVC.view.frame.origin.x/_leftViewWidth;
    _gestureView.alpha = alpha;
}

- (void)showLeftViewController{
    
    CGFloat realDuration = _duration * ABS(_leftVC.view.frame.origin.x / -_leftViewWidth);
    [UIView animateWithDuration:realDuration animations:^{
        CGRect leftFrame    = _leftVC.view.frame;
        leftFrame.origin.x  = 0;
        _leftVC.view.frame  = leftFrame;
        
        CGRect mainFrame    = _homeVC.view.frame;
        mainFrame.origin.x  = _leftViewWidth;
        _homeVC.view.frame  = mainFrame;
        
        mainFrame.origin.x  = self.view.frame.size.width + _leftViewWidth;
        
        [self setGestureViewAlpha];
    }];
    
    _showState = PDSlideShowStateLeft;

    [self setupMainViewControllerGesture];
}

- (void)hideLeftViewController:(BOOL)animate{
    CGFloat realDuration = _duration * ABS((_leftViewWidth + _leftVC.view.frame.origin.x) / _leftViewWidth);
    [UIView animateWithDuration:animate ? realDuration : 0 animations:^{
        CGRect leftFrame    = _leftVC.view.frame;
        leftFrame.origin.x  = -_leftViewWidth;
        _leftVC.view.frame  = leftFrame;
        
        CGRect mainFrame    = _homeVC.view.frame;
        mainFrame.origin.x  = 0;
        _homeVC.view.frame  = mainFrame;
        
        [self setGestureViewAlpha];
    }];
    _showState = PDSlideShowStateMain;
    
    [self setupMainViewControllerGesture];
}

@end
