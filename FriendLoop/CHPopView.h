//
//  CHPopView.h
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/14.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CHOperationType){
    CHOperationTypeReply = 0,
    CHOperationTypeLike = 1,
};

typedef void(^DidSelectedOpeartionBlock)(CHOperationType operaType);

@interface CHPopView : UIView

@property(nonatomic, assign)BOOL shouldShowed;

@property(nonatomic, copy)DidSelectedOpeartionBlock didSelectedOpeartionCompletion;

+(instancetype)initalizerCHOperationView;

-(void)showAtView:(UIView *)containerView rect:(CGRect)targetRect isFavor:(BOOL)isFavor;

-(void)dissMiss;

@end
