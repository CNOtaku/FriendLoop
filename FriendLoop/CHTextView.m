//
//  CHTextView.m
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/14.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//

#import "CHTextView.h"

#import <CoreText/CoreText.h>

#import "CHHudView.h"
#import "NSString+Replace.h"
#import "NSArray+Extension.h"
#import "CHRegularExpressionManager.h"


#import "Header.h"

#define FontHeight 15.f
#define ImageLeftPadding 2.f
#define ImageTopPadding 3.f
#define FontSize FontHeight
#define LineSpacing 10.f
#define EmotionImageWidth FontHeight


@implementation CHTextView
{
    NSString *_oldString;
    NSString *_newString;
    
    NSMutableArray *_selectionViews;
    
    CTTypesetterRef typeSetter;
    CTFontRef helvetica;
}

@synthesize isDraw = _isDraw;


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _selectionViews = [NSMutableArray arrayWithCapacity:0];
        _isFold = YES;
        _canClickAll = YES;//默认可点击全部
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMySelf:)];
        
        [self addGestureRecognizer:tapGes];
        
        _replyIndex  = -1;//默认-1,代表点击的是整个区域
        
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressMyself:)];
        [self addGestureRecognizer:longGes];
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    
    }
    
    
    return self;

}
-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
}
-(void)setOldString:(NSString *)oldString andNewString:(NSString *)newString
{
    _oldString = oldString;
    _newString = newString;
    
    [self cookEmotionString];
}
-(void)cookEmotionString
{
    NSArray *itemIndexes = [CHRegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:_oldString];
    NSArray *names = nil;
    NSArray *newRanges = nil;
    
    names = [_oldString itemsFromPattern:EmotionItemPattern captureGroupIndex:1];
    
    newRanges = [itemIndexes offsetRangesInArrayBy:[PlaceHolder length]];
    
    _emotionNames = names;
    _attrEmotionString = [self createAttributedEmotionStringWithRanges:newRanges forString:_newString];
    typeSetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)(_attrEmotionString));
    
    if (_isDraw == NO) {
        return;
    }
    [self setNeedsDisplay];
}

-(NSAttributedString *)createAttributedEmotionStringWithRanges:(NSArray *)ranges forString:(NSString *)aString
{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:aString];
    helvetica = CTFontCreateWithName(CFSTR("Helvetica"), FontSize, NULL);
    [attrString addAttribute:(id)kCTFontAttributeName value:(id)CFBridgingRelease(helvetica) range:NSMakeRange(0,[attrString length])];
    
    [attrString addAttribute:(id)kCTForegroundColorAttributeName value:(id)([UIColor blackColor].CGColor) range:NSMakeRange(0, [attrString length])];
    
    if (_textColor == nil) {
        _textColor = [UIColor blueColor];
        
    }
    
    for (int i = 0; i < _attributedData.count; i++) {
        NSString *str = [[[_attributedData objectAtIndex:i] allKeys]objectAtIndex:0];
        
        [attrString addAttribute:(id)kCTForegroundColorAttributeName value:(id)(_textColor.CGColor) range:NSRangeFromString(str)];
        
    }
    
    for (int i = 0; i < [ranges count]; i++) {
        NSRange range = NSRangeFromString([ranges objectAtIndex:i]);
        NSString *emotionName = [self.emotionNames objectAtIndex:i];
        [attrString addAttribute:AttributedImageNameKey value:emotionName range:range];
        [attrString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)newEmotionRunDeleagte() range:range];
    }
    return attrString;
}


CTRunDelegateRef newEmotionRunDeleagte()
{
    static NSString *emotionRunName = @"emotionRunName";
    
    CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = CHRunDelegateDeallocCallBack;
    imageCallbacks.getAscent = CHRunDelegateGetAscentCallback;
    imageCallbacks.getDescent = CHRunDelegateGetDescentCallback;
    imageCallbacks.getWidth = CHRunDelegateGetWidthCallBack;
    
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void *)(emotionRunName));
    
    return runDelegate;
}

void CHRunDelegateDeallocCallBack(void *refCon){


}

CGFloat CHRunDelegateGetAscentCallback(void *refCon){
    return FontHeight;
}
CGFloat CHRunDelegateGetDescentCallback(void *refCon){
    return 0.0;
}
CGFloat CHRunDelegateGetWidthCallBack(void *refCon){
    return 19.0;
}


-(void)drawRect:(CGRect)rect
{
    if (!typeSetter) {
        return;
    }
    
    CGFloat w = CGRectGetWidth(self.frame);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIGraphicsPushContext(context);
    
    Flip_context(context, FontHeight);
    
    CGFloat y = 0;
    CFIndex start = 0;
    NSInteger legth = [_attrEmotionString length];
    int tempK = 0;
    while (start < legth) {
        CFIndex count = CTTypesetterSuggestClusterBreak(typeSetter, start,w);
        CTLineRef line = CTTypesetterCreateLine(typeSetter, CFRangeMake(start, count));
        CGContextSetTextPosition(context, 0, y);
        
        //画字
        CTLineDraw(line, context);
        //画表情
        DrawEmojiForLine(context, line, self, CGPointMake(0, y));
        start += count;
        y-=FontSize + LineSpacing;
        
        CFRelease(line);
        tempK ++;
        if (tempK == limitline) {
            _limitCharIndex = start;
        }
        
        
        
    }
    UIGraphicsPopContext();
}


