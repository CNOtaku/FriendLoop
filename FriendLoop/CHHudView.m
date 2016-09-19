//
//  CHHudView.m
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/13.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//


#import "CHHudView.h"

@implementation CHHudView


-(instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

+(void)showMessage:(NSString *)msg inView:(UIView *)theView
{
    CHHudView *alert = [[CHHudView alloc]initWithMsg:msg];
    if (!theView) {
        [[self getUnhiddenFrontWindowOfApplication] addSubview:alert];
    }else{
        [[CHHudView getWindow] addSubview:alert];
    }
    [alert showAlert];
    
}

-(void)showAlert
{
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    self.alpha = 0.0;
    CGPoint center = [CHHudView getWindow].center;
    
    self.center = center;
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    
    
    opacityAnimation.duration = _totalDuartion;
    opacityAnimation.cumulative = YES;
    opacityAnimation.repeatCount = 1;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeBoth;
    opacityAnimation.values = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.2],
                               [NSNumber numberWithFloat:0.92],
                               [NSNumber numberWithFloat:0.92],
                               [NSNumber numberWithFloat:0.1],nil];
    
    opacityAnimation.keyTimes = [NSArray arrayWithObjects:
                                 [NSNumber numberWithFloat:0.0],
                                [NSNumber numberWithFloat:0.08],
                                 [NSNumber numberWithFloat:0.92],
                                 [NSNumber numberWithFloat:1.0],nil];
    
    
    opacityAnimation.timingFunctions = [NSArray arrayWithObjects:
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],nil];
    
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = _totalDuartion;
    scaleAnimation.cumulative = YES;
    scaleAnimation.repeatCount = 1;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    scaleAnimation.values = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:self.animationTopScale],
                             [NSNumber numberWithFloat:1.0],
                             [NSNumber numberWithFloat:self.animationTopScale],
                             nil];
    
    
    scaleAnimation.keyTimes = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0],
                               [NSNumber numberWithFloat:0.085],
                               [NSNumber numberWithFloat:0.92],
                               [NSNumber numberWithFloat:1.0],
                               nil];
    
    
    scaleAnimation.timingFunctions = [NSArray arrayWithObjects:
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                      nil];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = _totalDuartion;
    group.delegate = self;
    group.animations = [NSArray arrayWithObjects:opacityAnimation,scaleAnimation, nil];
    
    [self.layer addAnimation:group forKey:@"group"];
    
    
    
    

}
+(UIWindow *)getWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}


+(UIWindow *)getUnhiddenFrontWindowOfApplication
{
    NSArray *windows = [[UIApplication sharedApplication]windows];
    NSInteger windowCount = [windows count];
    for (NSInteger i = windowCount -1; i>=0; i--) {
        UIWindow *window = [windows objectAtIndex:i];
        if (window.hidden == FALSE) {
            if (window.frame.size.height>50.f) {
                return window;
            }
        }
    }
    return NULL;
}


-(instancetype)initWithMsg:(NSString *)message
{
    if (self = [super init]) {
        self.msg = message;
        self.leftMargin = 20;
        self.topMargin = 10;
        self.totalDuartion = 1.2f;
        self.animationTopScale = 1.2;
        self.animationLeftScale = 1.2f;
        msgFont = [UIFont systemFontOfSize:14];
        CGSize textSize = [self getSizeFromString:self.msg];
        
        self.bounds = CGRectMake(0, 0, 160, 50);
        self.labelText = [[UILabel alloc]init];
        self.labelText.text = message;
        self.labelText.numberOfLines = 0;
        self.labelText.font = msgFont;
        self.labelText.backgroundColor = [UIColor clearColor];
        self.labelText.textColor = [UIColor whiteColor];
        self.labelText.textAlignment = NSTextAlignmentCenter;
        [self.labelText setFrame:CGRectMake((160-textSize.width)/2, 18, textSize.width, textSize.height)];
        
        if ([self getSizeFromString:message].height > 32) {
            [self.labelText setFrame:CGRectMake((160-textSize.width)/2, 18, textSize.width, textSize.height)];
            
        }
        
        [self addSubview:self.labelText];
        self.layer.cornerRadius = 10;
                                            
        
        
    }
    return self;
}

-(CGSize)getSizeFromString:(NSString *)theString
{
    UIFont *theFont = msgFont;
    CGSize size = CGSizeMake(160, 2000);
    NSDictionary *att = @{NSFontAttributeName:theFont};
    CGSize tempSize = [theString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil].size;
    

    return tempSize;
}
@end
