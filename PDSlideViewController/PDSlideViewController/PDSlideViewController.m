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
    
    if (self.leftVC)  {
        [self addLeftViewController];
    }
    
    [self addMainViewController];
}

//添加左边控制器
- (void)addLeftViewController {
    
    [self.view addSubview:_leftVC.view];
    [self addChildViewController:_leftVC];
    
    [self updateLeftMenuFrame];
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
    _gestureView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
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
    
    [self handlePanGes:sender];
}

- (void)leftSwip:(UIPanGestureRecognizer *)sender{
    [self handlePanGes:sender];
}

- (void)handlePanGes:(UIPanGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint pt = [sender translationInView:sender.view];
        CGRect mainViewFrame = _homeVC.view.frame;
        mainViewFrame.origin.x += pt.x;
        if (mainViewFrame.origin.x <= _leftViewWidth && mainViewFrame.origin.x >= 0) {
            
            _homeVC.view.frame = mainViewFrame;
            
            [self updateLeftMenuFrame];
            
            [self setGestureViewAlpha];
        }
    }
    
    else if (sender.state == UIGestureRecognizerStateEnded) {
        if (_homeVC.view.frame.origin.x > _leftViewWidth/2.0){
            [self showLeftViewController];
        }else {
            [self hideLeftViewController:YES];
        }
    }
    
    [sender setTranslation:CGPointZero inView:sender.view];
}

//更新左侧菜单位置
-(void)updateLeftMenuFrame{
    _leftVC.view.center = CGPointMake((CGRectGetMinX(_homeVC.view.frame) + (self.view.bounds.size.width - self.leftViewWidth))/2, _leftVC.view.center.y);
}

- (void)tapGesture:(UITapGestureRecognizer *)sender{
    [self hideLeftVC];
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
    
    [UIView animateWithDuration:0.25 animations:^{
        _homeVC.view.center = CGPointMake(_homeVC.view.bounds.size.width/2 + self.leftViewWidth, _homeVC.view.center.y);
        
        _leftVC.view.frame = self.view.bounds;
        
        [self setGestureViewAlpha];
    }];
    
    _showState = PDSlideShowStateLeft;

    [self setupMainViewControllerGesture];
}

- (void)hideLeftViewController:(BOOL)animate{

    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = _homeVC.view.frame;
        frame.origin.x = 0;
        _homeVC.view.frame = frame;
        
        [self updateLeftMenuFrame];
        
        [self setGestureViewAlpha];
    }];
    
    _showState = PDSlideShowStateMain;
    
    [self setupMainViewControllerGesture];
}

@end
