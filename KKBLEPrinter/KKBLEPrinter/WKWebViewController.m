//
//  WKWebViewController.m
//  WKWebViewMessageHandlerDemo
//
//  Created by reborn on 16/9/12.
//  Copyright © 2016年 reborn. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SEPrinterManager.h"
#import "SVProgressHUD.h"
#import "SafeObject.h"
#import "BLESelectPopView.h"
#import "GKCover.h"
static NSString *obj_print= @"bluetoothPrinting";

@interface WKWebViewController ()<WKUIDelegate,WKScriptMessageHandler,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *imagePickerController;
}
@property(nonatomic, strong)WKWebView *webView;
@property(nonatomic,strong)HLPrinter *webPrinter;
@property(nonatomic,strong)NSString *cpName;

@end

@implementation WKWebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (![[SEPrinterManager sharedInstance]isOpen]) {
//            [SVProgressHUD showErrorWithStatus:@"请打开蓝牙"];
//        }
//    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    SEPrinterManager *_manager = [SEPrinterManager sharedInstance];
    [_manager isConnected];
    
    self.title = @"4D Lucky Win";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initWKWebView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)];
    
}
-(void)reload{
    [self.webView reload];
}

- (void)initWKWebView
{

    //创建并配置WKWebView的相关参数
    //1.WKWebViewConfiguration:是WKWebView初始化时的配置类，里面存放着初始化WK的一系列属性；
    //2.WKUserContentController:为JS提供了一个发送消息的通道并且可以向页面注入JS的类，WKUserContentController对象可以添加多个scriptMessageHandler；
    //3.addScriptMessageHandler:name:有两个参数，第一个参数是userContentController的代理对象，第二个参数是JS里发送postMessage的对象。添加一个脚本消息的处理器,同时需要在JS中添加，window.webkit.messageHandlers.<name>.postMessage(<messageBody>)才能起作用。
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    
    [userContentController addScriptMessageHandler:self name:obj_print];
    
    configuration.userContentController = userContentController;
    
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
//    preferences.minimumFontSize = 40.0;
    configuration.preferences = preferences;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    
    //loadFileURL方法通常用于加载服务器的HTML页面或者JS，而loadHTMLString通常用于加载本地HTML或者JS
    
//    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"abcTest" ofType:@"html"];
//    NSString *fileURL = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
//    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
//    [self.webView loadHTMLString:fileURL baseURL:baseURL];
    
//    http://m.4dluckywin.com
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.4dluckywin.com"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10]];
    
    
    self.webView.UIDelegate = self;
    
    [self.view addSubview:self.webView];
}

#pragma mark - WKUIDelegate

#pragma mark -- WKUIDelegate
// 显示一个按钮。点击后调用completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
 
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
 
// 显示两个按钮，通过completionHandler回调判断用户点击的确定还是取消按钮
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(NO);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
 
// 显示一个带有输入框和一个确定按钮的，通过completionHandler回调用户输入的内容
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(alertController.textFields.lastObject.text);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark -- WKScriptMessageHandler
/**
 *  JS 调用 OC 时 webview 会调用此方法
 *
 *  @param userContentController  webview中配置的userContentController 信息
 *  @param message                JS执行传递的消息
 */

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //JS调用OC方法
    
    //message.boby就是JS里传过来的参数
    NSLog(@"body:%@",message.body);
    if ([message.name isEqualToString:obj_print]){
        [self printBLE:message.body];
    }
    
}

- (HLPrinter *)webPrinter{
    if (!_webPrinter) {
        _webPrinter = [[HLPrinter alloc]init];
    }
    return _webPrinter;
}


