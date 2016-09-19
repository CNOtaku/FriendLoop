//
//  CHReplyInputView.h
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/18.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol InputDelegate <NSObject>

-(void)CHReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag;
-(void)destroySelf;

@end


@interface CHReplyInputView : UIView<UITextViewDelegate>
{
    CGFloat topGap;
    CGFloat keyboardAnimationDuration;
    
    UIViewAnimationCurve keyboardAnimationCurve;
    CGFloat keyboardHeight;
    int inputHeight;
    int inputHeightWithShadow;
    
    BOOL autoResizeOnKeyboardVisibilityChanged;
    UIView *tapView;
}


@property(nonatomic, strong)UIButton *sendButton;
@property(nonatomic, strong)UITextView *textView;
@property(nonatomic, strong)UILabel *labelPlaceHolder;
@property(nonatomic, strong)UIImageView *inputBackgroundView;
@property(nonatomic, strong)UITextField *textViewbackgroundView;
@property(nonatomic, assign)BOOL autoResizeOnKeyboardVisibilityChanged;
@property(nonatomic, readwrite)CGFloat keyboardHeight;
@property(nonatomic, assign)NSInteger replyTag;

@property(nonatomic, assign)id<InputDelegate>delegate;

-(NSString *)text;
-(void)setText:(NSString *)text;
-(void)setPlaceHolder:(NSString *)text;
-(void)showCommentView;
-(instancetype)initWithFrame:(CGRect)frame andAboveView:(UIView *)bgView;
-(void)disappear;

@end
