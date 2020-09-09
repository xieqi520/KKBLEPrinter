//
//  BLESelectPopView.h
//  KKBLEPrinter
//
//  Created by 谢齐 on 2020/9/8.
//  Copyright © 2020 谢齐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
typedef void(^BLEBlock)(CBPeripheral * _Nullable perpheral);
NS_ASSUME_NONNULL_BEGIN

@interface BLESelectPopView : UIView
@property(nonatomic,copy)BLEBlock block;
@property(nonatomic,strong)NSData *sendData;
@end

NS_ASSUME_NONNULL_END