//反转坐标系
static inline
void Flip_context(CGContextRef context, CGFloat offset)
{
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -offset);
}
-(void)dealloc
{
    if (typeSetter != NULL) {
        CFRelease(typeSetter);
    }
}

static inline
CGPoint EmojiOrginForLine(CTLineRef line, CGPoint lineOrgin, CTRunRef run)
{
    CGFloat x = lineOrgin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL) +ImageLeftPadding;
    CGFloat y = lineOrgin.y - ImageTopPadding;
    
    return CGPointMake(x, y);
}
void DrawEmojiForLine(CGContextRef context, CTLineRef line, id ower, CGPoint lineOrgin)
{
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    
    NSUInteger count = CFArrayGetCount(runs);
    
    for (NSUInteger i = 0; i < count; i++) {
        CTRunRef aRun = CFArrayGetValueAtIndex(runs, i);
        CFDictionaryRef attributes  = CTRunGetAttributes(aRun);
        
        NSString *emojiName = (NSString *)CFDictionaryGetValue(attributes, AttributedImageNameKey);
        
        if (emojiName) {
            CGRect imageRect = CGRectZero;
            imageRect.origin = EmojiOrginForLine(line, lineOrgin, aRun);
            imageRect.size = CGSizeMake(EmotionImageWidth, EmotionImageWidth);
            CGImageRef image = [[ower getEmotionForKey:emojiName] CGImage];
            CGContextDrawImage(context, imageRect, image);
        }
    }
}
-(UIImage *)getEmotionForKey:(NSString *)key
{
    NSString *nameStr = [NSString stringWithFormat:@"%@.png",key];
    return [UIImage imageNamed:nameStr];
    
}

-(float)getTextHeight
{
    CGFloat w = CGRectGetWidth(self.frame);
    CGFloat y = 0;
    CFIndex start = 0;
    NSInteger length = [_attrEmotionString length];
    int tempK  = 0;
    while (start < length) {
        CFIndex count = CTTypesetterSuggestClusterBreak(typeSetter, start, w);
        CTLineRef line = CTTypesetterCreateLine(typeSetter, CFRangeMake(start, count));
        start += count;
        y-=FontSize + LineSpacing;
        CFRelease(line);
        tempK ++;
        if (tempK == limitline &&_isFold ==YES) {
            break;
        }
    }
    return -y;
}

-(int)getTextLines
{
    int textLines = 0;
    CGFloat w = CGRectGetWidth(self.frame);
    CGFloat y = 0;
    CFIndex start  = 0;
    NSInteger length = [_attrEmotionString length];
    
    while (start < length) {
        CFIndex count = CTTypesetterSuggestClusterBreak(typeSetter, start, w);
        CTLineRef line = CTTypesetterCreateLine(typeSetter, CFRangeMake(start, count));
        start += count;
        y -= FontSize +LineSpacing;
        
        CFRelease(line);
        textLines++;
    }
    return textLines;
}


#pragma mark ========点击事件
-(void)tapMySelf:(UITapGestureRecognizer *)gesture
{
    [self manageGesture:gesture gestureType:TapGesType];

}

-(void)longPressMyself:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self manageGesture:gesture gestureType:LongGesType];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self removeLongClickArea];
    }
}
-(void)manageGesture:(UIGestureRecognizer *)gesture gestureType:(GestureType)gestureType
{
    CGPoint point = [gesture locationInView:self];
    
    CGFloat w = CGRectGetWidth(self.frame);
    CGFloat y = 0;
    CFIndex start = 0;
    NSInteger length = [_newString length];
    
    BOOL isSelected =NO;
    
    while (start < length) {
        CFIndex count = CTTypesetterSuggestClusterBreak(typeSetter, start, w);
        CTLineRef line = CTTypesetterCreateLine(typeSetter, CFRangeMake(start, count));
        CGFloat ascent, descent;
        CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
        CGRect lineFrame = CGRectMake(0, -y, lineWidth, ascent +descent);
        
        if (CGRectContainsPoint(lineFrame, point)) {
            CFIndex index = CTLineGetStringIndexForPosition(line, point);
            if ([self judgeIndexInSelectedRange:index withWorkLine:line] ==YES) {
                isSelected = YES;
            }else{
            
            }
        }
        
        start += count;
        y -= FontSize + LineSpacing;
        CFRelease(line);
    }
    if (isSelected == YES) {
        DELAYEXECUTE(0.3, [_selectionViews makeObjectsPerformSelector:@selector(removeFromSuperview)]);
    }else
    {
        if (gestureType  == TapGesType) {
            if (_canClickAll == YES) {
                [self clickAllContext];
            }else{
            
            }
        }else{
            if (_canClickAll == YES) {
                [self longClickAllContext];
            }else{
            }
        
        }
        
        return;
    }
    DELAYEXECUTE(0.3, [_selectionViews makeObjectsPerformSelector:@selector(removeFromSuperview)]);

}

