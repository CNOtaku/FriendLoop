//
//  CHTextData.m
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/19.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//

#import "CHTextData.h"

#import "Header.h"
#import "CHRegularExpressionManager.h"
#import "NSString+Replace.h"
#import "CHReplyBody.h"
#import "CHTextView.h"

@implementation CHTextData

{
    TypeView typeview;
    int tempInt;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.completionReplySource = [[NSMutableArray alloc]init];
        self.attributedDataReply = [[NSMutableArray alloc]init];
        self.attributedDataShuoshuo = [[NSMutableArray alloc]init];
        self.attributedDataFavour = [[NSMutableArray alloc]init];
        
        _foldOrNot = YES;
        _islessLimit = NO;
    }
    return self;
}

-(void)setMessageBody:(CHMessageBody *)messageBody
{
    _messageBody = messageBody;
    _showImageArray = messageBody.posterPostImage;
    _foldOrNot = YES;
    _showShuoShuo = messageBody.posterContent;
    _defineAttrData = [self findArrWith:messageBody.posterReplies];
    _replyDataSource = messageBody.posterReplies;
    _favourArray = messageBody.posterFavor;
    _hasFavour = messageBody.isFavour;

}

-(NSMutableArray *)findArrWith:(NSMutableArray *)replies
{
    NSMutableArray *feedBackArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < replies.count; i++) {
        CHReplyBody *replyBody = (CHReplyBody*)[replies objectAtIndex:i];
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        if ([replyBody.replyUser isEqualToString:@""]) {
            NSString *range = NSStringFromRange(NSMakeRange(0, replyBody.replyUser.length));
            [tempArr addObject:range];
        }else{
            NSString *range1 = NSStringFromRange(NSMakeRange(0, replyBody.replyUser.length));
            NSString *range2 = NSStringFromRange(NSMakeRange(replyBody.replyUser.length +2, replyBody.replyUser.length));
            
            [tempArr addObject:range1];
            [tempArr addObject:range2];
        }
        
        [feedBackArray addObject:tempArr];
    }
    return feedBackArray;
}

-(float)calculateFavourHeightWidth:(float)sizeWidth
{
    typeview = TypeFavour;
    float heigeht = 0.f;
    NSString *matchString = [_favourArray componentsJoinedByString:@","];
    _showFavour = matchString;
    NSArray *itemIndexs = [CHRegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:matchString];
    
    NSString *newString = [matchString replaceCharctersAtIndexes:itemIndexs withString:PlaceHolder];
    self.completionFavour = newString;
    
    [self matchingString:newString fromView:typeview];
    
    CHTextView *_wfcoreText = [[CHTextView alloc] initWithFrame:CGRectMake(offSet_X + 30,10, sizeWidth - 2*offSet_X - 30, 0)];
    
    _wfcoreText.isFold = NO;
    _wfcoreText.isDraw = NO;
    
    [_wfcoreText setOldString:_showFavour andNewString:newString];
    
    return [_wfcoreText getTextHeight];
    
    
}

-(void)matchingString:(NSString *)dataSourceString fromView:(TypeView)isReplyV
{
    if (isReplyV == TypeReply) {
        NSMutableArray *totalArr = [NSMutableArray arrayWithCapacity:0];
        
        
        NSMutableArray *mobileLink = [CHRegularExpressionManager matchMobileLink:dataSourceString];
        
        for (int i=0; i<mobileLink.count; i++) {
            [totalArr addObject:[mobileLink objectAtIndex:i]];
            
        }
        
        
        NSMutableArray *webLink = [CHRegularExpressionManager matchWebLink:dataSourceString];
        for (int i = 0; i<webLink.count; i++) {
            [totalArr addObject:[mobileLink objectAtIndex:i]];
        }
        
        
        
        
        if (_defineAttrData.count != 0) {
            NSArray *tArr = [_defineAttrData objectAtIndex:tempInt];
            
            for (int i = 0; i<tArr.count; i++) {
                NSString *string = [dataSourceString substringWithRange:NSRangeFromString(tArr[i])];
                
                [totalArr addObject:[NSDictionary dictionaryWithObject:string forKey:NSStringFromRange(NSRangeFromString([tArr objectAtIndex:i]))]];
            }
        }
        
        [self.attributedDataReply addObject:totalArr];
    }
    
    if(isReplyV == TypeShuoshuo){
        
        [self.attributedDataShuoshuo removeAllObjects];
        //**********号码******
        
        NSMutableArray *mobileLink = [CHRegularExpressionManager matchMobileLink:dataSourceString];
        for (int i = 0; i < mobileLink.count; i ++) {
            
            [self.attributedDataShuoshuo addObject:[mobileLink objectAtIndex:i]];
        }
        
        //*************************
        
        
        //***********匹配网址*********
        
        NSMutableArray *webLink = [CHRegularExpressionManager matchWebLink:dataSourceString];
        for (int i = 0; i < webLink.count; i ++) {
            
            [self.attributedDataShuoshuo addObject:[webLink objectAtIndex:i]];
        }
        
    }

    
    if (isReplyV == TypeFavour) {
        
        [self.attributedDataFavour removeAllObjects];
        int originX = 0;
        for (int i = 0; i < _favourArray.count; i ++) {
            NSString *text = [_favourArray objectAtIndex:i];
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:text,NSStringFromRange(NSMakeRange(originX, text.length)), nil];
            [self.attributedDataFavour addObject:dic];
            originX += (1 + text.length);
        }
    }
    
    

}



