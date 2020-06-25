//
//  NSDictionary+PropertyCode.m
//  06-Runtime(字典转模型KVC实现)
//
//  Created by 1 on 15/12/10.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "NSDictionary+PropertyCode.h"
/*
 else if ([value isKindOfClass:[NSDictionary class]]){
 //    Bool
 code = [NSString stringWithFormat:@"@property (nonatomic ,assign) NSInteger %@;",key];
 }
 */

// isKindOfClass:判断是否是当前类或者它的子类

@implementation NSDictionary (PropertyCode)

- (void)createPropertyCode:(nullable NSString *)modelName
{
    NSMutableString *strM = [NSMutableString string];
    /*
        解析字典,生成对应属性代码
        1.遍历字典,取出所有key,每个key对应一个属性代码
     */
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        
        NSString *code = nil;
        if ([value isKindOfClass:[NSString class]]) {
            // NSString
            code = [NSString stringWithFormat:@"@property (nonatomic ,strong) NSString *%@;",key];
        } else if ([value isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
            //    Bool
            code = [NSString stringWithFormat:@"@property (nonatomic ,assign) BOOL %@;",key];
        }else if ([value isKindOfClass:[NSNumber class]]){
            //    NSInteger
            code = [NSString stringWithFormat:@"@property (nonatomic ,assign) NSInteger %@;",key];
        }else if ([value isKindOfClass:[NSArray class]]){
            //    NSArray
            code = [NSString stringWithFormat:@"@property (nonatomic ,strong) NSArray *%@;",key];
        }else if ([value isKindOfClass:[NSDictionary class]]){
            //    NSDictionary
            code = [NSString stringWithFormat:@"@property (nonatomic ,strong) NSDictionary *%@;",key];
        }
        
        
        [strM appendFormat:@"\n%@",code];
        // 获取所有key
        
    }];
    
    /*
    输出结果：
    @property (nonatomic ,strong) NSString *source;
    @property(nonatomic ,assign) int reposts_count;
     */
    NSLog(@"%@",strM);
    
    
}

static NSMutableString *strImp;
- (void)createPropertyCode2:(nullable NSString *)keyName {
    strImp = [NSMutableString string];
    NSMutableString *str = [self createPropertyCode3:keyName ];
    NSLog(@"%@",str);

    [strImp insertString:@"\n\n#import <MJExtension/MJExtension.h>" atIndex:0];
    NSLog(@"%@",strImp);
}

