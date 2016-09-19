//
//  CHTableViewCell.m
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/19.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//

#import "CHTableViewCell.h"

#import "CHReplyBody.h"
#import "Header.h"
#import "CHTapGestureRecognizer.h"
#import "CHHudView.h"

@implementation CHTableViewCell
{
    UIButton *foldButton;
    CHTextData *tempData;
    UIImageView *replyImageView;
}




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        _userHeaderImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 50, TableHeader)];
        _userHeaderImage.backgroundColor = [UIColor clearColor];
        CALayer *layer = [_userHeaderImage layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:1.f];
        [layer setBorderWidth:1.f];
        [layer setBorderColor:[[UIColor colorWithRed:63/255.f green:107/255.f blue:252/255.f alpha:1.f]CGColor ]];
        
        [self.contentView addSubview:_userHeaderImage];
        
        _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20+TableHeader+20, 5, screenWidth-120, TableHeader/2)];
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
        _userNameLabel.font = [UIFont systemFontOfSize:15.f];
        _userNameLabel.textColor = [UIColor colorWithRed:104/255.f green:109/255.f blue:248/255.f alpha:1.f];
        [self.contentView addSubview:_userNameLabel];
        
        _userIntroLabel = [[UILabel alloc]initWithFrame:CGRectMake(20+TableHeader+20, 5+TableHeader/2, screenWidth -120, TableHeader/2)];
        _userIntroLabel.numberOfLines = 1;
        _userIntroLabel.font = [UIFont systemFontOfSize:14.f];
        _userIntroLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_userIntroLabel];
        
        
        _imageArray = [NSMutableArray new];
        _chTextArray = [NSMutableArray new];
        _chShuoshuoArray = [NSMutableArray new];
        _chFavourArray = [NSMutableArray new];
        
        
        foldButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [foldButton setTitle:@"展开" forState:UIControlStateNormal];
        foldButton.backgroundColor = [UIColor clearColor];
        foldButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [foldButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [foldButton addTarget:self action:@selector(foldText) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:foldButton];
        
        replyImageView = [[UIImageView alloc]init];
        replyImageView.backgroundColor = [UIColor colorWithRed:242/255.f green:242/255.f blue:242/255.f alpha:1.f];
        [self.contentView addSubview:replyImageView];
        
        _replyButton = [CHButton buttonWithType:UIButtonTypeCustom];
        [_replyButton setImage:[UIImage imageNamed:@"fw_r2_c2_.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_replyButton];
        
        
        _favourImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        _favourImage.image = [UIImage imageNamed:@"zan.png"];
        [self.contentView addSubview:_favourImage];
    }
    return self;
}

-(void)foldText
{
    if (tempData.foldOrNot == YES) {
        tempData.foldOrNot = NO;
        [foldButton setTitle:@"收起" forState:UIControlStateNormal];
        
    }else{
        tempData.foldOrNot = YES;
        [foldButton setTitle:@"展开" forState:UIControlStateNormal];
    }
    
    [_delegate changeFoldState:tempData onCellInRow:self.stamp];
}


-(void)setCHViewWith:(CHTextData *)chData
{
    
    tempData = chData;
    
    _userHeaderImage.image =[UIImage imageNamed:tempData.messageBody.posterImageStr];
    _userNameLabel.text = tempData.messageBody.posterName;
    _userIntroLabel.text = tempData.messageBody.postertIntro;
    
    for (int i = 0; i <_chShuoshuoArray.count; i++) {
        CHTextView *imageV = (CHTextView *)[_chShuoshuoArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
    }
    
    [_chShuoshuoArray removeAllObjects];
    
    
    CHTextView *textView = [[CHTextView alloc]initWithFrame:CGRectMake(offSet_X, 15+TableHeader, screenWidth -2*offSet_X, 0)];
    textView.delegate = self;
    textView.attributedData = chData.attributedDataShuoshuo;
    textView.isFold = chData.foldOrNot;
    textView.isDraw = YES;
    [textView setOldString:chData.showShuoShuo andNewString:chData.completionShuoshuo];
    [self.contentView addSubview:textView];
    
    BOOL foldOrnot = chData.foldOrNot;
    
    float hhh = foldOrnot?chData.shuoshuoHeight:chData.unFoldShuoHeight;
    
    textView.frame = CGRectMake(offSet_X, 15+TableHeader, screenWidth-2*offSet_X, hhh);
    
    [_chShuoshuoArray addObject:textView];
    
    foldButton.frame = CGRectMake(offSet_X-10, 15+TableHeader+hhh+10, 50, 20);
    
    if (chData.islessLimit) {
        foldButton.hidden = YES;
        
    }else
    {
        foldButton.hidden = NO;
    }
    
    if (tempData.foldOrNot == YES) {
        
        [foldButton setTitle:@"展开" forState:0];
    }else{
        
        [foldButton setTitle:@"收起" forState:0];
    }

    
    for (int i = 0; i <_imageArray.count; i++) {
        UIImageView *imageV = (UIImageView *)[_imageArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
    }
    
    [_imageArray removeAllObjects];
    
    for (int i = 0; i<chData.showImageArray.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(((screenWidth-240)/4)*(i%3 +1)+80*(i%3), TableHeader +10*(i/3)+(i/3)*ShowImage_H+hhh+kDistance+(chData.islessLimit?0:30), 80, ShowImage_H)];
        imageV.userInteractionEnabled = YES;
        
        CHTapGestureRecognizer *tap = [[CHTapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageV:)];
        [imageV addGestureRecognizer:tap];
        tap.appendArray = chData.showImageArray;
        
        imageV.backgroundColor =[UIColor clearColor];
        imageV.tag = 9999+i;
        imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[chData.showImageArray objectAtIndex:i]]];
        [self.contentView addSubview:imageV];
        [_imageArray addObject:imageV];
    }

    
    
    for (int i = 0; i <_chFavourArray.count; i++) {
        CHTextView *imageV = (CHTextView *)[_chFavourArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
    }

    [_chFavourArray removeAllObjects];
    
    float orgin_y = 10;
    NSUInteger scale_y = chData.showImageArray.count -1;
    float balanceHeight = 0;
    if (chData.showImageArray.count ==0) {
        scale_y = 0;
        balanceHeight = -ShowImage_H -kDistance;
    }
    
    float backView_y = 0;
    float backView_H = 0;
    
    CHTextView *favourView = [[CHTextView alloc]initWithFrame:CGRectMake(offSet_X+30, TableHeader+10+ShowImage_H+(ShowImage_H+10)*(scale_y/3) +orgin_y+hhh+kDistance+(chData.islessLimit?0:30)+balanceHeight +kReplyBtnDistance, screenWidth-2*offSet_X-30, 0)];
    favourView.delegate = self;
    favourView.attributedData = chData.attributedDataFavour;
    favourView.isDraw = YES;
    favourView.isFold = NO;
    favourView.textColor = [UIColor redColor];
    favourView.canClickAll = NO;
    
    [favourView setOldString:chData.showFavour andNewString:chData.completionFavour];
    favourView.frame = CGRectMake(offSet_X + 30,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_y/3) + orgin_y + hhh + kDistance + (chData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance, screenWidth - offSet_X * 2 - 30, chData.favourHeight);
    [self.contentView addSubview:favourView];
    backView_H+=((chData.favourHeight == 0)?(-kReply_FavourDistance):chData.favourHeight);
    [_chFavourArray addObject:favourView];
    
    
    _favourImage.frame = CGRectMake(offSet_X+8, favourView.frame.origin.y, (chData.favourHeight==0)?0:20, (chData.favourHeight==0)?0:20);
    
    
    
    for (int i = 0; i <_chTextArray.count; i++) {
        CHTextView *imageV = (CHTextView *)[_chTextArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
    }
    
    [_chTextArray removeAllObjects];
    
    for (int i = 0; i<chData.replyDataSource.count; i++) {
        CHTextView *chCoreText = [[CHTextView alloc]initWithFrame:CGRectMake(offSet_X, TableHeader+10+ShowImage_H+(ShowImage_H+10)*(scale_y/3)+orgin_y+hhh+kDistance+(chData.islessLimit?0:30)+balanceHeight+kReplyBtnDistance+chData.favourHeight+(chData.favourHeight==0?0:kReply_FavourDistance), screenWidth-offSet_X*2, 0)];
        
        if (i == 0) {
            backView_y = TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_y/3) + orgin_y + hhh + kDistance + (chData.islessLimit?0:30);
        }
        chCoreText.delegate = self;
        chCoreText.replyIndex = i;
        chCoreText.isFold = NO;
        chCoreText.attributedData = [chData.attributedDataReply objectAtIndex:i];
        
        CHReplyBody *body = (CHReplyBody *)[chData.replyDataSource objectAtIndex:i];
        
        NSString *mactchString = nil;
        if ([body.replyInfo isEqualToString:@""]) {
            mactchString = [NSString stringWithFormat:@"%@:",body.replyUser,body.replyInfo];
            
        }else
        {
            mactchString = [NSString stringWithFormat:@"%@->%@:%@",body.replyUser,body.repliedUser,body.replyInfo];
        }
        
        [chCoreText setOldString:mactchString andNewString:[chData.completionReplySource objectAtIndex:i]];
        
        chCoreText.frame = CGRectMake(offSet_X,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_y/3) + orgin_y + hhh + kDistance + (chData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance + chData.favourHeight + (chData.favourHeight == 0?0:kReply_FavourDistance), screenWidth - offSet_X * 2, [chCoreText getTextHeight]);
        
        [self.contentView addSubview:chCoreText];
        
        orgin_y += [chCoreText getTextHeight]+5;
        backView_H += chCoreText.frame.size.height;
        
        [_chTextArray addObject:chCoreText];
        
    }
    backView_H += (chData.replyDataSource.count -1)*5;
    
    
    if (chData.replyDataSource.count ==0) {
        replyImageView.frame = CGRectMake(offSet_X, backView_y - 10 + balanceHeight + 5 + kReplyBtnDistance, 0, 0);
        _replyButton.frame = CGRectMake(screenWidth - offSet_X - 40 + 6,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_y/3) + orgin_y + hhh + kDistance + (chData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24, 40, 18);
        
    }else{
        
        replyImageView.frame = CGRectMake(offSet_X, backView_y - 10 + balanceHeight + 5 + kReplyBtnDistance, screenWidth - offSet_X * 2, backView_H + 20 - 8);//微调
        
        _replyButton.frame = CGRectMake(screenWidth - offSet_X - 40 + 6, replyImageView.frame.origin.y - 24, 40, 18);
        
        
    }
}


-(void)clickMyself:(NSString *)clickString
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:clickString message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        
        
    });
}

-(void)longClickedCHCoretext:(NSString *)clickstring replyIndex:(NSInteger)index
{
    if (index == -1) {
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        pasteBoard.string = clickstring;
    }else{
        [_delegate longClickRichTexxt:_stamp reply:index];
    }
}

-(void)clickCHCoretext:(NSString *)clickString replyIndex:(NSInteger)index
{
    if ([clickString isEqualToString:@""] && index != -1) {
        [_delegate clickRichText:_stamp replyIndex:index];
    }else{
        if ([clickString isEqualToString:@""]) {
            
        }else{
            [CHHudView showMessage:clickString inView:nil];
        }
    }
}
-(void)tapImageV:(CHTapGestureRecognizer *)tapGes
{
    [_delegate showImageViewWithImageViews:tapGes.appendArray byClickWhich:tapGes.view.tag];
}

@end
