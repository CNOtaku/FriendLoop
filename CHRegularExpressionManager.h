//
//  CHRegularExpressionManager.h
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/14.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHRegularExpressionManager : NSObject

+(NSArray *)itemIndexesWithPattern:(NSString *)pattern inString:(NSString *)findingString;

+(NSMutableArray *)matchMobileLink:(NSString *)pattern;

+(NSMutableArray *)matchWebLink:(NSString *)pattern;


@end
