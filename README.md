# PDSlideViewController
仿qq侧滑菜单


    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [window makeKeyAndVisible];
    self.window = window;
    
    //侧滑控制器
    PDSlideViewController *slideVC = [[PDSlideViewController alloc] init];
    //左滑控制器
    slideVC.leftVC = [[PDLeftViewController alloc] init];
    //主控制器
    slideVC.homeVC = [[PDHomeViewController alloc] init];
    PDNavigationController *navc = [[PDNavigationController alloc] initWithRootViewController:slideVC];
    slideVC.navigationController.navigationBarHidden = YES;
    window.rootViewController = navc;
![screenShot](https://github.com/guiqiang107/PDSlideViewController/raw/master/PDSlideViewControllerGif.gif)
