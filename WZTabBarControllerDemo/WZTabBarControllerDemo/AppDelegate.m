//
//  AppDelegate.m
//  WZTabBarControllerDemo
//
//  Created by WilliamZhang on 16/4/16.
//  Copyright © 2016年 WilliamZhang. All rights reserved.
//

#import "AppDelegate.h"
#import "WZTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    self.window.rootViewController = [self tabBarController];
    [self tabBarController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (WZTabBarController *)tabBarController {
    WZTabBarController *tabBarController = [[WZTabBarController alloc] init];
    
    UIViewController *vc1 = [self randomViewController];
    UIViewController *vc2 = [self randomViewController];
    UIViewController *vc3 = [self randomViewController];
    UIViewController *vc4 = [self randomViewController];
    
    [self setUpViewController:vc1 withTitle:@"控制器1" imageName:@"tabBar_1" selectedImageName:@"tabBar_1_select"];
    [self setUpViewController:vc2 withTitle:@"控制器2" imageName:@"tabBar_2" selectedImageName:@"tabBar_2_select"];
    [self setUpViewController:vc3 withTitle:@"控制器3" imageName:@"tabBar_3" selectedImageName:@"tabBar_3_select"];
    [self setUpViewController:vc4 withTitle:@"控制器4" imageName:@"tabBar_4" selectedImageName:@"tabBar_4_select"];
    
    tabBarController.viewControllers = @[vc1, vc2, vc3, vc4];
    
    return tabBarController;
}

- (UIViewController *)randomViewController {
    UIViewController *controller = [[UIViewController alloc] init];
    
    controller.view.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0
                                                      green:arc4random() % 255 / 255.0
                                                       blue:arc4random() % 255 / 255.0
                                                      alpha:1];
    
    return controller;
}

- (void)setUpViewController:(UIViewController *)viewController
                  withTitle:(NSString *)title
                  imageName:(NSString *)imageName
          selectedImageName:(NSString *)selectedImageName
{
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
