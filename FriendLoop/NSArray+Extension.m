//
//  NSArray+Extension.m
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/14.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)

-(NSArray *)offsetRangesInArrayBy:(NSUInteger)offset
{
    NSUInteger aOffset = 0;
    NSUInteger prevLength = 0;
    
    NSMutableArray *ranges = [[NSMutableArray alloc]initWithCapacity:[self count]];
    
    for (NSUInteger i = 0; i < [self count]; i++) {
        @autoreleasepool {
            NSRange range = [[self objectAtIndex:i] rangeValue];
            prevLength = range.length;
            
            range.location -= aOffset;
            range.length = offset;
            
            [ranges addObject:NSStringFromRange(range)];
            
            aOffset = aOffset +prevLength -offset;
        }
    }
    return ranges;
}

@end
