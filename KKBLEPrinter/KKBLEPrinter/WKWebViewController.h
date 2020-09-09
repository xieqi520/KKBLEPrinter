//
//  WKWebViewController.h
//  WKWebViewMessageHandlerDemo
//
//  Created by reborn on 16/9/12.
//  Copyright © 2016年 reborn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface WKWebViewController : UIViewController
@property(nonatomic,strong)CBPeripheral *currentCP;
@end
