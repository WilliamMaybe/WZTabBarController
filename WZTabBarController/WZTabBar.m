//
//  WZTabBar.m
//  WZTabBarControllerDemo
//
//  Created by WilliamZhang on 16/4/16.
//  Copyright © 2016年 WilliamZhang. All rights reserved.
//

#import "WZTabBar.h"

@interface WZTabBar ()

@property (nonatomic ,strong) UIView *wz_selectionIndicatorView;

@end

@implementation WZTabBar

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.wz_selectionIndicatorView];
        [self addObserver:self forKeyPath:@"selectedItem" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"selectedItem"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 计算宽度
    CGFloat normalWidth = CGRectGetWidth(self.frame);
    CGFloat selectedWidth = normalWidth;
    
    NSUInteger itemsCount = [self.items count];
    
    if (itemsCount > 1) {
        normalWidth = normalWidth / (itemsCount - 1 + self.wz_multiplySelectedWidth);
        selectedWidth = normalWidth * self.wz_multiplySelectedWidth;
    }
    
    /* NOTE: If the `self.title of ViewController` and `the correct title of tabBarItemsAttributes` are different, Apple will delete the correct tabBarItem from subViews, and then trigger `-layoutSubviews`, therefore subViews will be in disorder. So we need to rearrange them.*/
    NSArray *sortedSubviews = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(UIView * view1, UIView * view2) {
        CGFloat view1_x = view1.frame.origin.x;
        CGFloat view2_x = view2.frame.origin.x;
        if (view1_x > view2_x) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    NSInteger selectedIndex = 0;
    for (UITabBarItem *item in self.items) {
        if (item == self.selectedItem) {
            break;
        }
        
        selectedIndex ++;
    }
    
    NSInteger buttonIndex = 0;
    CGFloat childViewX = 0;
    for (UIView *childView in sortedSubviews) {
        //调整UITabBarItem的位置
        if ([childView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            CGFloat itemWidth = normalWidth;
            if (selectedIndex == buttonIndex) {
                itemWidth = selectedWidth;
            }
            
            //仅修改childView的x和宽度,yh值不变
            CGRect frame = CGRectMake(childViewX,
                                      CGRectGetMinY(childView.frame),
                                      selectedWidth,
                                      CGRectGetHeight(childView.frame)
                                      );
            childView.frame = frame;
            
            if (selectedIndex == buttonIndex) {
                // TabBarButton的originY=1
                frame.origin.y = 0;
                frame.size.height += 1;
                self.wz_selectionIndicatorView.frame = frame;
            }
            
            childViewX += itemWidth;
            buttonIndex++;
        }
    }
    
    UITabBarItem *selectedItem = self.selectedItem;
    for (UITabBarItem *item in self.items) {
        if (item == selectedItem) {
            
        }
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedItem"]) {
        [self setNeedsLayout];
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

#pragma mark - Setter
- (void)setWz_selectionIndicatorImage:(UIImage *)wz_selectionIndicatorImage {
    _wz_selectionIndicatorImage = wz_selectionIndicatorImage;
    self.wz_selectionIndicatorView.backgroundColor = [UIColor colorWithPatternImage:wz_selectionIndicatorImage];
}

#pragma mark - Initializer
- (UIView *)wz_selectionIndicatorView {
    if (!_wz_selectionIndicatorView) {
        _wz_selectionIndicatorView = [UIView new];
        _wz_selectionIndicatorView.backgroundColor = [UIColor redColor];
    }
    return _wz_selectionIndicatorView;
}

@end
