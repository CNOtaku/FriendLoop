//
//  CHReplyInputView.m
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/18.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//

#import "CHReplyInputView.h"
#import "Header.h"


@interface NSString (CHReplyInputView)


@end
@implementation NSString (CHReplyInputView)

-(CGSize)sizeForFont:(UIFont *)font
{
    if ([self respondsToSelector:@selector(sizeWithAttributes:)]) {
        NSDictionary *attrs = @{
                                NSFontAttributeName:font
                                };
        return [self sizeWithAttributes:attrs];
    }
    return ([self sizeWithAttributes:@{NSFontAttributeName:font}]);
}

-(CGSize)sizeFont:(UIFont *)font constrainedToSize:(CGSize)constraint lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize size;
    if ([self respondsToSelector:@selector(sizeWithAttributes:)]) {
        NSDictionary *attributes = @{NSFontAttributeName:font};
        CGSize boundingBox = [self boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    }else{
    
//        [self sizeWithFont:<#(UIFont *)#> constrainedToSize:<#(CGSize)#> lineBreakMode:<#(NSLineBreakMode)#>]
        size = [self boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    }
    return size;
}

@end


@implementation CHReplyInputView
@synthesize inputBackgroundView;
@synthesize textViewbackgroundView;
@synthesize textView;
@synthesize labelPlaceHolder;
@synthesize sendButton;
@synthesize keyboardHeight;


-(void)awakeFromNib
{
    [super awakeFromNib];
    [self composeView];
}
-(void)composeView
{
    
    keyboardAnimationDuration = 0.4f;
    self.keyboardHeight = 216;
    topGap = 8;
    
    inputHeight = 38.f;
    inputHeightWithShadow = 44.f;
    _autoResizeOnKeyboardVisibilityChanged = NO;
    
    CGSize size = self.frame.size;
    
    inputBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    inputBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    inputBackgroundView.contentMode = UIViewContentModeScaleToFill;
    inputBackgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:inputBackgroundView];
    
    textViewbackgroundView = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    textViewbackgroundView.borderStyle = UITextBorderStyleRoundedRect;
    textViewbackgroundView.autoresizingMask = UIViewAutoresizingNone;
    textViewbackgroundView.userInteractionEnabled = NO;
    textViewbackgroundView.enabled = NO;
    [self addSubview:textViewbackgroundView];
    
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(70.f, topGap, 185+screenWidth-320, 0)];
    textView.backgroundColor = [UIColor clearColor];
    textView.delegate = self;
    textView.contentInset = UIEdgeInsetsMake(-4, -2, -4, 0);
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    textView.returnKeyType = UIReturnKeySend;
    textView.font = [UIFont systemFontOfSize:15.f];
    [self addSubview:textView];
    
    [self adjustTextInputHeightForText:@"" animated:NO];
    
    labelPlaceHolder = [[UILabel alloc]initWithFrame:CGRectMake(78.f, topGap +2, 160, 20)];
    labelPlaceHolder.font = [UIFont systemFontOfSize:15.f];
    labelPlaceHolder.text = @"Commit...";
    labelPlaceHolder.textColor = [UIColor lightGrayColor];
    labelPlaceHolder.backgroundColor = [UIColor clearColor];
    [self addSubview:labelPlaceHolder];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[[UIImage imageNamed:@"button_send_comment.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:22] forState:UIControlStateNormal];
    sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
    [sendButton addTarget:sendButton action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
    [self addSubview:sendButton];
    self.backgroundColor =[UIColor colorWithRed:(0xD9/255.f) green:(0xDC/255.f) blue:(0xE0/255.f) alpha:1.f];
    
    [self showCommentView];
    

}
-(void)showCommentView
{
    self.hidden = NO;
    tapView.hidden = NO;
    tapView.alpha = 0.6;
    _autoResizeOnKeyboardVisibilityChanged = YES;
    [self.textView becomeFirstResponder];
    [self beganEditing];
}
-(void)beganEditing
{
    if (_autoResizeOnKeyboardVisibilityChanged) {
        UIViewAnimationOptions opt = animationOptionsWithCurve(keyboardAnimationCurve);
        [UIView animateWithDuration:keyboardAnimationDuration delay:0 options:opt animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, -self.keyboardHeight);
        } completion:^(BOOL finished) {
            
        }];
        
        [self fitText];
    }
}

-(void)endedEditing
{
    if (_autoResizeOnKeyboardVisibilityChanged) {
        UIViewAnimationOptions opt = animationOptionsWithCurve(keyboardAnimationCurve);
        [UIView animateWithDuration:keyboardAnimationDuration delay:0 options:opt animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, -self.keyboardHeight);
        } completion:^(BOOL finished) {
            
        }];
        
        [self fitText];
    }
}

-(void)fitText
{

    [self adjustTextInputHeightForText:textView.text animated:YES];
}


static inline UIViewAnimationOptions animationOptionsWithCurve(UIViewAnimationCurve curve)
{
    UIViewAnimationOptions opt = (UIViewAnimationOptions)curve;
    return opt <<16;
}

