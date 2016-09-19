//
//  CHHudView.h
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/13.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//


/**
 *  点击弹出视图
 *
 *  @return 框框~
 */


#import <UIKit/UIKit.h>

@interface CHHudView : UIView
{

    UIFont *msgFont;
}
@property(nonatomic, copy)NSString *msg;
@property(nonatomic, strong)UILabel *labelText;
@property(nonatomic, assign)float leftMargin;
@property(nonatomic, assign)float topMargin;
@property(nonatomic, assign)float animationLeftScale;
@property(nonatomic, assign)float animationTopScale;
@property(nonatomic, assign)float totalDuartion;

+(void)showMessage:(NSString *)msg inView:(UIView *)theView;

@end
