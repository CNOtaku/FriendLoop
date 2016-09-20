//
//  CHTextData.h
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/19.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHMessageBody.h"

typedef enum : NSUInteger{

    TypeShuoshuo,
    TypeFavour,
    TypeReply,
    
    
}TypeView;
@interface CHTextData : NSObject
@property(nonatomic, strong)CHMessageBody *messageBody;
@property(nonatomic, strong)NSMutableArray *replyDataSource;


@property (nonatomic,assign) float           replyHeight;//回复高度
@property (nonatomic,assign) float           shuoshuoHeight;//折叠说说高度
@property (nonatomic,assign) float           unFoldShuoHeight;//展开说说高度
@property (nonatomic,assign) float           favourHeight;//点赞的高度
@property (nonatomic,assign) float           showImageHeight;//展示图片的高度

@property (nonatomic,strong) NSMutableArray *completionReplySource;//回复内容数据源（处理）
@property (nonatomic,strong) NSMutableArray *attributedDataReply;//回复部分附带的点击区域数组
@property (nonatomic,strong) NSMutableArray *attributedDataShuoshuo;//说说部分附带的点击区域数组
@property (nonatomic,strong) NSMutableArray *attributedDataFavour;//点赞部分附带的点击区域数组


@property (nonatomic,strong) NSArray        *showImageArray;//图片数组
@property (nonatomic,strong) NSMutableArray *favourArray;//点赞昵称数组
@property (nonatomic,strong) NSMutableArray *defineAttrData;//自行添加 元素为每条回复中的自行添加的range组成的数组 如：第一条回复有（0，2）和（5，2） 第二条为（0，2）。。。。


@property (nonatomic,assign) BOOL            hasFavour;//是否赞过
@property (nonatomic,assign) BOOL            foldOrNot;//是否折叠
@property (nonatomic,copy) NSString       *showShuoShuo;//说说部分
@property (nonatomic,copy) NSString       *completionShuoshuo;//说说部分（处理后）
@property (nonatomic,copy) NSString       *showFavour;//点赞部分
@property (nonatomic,copy) NSString       *completionFavour;//点赞部分(处理后)
@property (nonatomic,assign) BOOL            islessLimit;//是否小于最低限制 宏定义最低限制是



- (float) calculateShuoshuoHeightWithWidth:(float)sizeWidth withUnFoldState:(BOOL)isUnfold;

-(float)calculateFavourHeightWidth:(float)sizeWidth;

-(float)initWithMessage:(CHMessageBody *)messageBody;


-(float)calculateReplyHeightWithWidth:(float)sizeWidth;
@end
