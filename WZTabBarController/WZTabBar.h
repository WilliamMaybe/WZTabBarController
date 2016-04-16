//
//  WZTabBar.h
//  WZTabBarControllerDemo
//
//  Created by WilliamZhang on 16/4/16.
//  Copyright © 2016年 WilliamZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZTabBar : UITabBar

/* The selection indicator image is drawn on top of the tab bar, behind the bar item icon.
 */
@property(nullable, nonatomic, strong) UIImage *wz_selectionIndicatorImage;

/**
 *  选中的按钮比未选中按钮宽度的倍数 default = 1.2
 */
@property (nonatomic ,assign) CGFloat wz_multiplySelectedWidth;

@end
