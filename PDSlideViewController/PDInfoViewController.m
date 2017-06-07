//
//  PDInfoViewController.m
//  Panda
//
//  Created by guiq on 2017/5/28.
//  Copyright © 2017年 com.Xpand. All rights reserved.
//

#import "PDInfoViewController.h"
#import "UIViewController+PDNavigationBar.h"

@interface PDInfoViewController ()

/**
 * scrollView
 */
@property (nonatomic , strong) UIScrollView  *scrollView;
/**
 * 图片数组
 */
@property (nonatomic , strong) NSMutableArray  *images;
/**
 *  url strings
 */
@property (nonatomic , strong) NSArray  *urlStrings;

@end

@implementation PDInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pd_setNavigationBarTitle:@"图片浏览器"];
}




@end
