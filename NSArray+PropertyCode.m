//
//  NSArray+PropertyCode.m
//  Parents
//
//  Created by luofeng on 2020/6/27.
//  Copyright © 2020 9130. All rights reserved.
//

#import "NSArray+PropertyCode.h"
#import "NSDictionary+PropertyCode.h"

@implementation NSArray (PropertyCode)

- (void)createPropertyCode2:(nullable NSString *)modelName {
    if (![self isKindOfClass:[NSArray class]] || [self count] == 0) {
        NSLog(@"%@ 无数据可用",modelName);
        return ;
    }
    
    NSDictionary *dic = self.firstObject;
    [dic createPropertyCode2:modelName];
    
}

@end