-(void)adjustTextInputHeightForText:(NSString *)text animated:(BOOL)animated
{
    int h1 = [text sizeForFont:textView.font].height;
    int h2 = [text sizeFont:textView.font constrainedToSize:CGSizeMake(textView.frame.size.width -16, 170.f) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    [UIView animateWithDuration:(animated?.1f:0) animations:^{
        int h = h2==h1?inputHeightWithShadow:h2+24;
        
        if (h>78) {
            h = 78;
        }
        
        int delta = h - self.frame.size.height;
        
        CGRect r2 = CGRectMake(0, self.frame.origin.y-delta,self.frame.size.width , h);
        self.frame = r2;
        inputBackgroundView.frame = CGRectMake(0, 0, self.frame.size.width, h);
        CGRect r = textView.frame;
        r.origin.y = topGap;
        r.size.height = h-18;
        textView.frame = r;
    } completion:^(BOOL finished) {
        
    }];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    UILabel *dividLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    dividLabel.backgroundColor = [UIColor colorWithRed:227/255.f green:227/255.f blue:227/255.f alpha:1.f];
    [self addSubview:dividLabel];
    
    self.backgroundColor = [UIColor whiteColor];
    
    textView.frame = CGRectMake(5, textView.frame.origin.y, screenWidth-10-65, textView.frame.size.height);
    CGRect f = textView.frame;
    
    f.size.height = f.size.height+3;
    textViewbackgroundView.frame = f;
    labelPlaceHolder.frame = CGRectMake(8, topGap+2, 230, 20);
    labelPlaceHolder.backgroundColor = [UIColor clearColor];
    sendButton.frame = CGRectMake(screenWidth-10-55, textView.frame.origin.y, 55, 27);
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (!newSuperview) {
        [self lisenForKeyboardNotification:NO];
        
    }else{
    
        [self lisenForKeyboardNotification:YES];
    }
}
-(void)lisenForKeyboardNotification:(BOOL)listen
{
    
    if (listen) {
        [self lisenForKeyboardNotification:NO];
    
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        
    }else{
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    }

}

-(void)keyboardWillShow:(NSNotification *)n
{
    _autoResizeOnKeyboardVisibilityChanged = YES;
    [self updateKeyboardProperties:n];
}
-(void)keyboardWillHide:(NSNotification *)n
{
    [self updateKeyboardProperties:n];
    
}
-(void)keyboardDidShow:(NSNotification *)n
{
    if ([textView isFirstResponder]) {
        [self beganEditing];
    }
}
-(void)keyboardDidHide:(NSNotification *)n
{

}
-(void)updateKeyboardProperties:(NSNotification *)noti
{
    NSNumber *d = [[noti userInfo]objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    if (d!=nil &&[d isKindOfClass:[NSNumber class]]) {
        keyboardAnimationDuration = [d floatValue];
    }
    
    d = [[noti userInfo]objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    if (d!=nil &&[d isKindOfClass:[NSNumber class]]) {
        keyboardAnimationCurve = [d integerValue];
    }
    
    NSValue *v = [[noti userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    if ([v isKindOfClass:[NSValue class]]) {
        CGRect r = [v CGRectValue];
        r = [self.window convertRect:r toView:self];
        self.keyboardHeight = r.size.height;
    }

}
-(BOOL)resignFirstResponder
{
    if (super.isFirstResponder) {
        return [super resignFirstResponder];
    }else if ([textView isFirstResponder])
    {return [textView resignFirstResponder];
    }
    return NO;

}

-(NSString *)text
{
    return textView.text;
}
-(void)setText:(NSString *)text
{
    textView.text = text;
    labelPlaceHolder.hidden = text.length>0;
    [self fitText];
}

-(void)setPlaceHolder:(NSString *)text
{
    labelPlaceHolder.text = text;
}
-(void)sendButtonClicked:(UIButton *)button
{
    if ([textView.text isEqualToString:@""]) {
        return;
    }
    [_delegate CHReplyInputWithReply:textView.text appendTag:_replyTag];
    [self disappear];
}


#pragma mark delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self beganEditing];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self endedEditing];
    _autoResizeOnKeyboardVisibilityChanged = NO;
}

-(BOOL)textView:(UITextView *)textview shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self performSelector:@selector(returnButtonPressed:) withObject:nil afterDelay:1];
        
        
        return NO;
    }
    else if (range.location >=140||range.location +text.length>140)
    {
        return YES;
    }
    else if (text.length>0)
    {
        [self adjustTextInputHeightForText:[NSString stringWithFormat:@"%@%@", textview.text,text] animated:YES];
    }
    return YES;
    
}


-(void)textViewDidChange:(UITextView *)textview
{
    labelPlaceHolder.hidden = textview.text.length>0;
    [self fitText];
    
    if (textview.text.length == 141) {
        
    }
}
-(void)returnButtonPressed:(id)sender
{
    [self sendButtonClicked:sender];
}

-(void)disappear
{
    [self endedEditing];
    self.hidden =YES;
    tapView.hidden = YES;
    tapView.alpha = 1;
    _autoResizeOnKeyboardVisibilityChanged = NO;
    
    [self.textView resignFirstResponder];
    
    [_delegate destroySelf];
}

@end
