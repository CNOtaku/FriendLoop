//
//  CHTextView.h
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/14.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHCoretextDelegate <NSObject>

-(void)clickCHCoretext:(NSString *)clickString replyIndex:(NSInteger)index;

-(void)longClickedCHCoretext:(NSString *)clickstring replyIndex:(NSInteger)index;


@end

@interface CHTextView : UIView

@property(nonatomic, strong)NSAttributedString *attrEmotionString;
@property(nonatomic, strong)NSArray *emotionNames;
@property(nonatomic, strong)NSMutableArray *attributedData;

@property(nonatomic, assign)BOOL isDraw;
@property(nonatomic, assign)BOOL isFold;
@property(nonatomic, assign)int textLine;
@property(nonatomic, assign)CFIndex limitCharIndex;
@property(nonatomic, assign)BOOL canClickAll;
@property(nonatomic, assign)NSInteger replyIndex;
@property(nonatomic, strong)UIColor *textColor;

@property(nonatomic, assign)id<CHCoretextDelegate>delegate;


-(void)setOldString:(NSString *)oldString andNewString:(NSString *)newString;

-(int)getTextLines;

-(float)getTextHeight;


@end
