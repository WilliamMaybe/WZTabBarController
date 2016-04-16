//
//  WZTabBarController.m
//  WZTabBarControllerDemo
//
//  Created by WilliamZhang on 16/4/16.
//  Copyright © 2016年 WilliamZhang. All rights reserved.
//

#import "WZTabBarController.h"
#import "WZTabBar.h"

@interface WZTabBarController ()

@property (nonatomic ,readonly) WZTabBar *wz_tabBar;

@end

@implementation WZTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 替换tabBar
    [self setValue:[[WZTabBar alloc] init] forKey:@"tabBar"];
    self.wz_tabBar.wz_multiplySelectedWidth = 1.2;
}

#pragma mark - Set
- (void)setWz_multiplySelectedWidth:(CGFloat)wz_multiplySelectedWidth {
    self.wz_tabBar.wz_multiplySelectedWidth = wz_multiplySelectedWidth;
}

- (void)setWz_selectionIndicatorImage:(UIImage *)wz_selectionIndicatorImage {
    self.wz_tabBar.wz_selectionIndicatorImage = wz_selectionIndicatorImage;
}

#pragma mark - Get
- (CGFloat)wz_multiplySelectedWidth { return self.wz_tabBar.wz_multiplySelectedWidth; }
- (UIImage *)wz_selectionIndicatorImage { return self.wz_tabBar.wz_selectionIndicatorImage; }



#pragma mark - Private Method
- (WZTabBar *)wz_tabBar {
    return (WZTabBar *)self.tabBar;
}

@end
