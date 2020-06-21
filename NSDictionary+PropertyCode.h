//
//  NSDictionary+PropertyCode.h
//  06-Runtime(字典转模型KVC实现)
//
//  Created by 1 on 13/06/10.
//  Copyright © 2013年 xiaomage. All rights reserved.
//  生成属性代码

#import <Foundation/Foundation.h>

@interface NSDictionary (PropertyCode)

/// 自动生成属性代码
- (void)createPropertyCode:(nullable NSString *)modelName;


- (void)createPropertyCode2:(nullable NSString *)modelName;

@end
