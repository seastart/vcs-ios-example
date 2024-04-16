//
//  NSString+Extension.m
//  VCSModuleExample
//
//  Created by SailorGa on 2023/3/17.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString(Extension)

#pragma mark - 检测消息内容是否有效
/// 检测消息内容是否有效
- (BOOL)isContentEffective {
    
    if (kStringIsEmpty(self)) {
        return NO;
    }
    
    /// A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    /// Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
    NSString *trimedString = [self stringByTrimmingCharactersInSet:characterSet];
    
    if (kStringIsEmpty(trimedString)) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - 处理用户昵称
/// 处理用户昵称
- (NSString *)nicknameSuitScanf {
    
    if (self.length <= 20) {
        /// 昵称长度小于等于20个字符，不做处理
        return self;
    }
    /// 截取下标19之前的字符串
    NSString *newname = [self substringToIndex:20];
    /// 构建可变字符串
    NSMutableString *newnameStr = [NSMutableString stringWithString:newname];
    /// 追加省略符字符串
    [newnameStr appendString:@"..."];
    /// 返回处理后的新昵称
    return [NSString stringWithString:newnameStr];
}

#pragma mark - 检测字符串是否为纯数字
/// 检测字符串是否为纯数字
- (BOOL)deptNumInputShouldNumber {
    
    if (kStringIsEmpty(self)) {
         return NO;
    }
    
    NSString *regex = @"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

#pragma mark - 验证字符串是否IP地址
/// 验证字符串是否IP地址
- (BOOL)isValidateIP {
    
    NSArray *ipArray = [self componentsSeparatedByString:@"."];
    if (ipArray.count != 4) {
        return NO;
    }
    
    NSString *pattern = @"^(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5]).(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5]).(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5]).(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:self];
}

@end