-(void)initWithBLE{
     self.cpName = @"MPT-II";
    [self connectCP];
}
/**
 type = 1 添加单行标题
 appendText:(NSString *)text alignment:(HLTextAlignment)alignment
 type = 2 添加单行标题
appendText:(NSString *)text alignment:(HLTextAlignment)alignment fontSize:(HLFontSize)fontSize
 type = 3 添加单行信息，左边名称(左对齐)，右边实际值（右对齐）,默认字号是小号。
appendTitle:(NSString *)title value:(NSString *)value
 type = 4 设置单行信息，左标题，右实际值
添加单行标题,默认字号是小号字体 appendTitle:(NSString *)title value:(NSString *)value fontSize:(HLFontSize)fontSize
 type = 5 设置单行信息，左标题，右实际值
 appendTitle:(NSString *)title value:(NSString *)value valueOffset:(NSInteger)offset fontSize:(HLFontSize)fontSize
 type = 6 添加选购商品信息标题,一般是三列，名称、数量、单价
 appendLeftText:(NSString *)left middleText:(NSString *)middle rightText:(NSString *)right isTitle:(BOOL)isTitle
 type = 7 添加图片
 appendImage:(UIImage *)image alignment:(HLTextAlignment)alignment maxWidth:(CGFloat)maxWidth
 type = 8 添加条形码
appendBarCodeWithInfo:(NSString *)info
 type = 9 添加条形码
appendBarCodeWithInfo:(NSString *)info alignment:(HLTextAlignment)alignment maxWidth:(CGFloat)maxWidth
 type = 10 添加二维码
appendQRCodeWithInfo:(NSString *)info size:(NSInteger)size

 type = 11 添加二维码
appendQRCodeWithInfo:(NSString *)info size:(NSInteger)size alignment:(HLTextAlignment)alignment
 type = 12
appendQRCodeWithInfo:(NSString *)info centerImage:(UIImage *)centerImage alignment:(HLTextAlignment)alignment maxWidth:(CGFloat )maxWidth
 type = 13 添加分割线
appendSeperatorLine
 type = 14 添加尾部
appendFooter:(NSString *)footerInfo
 type = 15 开始打印
getFinalData
 type = 16 初始化数据
 
 type = 17 设置蓝牙过滤的名字
 cpName
*/


-(void)printBLE:(id)obj{
    
    if ([[SEPrinterManager sharedInstance]isOpen] == NO) {
        [SVProgressHUD showErrorWithStatus:@"请打开手机的蓝牙"];
        return;
    }
    
    __weak typeof(self) weakself = self;
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *txt = obj;
         NSLog(@"%@",txt);
         [self.webPrinter appendText:txt alignment:HLTextAlignmentLeft];
         [self.webPrinter appendNewLine];
         [self.webPrinter appendSeperatorLine];
         [self.webPrinter appendNewLine];
        NSData *mainData = [self.webPrinter getFinalData];
        if ([[SEPrinterManager sharedInstance]connectedPerpheral] != nil) {
            [[SEPrinterManager sharedInstance] sendPrintData:mainData completion:^(CBPeripheral *connectPerpheral, BOOL completion, NSString *error) {
                    if (completion) {
                        weakself.webPrinter = [[HLPrinter alloc]init];
                        [SVProgressHUD showSuccessWithStatus:@"打印成功"];
                    }
                    NSLog(@"写入结：%d---错误:%@",completion,error);
            }];
        }else{
            BLESelectPopView *popView = [[BLESelectPopView alloc]initWithFrame:CGRectMake(30, 0,self.view.bounds.size.width - 60, 300)];
            popView.sendData = mainData;
                popView.block = ^(CBPeripheral * _Nullable perpheral) {
                    [GKCover hideCover];
                    weakself.webPrinter = [[HLPrinter alloc]init];
            };
            [GKCover coverFrom:self.view contentView:popView style:GKCoverStyleTranslucent showStyle:GKCoverShowStyleCenter showAnimStyle:GKCoverShowAnimStyleCenter hideAnimStyle:GKCoverHideAnimStyleCenter notClick:NO];
            return;
        }
        
        
       
    }
    
    
    
//    __weak typeof(self) weakself = self;
//    if (self.currentCP == nil) {
//        BLESelectPopView *popView = [[BLESelectPopView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width - 60, 300)];
        
//        popView.block = ^(CBPeripheral *perpheral) {
//            weakself.currentCP = perpheral;
//            weakself.webPrinter = [[HLPrinter alloc]init];
//            [weakself printBLE:obj];
//        };
//        [GKCover coverFrom:self.view contentView:popView style:GKCoverStyleTranslucent showStyle:GKCoverShowStyleCenter showAnimStyle:GKCoverShowAnimStyleCenter hideAnimStyle:GKCoverHideAnimStyleCenter notClick:NO];
//        return;
//    }
    
//    if ([[SEPrinterManager sharedInstance]connectedPerpheral] == nil) {
//
//        return;
//    }
    
