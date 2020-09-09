//
//  KKSearchBLEVC.m
//  KKBLEPrinter
//
//  Created by 谢齐 on 2020/8/29.
//  Copyright © 2020 谢齐. All rights reserved.
//

#import "KKSearchBLEVC.h"
#import "SEPrinterManager.h"
#import "SVProgressHUD.h"
#import "WKWebViewController.h"
@interface KKSearchBLEVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *syTableView;
@property (strong, nonatomic)NSArray*deviceArray;  /**< 蓝牙设备个数 */
@end

@implementation KKSearchBLEVC
- (UITableView *)syTableView{
    if (!_syTableView) {
        _syTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _syTableView.delegate = self;
        _syTableView.dataSource = self;
        _syTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _syTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *identifier = @"deviceId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    CBPeripheral *peripherral = [self.deviceArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"名称:%@",peripherral.name];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deviceArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设备列表";
    // Do any additional setup after loading the view.
    [self.view addSubview:self.syTableView];
    
    [self initBLE];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral *peripheral = [self.deviceArray objectAtIndex:indexPath.row];
    
    [[SEPrinterManager sharedInstance] connectPeripheral:peripheral completion:^(CBPeripheral *perpheral, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"连接失败"];
        } else {
            
            [SVProgressHUD showSuccessWithStatus:@"连接成功"];
            WKWebViewController *vc = [[WKWebViewController alloc]init];
            vc.currentCP = peripheral;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    // 如果你需要连接，立刻去打印
//    [[SEPrinterManager sharedInstance] fullOptionPeripheral:peripheral completion:^(SEOptionStage stage, CBPeripheral *perpheral, NSError *error) {
//        if (stage == SEOptionStageSeekCharacteristics) {
//            HLPrinter *printer = [self getPrinter];
//
//            NSData *mainData = [printer getFinalData];
//            [[SEPrinterManager sharedInstance] sendPrintData:mainData completion:nil];
//        }
//    }];
}




-(void)initBLE{
    __weak typeof(self) weakself = self;
    SEPrinterManager *_manager = [SEPrinterManager sharedInstance];
    [_manager startScanPerpheralTimeout:10 Success:^(NSArray<CBPeripheral *> *perpherals,BOOL isTimeout) {
        NSLog(@"perpherals:%@",perpherals);
        weakself.deviceArray = perpherals;
        [weakself.syTableView reloadData];
        
    } failure:^(SEScanError error) {
         NSLog(@"error:%ld",(long)error);
    }];
}

@end
