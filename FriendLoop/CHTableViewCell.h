//
//  CHTableViewCell.h
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/19.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CHTextData.h"
#import "CHTextView.h"
#import "CHButton.h"


@protocol cellDelegate <NSObject>

-(void)changeFoldState:(CHTextData *)chData onCellInRow:(NSInteger)cellStamp;
-(void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag;
-(void)clickRichText:(NSInteger)index replyIndex:(NSInteger)replyIdex;
-(void)longClickRichTexxt:(NSInteger)index reply:(NSInteger)replyIndex;


@end

@interface CHTableViewCell : UITableViewCell<CHCoretextDelegate>


@property(nonatomic, strong)NSMutableArray *imageArray;

@property(nonatomic, strong)NSMutableArray *chTextArray;
@property(nonatomic, strong)NSMutableArray *chFavourArray;

@property(nonatomic, strong)NSMutableArray *chShuoshuoArray;


@property(nonatomic, strong)CHButton *replyButton;


@property(nonatomic, assign)id<cellDelegate>delegate;
@property(nonatomic, strong)UIImageView *favourImage;
@property(nonatomic, strong)UIImageView *userHeaderImage;

@property(nonatomic, strong)UILabel *userNameLabel;
@property(nonatomic, strong)UILabel *userIntroLabel;

@property(nonatomic, assign)NSInteger stamp;



-(void)setCHViewWith:(CHTextData *)chData;


@end
