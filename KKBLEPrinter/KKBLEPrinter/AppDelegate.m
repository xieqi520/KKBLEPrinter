//
//  AppDelegate.m
//  KKBLEPrinter
//
//  Created by 谢齐 on 2020/8/27.
//  Copyright © 2020 谢齐. All rights reserved.
//

#import "AppDelegate.h"
#import "WKWebViewController.h"
#import "KKSearchBLEVC.h"
#import "WKWebViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    WKWebViewController *vc = [[WKWebViewController alloc]init];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//   WKWebViewController *vc = [[WKWebViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}



@end