- (NSMutableString *)createPropertyCode3:(nullable NSString *)keyName
{
    NSMutableString *strM = [NSMutableString string];   // 头文件
    
    
    //static NSMutableString *strImp = [NSMutableString string]; // .m文件
    NSMutableString *impl = [NSMutableString string]; // .m文件单个代码
    __block NSString *implReplace = nil;        // .m文件单个代码，属性映射替换代码
    __block NSString *implClassInArray = nil;   // .m文件单个代码，数组中的类型
    
    /*
        解析字典,生成对应属性代码
        1.遍历字典,取出所有key,每个key对应一个属性代码
     */
    
    // 第一个字母大写
    keyName = [self _capitalizedStringFirst:keyName];
    NSString *modelName = [NSString stringWithFormat:@"%@Model",keyName];
    [strM appendFormat:@"\n@interface %@ : NSObject",modelName];
    [impl appendFormat:@"\n\n@implementation %@",modelName];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        
        // @property (nonatomic ,strong) NSString *source;
        // @property(nonatomic ,assign) int reposts_count;
        NSString *code = nil; // .h文件单个代码
        
        if ([value isKindOfClass:[NSString class]]) {
            // NSString
            key = [key isEqualToString:@"id"] ? @"ID" : key;
            code = [NSString stringWithFormat:@"@property (nonatomic ,strong) NSString *%@;",key];
            
            if ([key isEqualToString:@"ID"]) {
                NSString *replaceCode = @"\"ID\":@\"id\"";
                implReplace = implReplace.length == 0 ? replaceCode : [implReplace stringByAppendingFormat:@",\n%@",replaceCode];
            };
            
            
        } else if ([value isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
            //    Bool
            code = [NSString stringWithFormat:@"@property (nonatomic ,assign) BOOL %@;",key];
            
            
        }else if ([value isKindOfClass:[NSNumber class]]){
            //    NSInteger
            key = [key isEqualToString:@"id"] ? @"ID" : key;
            code = [NSString stringWithFormat:@"@property (nonatomic ,assign) NSInteger %@;",key];
            
            if ([key isEqualToString:@"ID"]) {
                NSString *replaceCode = @"\"ID\":@\"id\"";
                implReplace = implReplace.length == 0 ? replaceCode : [implReplace stringByAppendingFormat:@",\n%@",replaceCode];
            };
            
        }else if ([value isKindOfClass:[NSArray class]]){
            //    NSArray
            code = [NSString stringWithFormat:@"@property (nonatomic ,strong) NSArray *%@;",key];
            
            // 给数组添加泛型
            if ([value count] > 0 && [[value firstObject] isKindOfClass:[NSDictionary class]]) {
                NSMutableString * subStr = [[value firstObject] createPropertyCode3:key];
                [strM insertString:subStr atIndex:0];// 放在前面
                
                NSString *modelClassName = [NSString stringWithFormat:@"%@Model",[self _capitalizedStringFirst:key]];
                code = [NSString stringWithFormat:@"@property (nonatomic ,strong) NSArray <%@ *>*%@;",modelClassName,key];
                implClassInArray = implClassInArray.length == 0 ? [NSString stringWithFormat:@"\"@%@\": @\"%@\"",key,modelClassName] : [NSString stringWithFormat:@"%@,\n\t\t\t\t\"%@\": @\"%@\"",implClassInArray,key,modelClassName];
            } else {
                code = [NSString stringWithFormat:@"@property (nonatomic ,strong) NSArray <数组无数据待补充 *>*%@;",key];
                implClassInArray = implClassInArray.length == 0 ? [NSString stringWithFormat:@"\"@%@\": @\"%@\"",key,modelName] : [NSString stringWithFormat:@"%@,\n\t\t\t\t\"%@\": @\"%@\"",implClassInArray,key,@"数组无数据待补充"];
            }
            
        }else if ([value isKindOfClass:[NSDictionary class]]){
            //    NSDictionary
            code = [NSString stringWithFormat:@"@property (nonatomic ,strong) NSDictionary *%@;",key];
            
            // 给属性添加模型类名
            if ([value count] > 0) {
                NSMutableString * subStr = [value createPropertyCode3:key];
                [strM insertString:subStr atIndex:0];// 放在前面
                
                NSString *treatedKey = [self _capitalizedStringFirst:key];
                NSString *modelClassName = [NSString stringWithFormat:@"%@Model",treatedKey];
                code = [NSString stringWithFormat:@"@property (nonatomic ,strong) %@ *%@;",modelClassName,key];
            } else {
                code = [NSString stringWithFormat:@"@property (nonatomic ,strong) 字典无数据待补充 *%@;",key];
            }
            
        } else {
            // nil
            code = [NSString stringWithFormat:@"@property (nonatomic ,strong) 无数据待补充 %@;",key];
        }
        
        
        [strM appendFormat:@"\n%@",code];
        
    }];
    
    [strM appendString:@"\n@end"];
    
    
    NSString *mjCode = @"";
    if (implReplace.length > 0) {
        mjCode = [NSString stringWithFormat:@"\t\t[%@ mj_setupReplacedKeyFromPropertyName:^NSDictionary *{\n\t\t\treturn @{\t\t\t\t\n\t\t\t\t%@\n\t\t\t};\n\t\t}]",modelName,implReplace];
    }
    if (implClassInArray.length > 0) {
        mjCode = [mjCode stringByAppendingString:[NSString stringWithFormat:@"\t\t[%@ mj_setupObjectClassInArray:^NSDictionary *{\n\t\t\treturn @{\t\t\t\t\n\t\t\t\t%@\n\t\t\t};\n\t\t}]",modelName,implClassInArray]];
    }
    NSString *modelInitCode = @"";
    if (mjCode.length > 0) {
        modelInitCode = [modelInitCode stringByAppendingString:[NSString stringWithFormat:@"\n- (instancetype)init {\n\tself = [super init];\n\tif (self) {\n%@;\n\t}\n\treturn self;\n}",mjCode]];
    }
    if (modelInitCode.length > 0) {
        [impl appendString:modelInitCode];
    }
    [impl appendString:@"\n@end"];
    [strImp insertString:impl atIndex:0];
    
    
    // 打印.m
//    NSLog(@"%@",strImp);
    
    // 打印模型代码 .h
//    NSLog(@"%@",strM);
    
    return strM;
    
}



- (void)handleToImplementionWithInterface:(NSString *)str {
    
    
    
}

/// 首字母大写
- (NSString *)_capitalizedStringFirst:(NSString *)str {
    // header_imgsModel --> Header_imgsModel
//    return [str stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[str substringToIndex:1] capitalizedString]];
    // Header_ImgsModel --> Header_ImgsModel
    return [str capitalizedString];
}

@end
