//
//  WZTabBar.m
//  WZTabBarControllerDemo
//
//  Created by WilliamZhang on 16/4/16.
//  Copyright © 2016年 WilliamZhang. All rights reserved.
//

#import "WZTabBar.h"

@interface WZTabBarButton : UIButton

- (instancetype)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image selectedImage:(nullable UIImage *)selectedImage;

@end

@interface WZTabBar ()

@property (nonatomic ,strong) UIView *wz_selectionIndicatorView;

@property (nonatomic ,strong) NSArray<WZTabBarButton *> *wz_itemsButtons;
@property (nonatomic ,strong) WZTabBarButton *wz_selectedItemButton;

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

- (void)setItems:(NSArray<UITabBarItem *> *)items animated:(BOOL)animated {
    [super setItems:items animated:animated];
    
    for (WZTabBarButton *button in self.wz_itemsButtons) {
        [button removeFromSuperview];
    }
    
    for (UIView *childView in self.subviews) {
        if ([childView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            childView.hidden = YES;
        }
    }
    
    NSInteger tag = 0;
    NSMutableArray *tabBarButtons = [NSMutableArray array];
    for (UITabBarItem *item in items) {
        WZTabBarButton *button = [[WZTabBarButton alloc] initWithTitle:item.title image:item.image selectedImage:item.selectedImage];
        [button addTarget:self action:@selector(clickToSelectItemButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = tag;
    
        [self addSubview:button];
        [tabBarButtons addObject:button];
        tag ++;
    }
    
    self.wz_selectedItemButton = [tabBarButtons firstObject];
    self.wz_itemsButtons = tabBarButtons;
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
    
    NSInteger selectedIndex = 0;
    for (UITabBarItem *item in self.items) {
        if (item == self.selectedItem) {
            break;
        }
        
        selectedIndex ++;
    }
    
    NSInteger buttonIndex = 0;
    CGFloat childViewX = 0;
    for (UIView *childView in self.wz_itemsButtons) {
        //调整UITabBarItem的位置
        CGFloat itemWidth = normalWidth;
        if (selectedIndex == buttonIndex) {
            itemWidth = selectedWidth;
        }
        
        //仅修改childView的x和宽度,yh值不变
        CGRect frame = CGRectMake(childViewX,
                                  0,
                                  itemWidth,
                                  CGRectGetHeight(self.frame)
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

#pragma mark - Button Click
- (void)clickToSelectItemButton:(WZTabBarButton *)sender {
    if (self.wz_selectedItemButton == sender) {
        return;
    }
    
    self.wz_selectedItemButton = sender;
    if ([self.wz_delegate respondsToSelector:@selector(wz_tabBar:didSelectItemAtIndex:)]) {
        [self.wz_delegate wz_tabBar:self didSelectItemAtIndex:sender.tag];
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

- (void)setWz_selectedItemButton:(WZTabBarButton *)wz_selectedItemButton {
    _wz_selectedItemButton.selected = NO;
    _wz_selectedItemButton = wz_selectedItemButton;
    _wz_selectedItemButton.selected = YES;
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

@implementation WZTabBarButton

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        [self setTitle:title forState:UIControlStateNormal];
        
        [self setImage:image forState:UIControlStateNormal];
        
        selectedImage = selectedImage ?: [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self setImage:selectedImage forState:UIControlStateSelected];
        
        [self handleEdgeInsets];
        
//        self.layer.borderWidth = 0.5;
    }
    return self;
}

- (void)handleEdgeInsets {
    [self.imageView setContentMode:UIViewContentModeCenter];
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(-8, 0, 0, -titleSize.width)];
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(self.imageView.image.size.height + 8, -self.imageView.image.size.width, 0, 0)];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.titleLabel.alpha = !selected;
    
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    [self setImageEdgeInsets:UIEdgeInsetsMake(!selected ? -8 : 0, 0, 0, -titleSize.width)];
}

@end
