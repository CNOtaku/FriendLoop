//
//  CHPopView.m
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/14.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//

#import "CHPopView.h"

#define kOperationViewSize CGSizeMake(120, 34)
#define kSpatorY 5

@interface CHPopView ()

@property(nonatomic, strong)UIButton *replyButton;
@property(nonatomic, strong)UIButton *likeButton;
@property(nonatomic, assign)CGRect targetRect;

@end
@implementation CHPopView

+(instancetype)initalizerCHOperationView
{
    CHPopView *operationView = [[CHPopView alloc]initWithFrame:CGRectZero];
    return operationView;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0;
        [self addSubview:self.replyButton];
        [self addSubview:self.likeButton];
    }
    
    return self;
}

-(UIButton *)replyButton
{
    if (!_replyButton) {
        _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyButton.tag = 1001;
        [_replyButton addTarget:self action:@selector(operationDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _replyButton.frame = CGRectMake(0, 0, kOperationViewSize.width/2.0, kOperationViewSize.height);
        [_replyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _replyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _replyButton;
}

-(UIButton *)likeButton
{
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.tag = 1002;
        [_likeButton addTarget:self action:@selector(operationDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _likeButton.frame = CGRectMake(kOperationViewSize.width/2.0, 0, kOperationViewSize.width/2.0, kOperationViewSize.height);
        [_likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _likeButton;

}


-(void)operationDidClicked:(UIButton *)sender
{
    [self dissMiss];
    
    if (self.didSelectedOpeartionCompletion) {
        self.didSelectedOpeartionCompletion(sender.tag);
    }

}


-(void)showAtView:(UIView *)containerView rect:(CGRect)targetRect isFavor:(BOOL)isFavor
{
    self.targetRect = targetRect;
    if (self.shouldShowed) {
        return;
    }
    
    [containerView addSubview:self];
    
    CGFloat width = kOperationViewSize.width;
    CGFloat height = kOperationViewSize.height;
    
    self.frame = CGRectMake(targetRect.origin.x, targetRect.origin.y-kSpatorY, 0, height);
    self.shouldShowed = YES;
    __weak __typeof__(self) weakSelf = self;
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.frame = CGRectMake(targetRect.origin.x-width, targetRect.origin.y-kSpatorY, width, height);
        
        
    } completion:^(BOOL finished) {
        [weakSelf.replyButton setTitle:@"评论" forState:UIControlStateNormal];
        [weakSelf.likeButton setTitle:(isFavor?@"取消赞":@"赞") forState:UIControlStateNormal];
    }];
}

-(void)dissMiss
{
    if (!self.shouldShowed) {
        return;
    }
    
    __weak __typeof__(self) weakSelf = self;
    
    [UIView animateWithDuration:0.25f animations:^{
        [weakSelf.replyButton setTitle:nil forState:UIControlStateNormal];
        [weakSelf.likeButton setTitle:nil forState:UIControlStateNormal];
        
        
        self.frame = CGRectMake(self.targetRect.origin.x, self.targetRect.origin.y-kSpatorY, 0, kOperationViewSize.height);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}
@end