//计算replyview高度
- (float) calculateReplyHeightWithWidth:(float)sizeWidth{
    
    typeview = TypeReply;
    float height = .0f;
    
    for (int i = 0; i < self.replyDataSource.count; i ++ ) {
        
        tempInt = i;
        
        CHReplyBody *body = (CHReplyBody *)[self.replyDataSource objectAtIndex:i];
        
        NSString *matchString;
        
        if ([body.repliedUser isEqualToString:@""]) {
            matchString = [NSString stringWithFormat:@"%@:%@",body.replyUser,body.replyInfo];
            
        }else{
            matchString = [NSString stringWithFormat:@"%@回复%@:%@",body.replyUser,body.repliedUser,body.replyInfo];
            
        }
        NSArray *itemIndexs = [CHRegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:matchString];
        
        NSString *newString = [matchString replaceCharctersAtIndexes:itemIndexs withString:PlaceHolder];
        //存新的
        [self.completionReplySource addObject:newString];
        
        [self matchingString:newString fromView:typeview];
        
        CHTextView *_ilcoreText = [[CHTextView alloc] initWithFrame:CGRectMake(offSet_X,10, sizeWidth - offSet_X * 2, 0)];
        
        _ilcoreText.isFold = NO;
        _ilcoreText.isDraw = NO;
        
        [_ilcoreText setOldString:matchString andNewString:newString];
        
        height =  height + [_ilcoreText getTextHeight] + 5;
        
    }
    
    [self calculateShowImageHeight];
    
    return height;
    
}
//图片高度
- (void)calculateShowImageHeight{
    
    if (self.showImageArray.count == 0) {
        self.showImageArray = 0;
    }else{
        self.showImageHeight = (ShowImage_H + 10) * ((self.showImageArray.count - 1)/3 + 1);
    }
    
}


//说说高度
- (float) calculateShuoshuoHeightWithWidth:(float)sizeWidth withUnFoldState:(BOOL)isUnfold{
    
    typeview = TypeShuoshuo;
    
    NSString *matchString =  _showShuoShuo;
    
    NSArray *itemIndexs = [CHRegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:matchString];
    
    //用PlaceHolder 替换掉[em:02:]这些
    NSString *newString = [matchString replaceCharctersAtIndexes:itemIndexs withString:PlaceHolder];
    //存新的
    self.completionShuoshuo = newString;
    
    [self matchingString:newString fromView:typeview];
    
    CHTextView *_wfcoreText = [[CHTextView alloc] initWithFrame:CGRectMake(20,10, sizeWidth - 2*20, 0)];
    
    _wfcoreText.isDraw = NO;
    
    [_wfcoreText setOldString:_showShuoShuo andNewString:newString];
    
    if ([_wfcoreText getTextLines] <= limitline) {
        self.islessLimit = YES;
    }else{
        self.islessLimit = NO;
    }
    
    if (!isUnfold) {
        _wfcoreText.isFold = YES;
        
    }else{
        _wfcoreText.isFold = NO;
    }
    return [_wfcoreText getTextHeight];
    
}



@end
