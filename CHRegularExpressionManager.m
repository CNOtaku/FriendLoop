//
//  CHRegularExpressionManager.m
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/14.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//

#import "CHRegularExpressionManager.h"

@implementation CHRegularExpressionManager

+(NSArray *)itemIndexesWithPattern:(NSString *)pattern inString:(NSString *)findingString
{
    NSAssert(pattern != nil, @"%s:pattern 不可以为 nil",__PRETTY_FUNCTION__);

    NSAssert(findingString != nil, @"%s:findingString 不可以为 nil",__PRETTY_FUNCTION__);
    NSError *error = nil;
    
    NSRegularExpression *regExp = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *result = [regExp matchesInString:findingString options:NSMatchingReportCompletion range:NSMakeRange(0, [findingString length])];
    
    if (error) {
        return nil;
    }
    
    NSUInteger count = [result count];
    
    if (count == 0) {
        return [NSArray array];
    }
    
    NSMutableArray *rangesArr = [[NSMutableArray alloc]initWithCapacity:count];
    for (NSInteger i = 0; i<count; i++) {
        @autoreleasepool {
            NSRange aRange = [[result objectAtIndex:i] range];
            [rangesArr addObject:[NSValue valueWithRange:aRange]];
            
        }
    }
    return rangesArr;
}

+(NSMutableArray *)matchMobileLink:(NSString *)pattern
{
    NSMutableArray *linkArr = [NSMutableArray arrayWithCapacity:0];
    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:@"(\\(86\\))?(13[0-9]|15[0-35-9]|18[0125-9])\\d{8}" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray *array = [regular matchesInString:pattern options:NSMatchingReportProgress range:NSMakeRange(0, [pattern length])];
    
    for (NSTextCheckingResult *result in array) {
        NSString *string = [pattern substringWithRange:result.range];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:string,NSStringFromRange(result.range), nil];
        [linkArr addObject:dict];
    }
    
    return linkArr;
    
}

+(NSMutableArray *)matchWebLink:(NSString *)pattern
{
    NSMutableArray *linkArr = [NSMutableArray arrayWithCapacity:0];
    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray *array = [regular matchesInString:pattern options:NSMatchingReportProgress range:NSMakeRange(0, [pattern length])];
    
    for (NSTextCheckingResult *result in array) {
        NSString *string = [pattern substringWithRange:result.range];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:string,NSStringFromRange(result.range), nil];
        [linkArr addObject:dict];
    }
    
    return linkArr;
}

@end
