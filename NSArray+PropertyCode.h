//
//  NSArray+PropertyCode.h
//  Parents
//
//  Created by luofeng on 2020/6/27.
//  Copyright © 2020 9130. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (PropertyCode)

/// modelName: 后面不要带model字样
- (void)createPropertyCode2:(nullable NSString *)modelName;

@end

NS_ASSUME_NONNULL_END