//    if ([obj isKindOfClass:[NSString class]]) {
//         NSString *txt = obj;
//         NSLog(@"%@",txt);
//         [self.webPrinter appendText:txt alignment:HLTextAlignmentLeft];
//         [self.webPrinter appendNewLine];
//         [self.webPrinter appendSeperatorLine];
//         [self.webPrinter appendNewLine];
//
//        NSData *mainData = [self.webPrinter getFinalData];
//
//        NSLog(@"%@",mainData);
//
//
//        [[SEPrinterManager sharedInstance] sendPrintData:mainData completion:^(CBPeripheral *connectPerpheral, BOOL completion, NSString *error) {
//            if (completion) {
//                 self.webPrinter = [[HLPrinter alloc]init];
//                [SVProgressHUD showSuccessWithStatus:@"打印成功"];
//            }
//            NSLog(@"写入结：%d---错误:%@",completion,error);
//        }];
//    }
    
}

-(void)dealWithActionByParam:(NSDictionary*)dict{
    NSLog(@"%@",dict);
    NSInteger type = [[dict safeValueBykey:@"type" type:K_SAFE_DICT_TYPE_NUMMBER] integerValue];
    switch (type) {
        case 1:
        {
            NSString *text = [dict safeValueBykey:@"text" type:K_SAFE_DICT_TYPE_STRING];
            NSInteger alignment = [[dict safeValueBykey:@"alignment" type:K_SAFE_DICT_TYPE_NUMMBER] integerValue];
            [self.webPrinter appendText:text alignment:alignment];
        }
        break;
        case 2:
        {
            NSString *text = [dict safeValueBykey:@"text" type:K_SAFE_DICT_TYPE_STRING];
            NSInteger alignment = [[dict safeValueBykey:@"alignment" type:K_SAFE_DICT_TYPE_NUMMBER] integerValue];
            NSInteger fontSize = [[dict safeValueBykey:@"fontSize" type:K_SAFE_DICT_TYPE_NUMMBER] integerValue];
            [self.webPrinter appendText:text alignment:alignment fontSize:fontSize];
        }
        break;
        case 3:
        {
            NSString *text = [dict safeValueBykey:@"text" type:K_SAFE_DICT_TYPE_STRING];
            NSString *value = [dict safeValueBykey:@"value" type:K_SAFE_DICT_TYPE_STRING];
            [self.webPrinter appendTitle:text value:value];
        }
        break;
        case 4:
        {
            NSString *text = [dict safeValueBykey:@"text" type:K_SAFE_DICT_TYPE_STRING];
            NSString *value = [dict safeValueBykey:@"value" type:K_SAFE_DICT_TYPE_STRING];
            NSInteger fontSize = [[dict safeValueBykey:@"fontSize" type:K_SAFE_DICT_TYPE_NUMMBER] integerValue];
            [self.webPrinter appendTitle:text value:value fontSize:fontSize];
        }
        break;
        case 5:
        {
            NSString *text = [dict safeValueBykey:@"text" type:K_SAFE_DICT_TYPE_STRING];
            NSString *value = [dict safeValueBykey:@"value" type:K_SAFE_DICT_TYPE_STRING];
            NSInteger fontSize = [[dict safeValueBykey:@"fontSize" type:K_SAFE_DICT_TYPE_NUMMBER] integerValue];
            NSInteger offset = [[dict safeValueBykey:@"offset" type:K_SAFE_DICT_TYPE_NUMMBER] integerValue];
            [self.webPrinter appendTitle:text value:value valueOffset:offset fontSize:fontSize];
        }
        break;
        case 6:
        {
            NSString *left = [dict safeValueBykey:@"left" type:K_SAFE_DICT_TYPE_STRING];
            NSString *right = [dict safeValueBykey:@"right" type:K_SAFE_DICT_TYPE_STRING];
            NSString *middle = [dict safeValueBykey:@"middle" type:K_SAFE_DICT_TYPE_STRING];
            NSInteger isTitle = [[dict safeValueBykey:@"isTitle" type:K_SAFE_DICT_TYPE_NUMMBER] boolValue];
            [self.webPrinter appendLeftText:left middleText:middle rightText:right isTitle:isTitle];
            
        }
        break;
        case 7:
        {
            
//            [self.webPrinter appendImage:nil alignment:0 maxWidth:0];
        }
        break;
//        case 8:
//        {
//            NSString *qr = [dict safeValueBykey:@"qr" type:K_SAFE_DICT_TYPE_STRING];
//            [self.webPrinter appendQRCodeWithInfo:qr];
//        }
//        break;
//        case 9:
//        {
//             NSString *qr = [dict safeValueBykey:@"qr" type:K_SAFE_DICT_TYPE_STRING];
//             NSInteger alignment = [[dict safeValueBykey:@"alignment" type:K_SAFE_DICT_TYPE_NUMMBER] integerValue];
//             NSInteger maxWidth = [[dict safeValueBykey:@"maxWidth" type:K_SAFE_DICT_TYPE_NUMMBER] integerValue];
//            [self.webPrinter appendBarCodeWithInfo:qr alignment:alignment maxWidth:maxWidth];
//        }
//        break;
//        case 10:
//        {
//            NSString *qr = [dict safeValueBykey:@"qr" type:K_SAFE_DICT_TYPE_STRING];
//            NSInteger size = [[dict safeValueBykey:@"size" type:K_SAFE_DICT_TYPE_NUMMBER] integerValue];
//             [self.webPrinter appendQRCodeWithInfo:qr size:size];
//        }
//        break;
//        case 11:
//        {
//            NSString *qr = [dict safeValueBykey:@"qr" type:K_SAFE_DICT_TYPE_STRING];
//            NSInteger size = [[dict safeValueBykey:@"size" type:K_SAFE_DICT_TYPE_NUMMBER] integerValue];
//            NSInteger alignment = [[dict safeValueBykey:@"alignment" type:K_SAFE_DICT_TYPE_NUMMBER] integerValue];
//             [self.webPrinter appendQRCodeWithInfo:qr size:size alignment:alignment];
//        }
//        break;
        case 12:
        {
//            [self.webPrinter appendQRCodeWithInfo:@"" centerImage:nil alignment:0 maxWidth:0];
        }
        break;
        case 13:
        {
            [self.webPrinter appendSeperatorLine];
        }
        break;
        case 14:
        {
            NSString *footer = [dict safeValueBykey:@"footer" type:K_SAFE_DICT_TYPE_STRING];
            [self.webPrinter appendFooter:footer];
        }
        break;
        case 15:
        {
            
            if ([[SEPrinterManager sharedInstance]isOpen]==NO) {
                [SVProgressHUD showErrorWithStatus:@"请打开手机的蓝牙"];
                return;
            }
            
            if (self.currentCP == nil) {
                [SVProgressHUD showErrorWithStatus:@"设备未连接"];
                return;
            }
            
            NSData *mainData = [self.webPrinter getFinalData];
            
            NSLog(@"%@",mainData);
            
            
            [[SEPrinterManager sharedInstance] sendPrintData:mainData completion:^(CBPeripheral *connectPerpheral, BOOL completion, NSString *error) {
                if (completion) {
                     self.webPrinter = [[HLPrinter alloc]init];
                }
                NSLog(@"写入结：%d---错误:%@",completion,error);
            }];
        }
        break;
        case 16:
        {
            self.webPrinter = [[HLPrinter alloc]init];
        }
            break;
        case 17:
        {
            self.cpName = [dict safeValueBykey:@"cpName" type:K_SAFE_DICT_TYPE_STRING];
            [self connectCP];
        }
                break;
        default:
            break;
    }
}


-(void)connectCP{
    SEPrinterManager *_manager = [SEPrinterManager sharedInstance];
    [_manager startScanPerpheralTimeout:10 Success:^(NSArray<CBPeripheral *> *perpherals,BOOL isTimeout) {
        NSLog(@"perpherals:%@",perpherals);
        for (CBPeripheral *cp in perpherals) {
            if ([cp.name isEqual:self.cpName]) {
                self.currentCP = cp;
                [[SEPrinterManager sharedInstance] connectPeripheral:cp completion:^(CBPeripheral *perpheral, NSError *error) {
                    if (error) {
                        [SVProgressHUD showErrorWithStatus:@"连接失败"];
                    } else {
                        self.title = @"已连接";
                        [SVProgressHUD showSuccessWithStatus:@"连接成功"];
                    }
                }];
                break;
            }
        }
        
    } failure:^(SEScanError error) {
         NSLog(@"error:%ld",(long)error);
        switch (error) {
            case SEScanErrorPoweredOff:
                [SVProgressHUD showErrorWithStatus:@"请打开蓝牙"];
                break;
               case SEScanErrorTimeout:
                [SVProgressHUD showErrorWithStatus:@"搜索超时"];
                break;
            default:
                break;
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
