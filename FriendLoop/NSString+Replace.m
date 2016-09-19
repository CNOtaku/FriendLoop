//
//  NSString+Replace.m
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/14.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//

#import "NSString+Replace.h"

@implementation NSString (Replace)


-(NSString *)replaceCharctersAtIndexes:(NSArray *)indexes withString:(NSString *)aString
{
    NSAssert(indexes != nil, @"%s: indexes 不能为nil",__PRETTY_FUNCTION__);
    NSAssert(aString != nil, @"%s: aString 不能为nil",__PRETTY_FUNCTION__);
    
    NSUInteger offset = 0;
    NSMutableString *raw = [self mutableCopy];
    
    NSUInteger prevLength = 0;
    
    for (NSUInteger i = 0; i<[indexes count]; i++) {
        @autoreleasepool {
            NSRange range = [[indexes objectAtIndex:i] rangeValue];
            prevLength = range.length;
            
            range.location -=offset;
            [raw replaceCharactersInRange:range withString:aString];
            offset = offset + prevLength -[aString length];
        }
    }
    return raw;
}
-(NSMutableArray *)itemsFromPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index
{
    if (!pattern) {
        return nil;
    }
    
    NSError *error = nil;
    NSRegularExpression *regx = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (error) {
        
    }else{
        NSMutableArray *results  = [[NSMutableArray alloc]init];
        NSRange searchRange = NSMakeRange(0, [self length]);
        
        [regx enumerateMatchesInString:self options:NSMatchingReportProgress range:searchRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            NSRange groupRange = [result rangeAtIndex:index];
            NSString *match = [self substringWithRange:groupRange];
            
            [results addObject:match];
        }];
        return results;
    }
    
    return nil;
    
}
@end
