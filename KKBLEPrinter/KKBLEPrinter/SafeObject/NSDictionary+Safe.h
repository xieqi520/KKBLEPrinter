//
//  NSDictionary+Safe.h
//  SafeObjectCrash
//
//  Created by lujh on 2018/4/18.
//  Copyright © 2018年 lujh. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  输入已知的安全类型
 */
typedef NS_ENUM(NSUInteger, K_SAFE_DICT_TYPE){
    K_SAFE_DICT_TYPE_NUMMBER = 1, /**< number >*/
    K_SAFE_DICT_TYPE_STRING,/**< 字符串 >*/
    K_SAFE_DICT_TYPE_ARRAY,/**< 数组 >*/
    K_SAFE_DICT_TYPE_DICT,/**< 字典类型 >*/
    K_SAFE_DICT_TYPE_SET, /**< 集合类型 >*/
};
@interface NSDictionary (Safe)
-(id)safeValueBykey:(NSString*)key type:(K_SAFE_DICT_TYPE)type;
@end
