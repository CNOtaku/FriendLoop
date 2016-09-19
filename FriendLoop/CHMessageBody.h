//
//  CHMessageBody.h
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/19.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHMessageBody : NSObject

@property(nonatomic, copy)NSString *posterImageStr;

@property(nonatomic, copy)NSString *posterName;

@property(nonatomic, copy)NSString *postertIntro;

@property(nonatomic, copy)NSString *posterContent;

@property(nonatomic, strong)NSArray *posterPostImage;

@property(nonatomic, strong)NSMutableArray *posterFavor;

@property(nonatomic, strong)NSMutableArray *posterReplies;

@property(nonatomic, assign)BOOL isFavour;
@end
