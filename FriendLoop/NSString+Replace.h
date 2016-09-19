//
//  NSString+Replace.h
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/14.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Replace)

-(NSString *)replaceCharctersAtIndexes:(NSArray *)indexes withString:(NSString *)aString;

-(NSMutableArray *)itemsFromPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index;

@end