-(void)clickAllContext
{
    UIView *myselfSelected = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    myselfSelected.tag = 10102;
    [self insertSubview:myselfSelected belowSubview:self];
    myselfSelected.backgroundColor = kSelf_SelectedColor;
    [_delegate clickCHCoretext:@"" replyIndex:_replyIndex];
    
    DELAYEXECUTE(0.3, {
        if ([self viewWithTag:10102]) {
            [[self viewWithTag:10102]removeFromSuperview];
        }
    });
    

}
-(void)longClickAllContext
{
    UIView *myselfSelected = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    myselfSelected.tag = 10102;
    [self insertSubview:myselfSelected belowSubview:self];
    myselfSelected.backgroundColor = kSelf_SelectedColor;
    if (_replyIndex == -1) {
        [_delegate longClickedCHCoretext:_oldString replyIndex:_replyIndex];
    }else{
        [_delegate longClickedCHCoretext:@"" replyIndex:_replyIndex];
    }
    

}
-(BOOL)judgeIndexInSelectedRange:(CFIndex)index withWorkLine:(CTLineRef)workLine
{
    for (int i =0; i< _attributedData.count; i++) {
        NSString *key = [[[_attributedData objectAtIndex:i] allKeys] objectAtIndex:0];
        NSRange keyRange = NSRangeFromString(key);
        if (index >= keyRange.location &&index <= keyRange.location + keyRange.length) {
            if (_isFold) {
                if ((_limitCharIndex > keyRange.location)&&(_limitCharIndex < keyRange.location +keyRange.length)) {
                    keyRange = NSMakeRange(keyRange.length, _limitCharIndex-keyRange.location);
                }
            }else{
            
            }
            NSMutableArray *arr = [self getSelectedCGRectWithClickRange:keyRange];
            [self drawViewFromRects:arr withDictValue:[[_attributedData objectAtIndex:i] valueForKey:key]];
            
            NSString *feedString = [[_attributedData objectAtIndex:i]valueForKey:key];
            [_delegate clickCHCoretext:feedString replyIndex:_replyIndex];
            return YES;
        }
    }
    
    return NO;
}

-(void)drawViewFromRects:(NSArray *)array withDictValue:(NSString *)value
{
    for (int i = 0; i<[array count]; i++) {
        UIView *selectedView = [UIView new];
        selectedView.frame = CGRectFromString([array objectAtIndex:i]);
        selectedView.backgroundColor = kUserName_SelectedColor;
        selectedView.layer.cornerRadius = 4;
        [self addSubview:selectedView];
        [_selectionViews addObject:selectedView];
    }
}
-(NSMutableArray *)getSelectedCGRectWithClickRange:(NSRange)tempRange
{
    NSMutableArray *clickRects = [[NSMutableArray alloc]init];
    CGFloat w = CGRectGetWidth(self.frame);
    CGFloat y = 0;
    CFIndex start = 0;
    NSInteger length = [_attrEmotionString length];
    
    while (start < length) {
        CFIndex count = CTTypesetterSuggestClusterBreak(typeSetter, start, w);
        CTLineRef line = CTTypesetterCreateLine(typeSetter, CFRangeMake(start, count));
        
        start += count;
        
        CFRange lineRange = CTLineGetStringRange(line);
        NSRange range = NSMakeRange(lineRange.location == kCFNotFound? NSNotFound:lineRange.location, lineRange.length);
        NSRange intersection = [self rangeIntersection:range withSecond:tempRange];
        
        if (intersection.length > 0) {
            CGFloat xStart = CTLineGetOffsetForStringIndex(line, intersection.location, NULL);
            CGFloat xEnd = CTLineGetOffsetForStringIndex(line, intersection.location+intersection.length, NULL);
            CGFloat ascent, descent;
            
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            
            
            CGRect selectionRect = CGRectMake(xStart, -y, xEnd - xStart, ascent+descent+2);
            [clickRects addObject:NSStringFromCGRect(selectionRect)];
            
        }
        
        y -=FontSize + LineSpacing;
        CFRelease(line);
    }
    return clickRects;

}

-(NSRange)rangeIntersection:(NSRange)first  withSecond:(NSRange)second
{
    NSRange result = NSMakeRange(NSNotFound, 0);
    if (first.location >second.location) {
        NSRange tmp = first;
        first = second;
        second = tmp;
    }
    if (second.location < first.location+first.length) {
        result.location = second.location;
        NSUInteger end = MIN(first.location+first.length, second.location +second.length);
        result.length = end -result.location;
    }
    return result;
}
-(void)removeLongClickArea
{
    
    if ([self viewWithTag:10102]) {
        [[self viewWithTag:10102]removeFromSuperview];
        
    }
    [CHHudView  showMessage:@"复制成功" inView:nil];


}
@end
