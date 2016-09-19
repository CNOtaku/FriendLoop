//
//  CHShowImageView.m
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/19.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//

#import "CHShowImageView.h"

@implementation CHShowImageView
{
    UIScrollView *_scrollView;
    CGRect selfFrame;
    NSInteger page;
    BOOL doubleClcik;
}



-(instancetype)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.alpha = 0.0f;
        page = 0;
        doubleClcik = YES;
        
        [self configScrollViewWith:clickTag andAppendArray:appendArray];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapGesture];
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeBig:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGesture];
        [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
    }
    
    
 
    return self;
}

-(void)configScrollViewWith:(NSInteger)clickTag andAppendArray:(NSArray *)appendArray
{
    _scrollView = [[UIScrollView alloc]initWithFrame:selfFrame];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    _scrollView.contentSize = CGSizeMake(self.frame.size.width *appendArray.count, self.frame.size.height);
    [self addSubview:_scrollView];
    
    float w = self.frame.size.width;
    
    for (int i = 0; i< appendArray.count; i++) {
        UIScrollView *imageScrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(self.frame.size.width *i, 0, self.frame.size.width, self.frame.size.height)];
        imageScrollView.backgroundColor = [UIColor blackColor];
        imageScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        imageScrollView.delegate = self;
        imageScrollView.maximumZoomScale = 4;
        imageScrollView.minimumZoomScale = 1;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",appendArray[i]]];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageScrollView addSubview:imageView];
        [_scrollView addSubview:imageScrollView];
        
        imageScrollView.tag = 100+i;
        imageView.tag = 1000+i;
        
    }
    
    [_scrollView setContentOffset:CGPointMake(w*(clickTag - 9999), 0) animated:YES];
    page = clickTag -9999;
}

-(void)disappear
{

    _removeImage();
}
-(void)changeBig:(UITapGestureRecognizer *)tapGesture
{
    CGFloat newScale = 1.9;
    UIScrollView *currentScrollView = (UIScrollView*)[self viewWithTag:page +100];
    
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[tapGesture locationInView:tapGesture.view] addScrollView:currentScrollView];
    
    if (doubleClcik == YES) {
        [currentScrollView zoomToRect:zoomRect animated:YES];
    }else
    {
        [currentScrollView zoomToRect:currentScrollView.frame animated:YES];
    }

    doubleClcik = !doubleClcik;
}

-(CGRect)zoomRectForScale:(CGFloat)newScale withCenter:(CGPoint)center addScrollView:(UIScrollView *)scrollV
{
    CGRect zoomRect = CGRectZero;
    
    zoomRect.size.height = scrollV.frame.size.height/newScale;
    zoomRect.size.width = scrollV.frame.size.width/newScale;
    zoomRect.origin.x = center.x - (zoomRect.size.width/2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height/2.0);
    
    return zoomRect;
    
}



-(void)show:(UIView *)bgView didFinish:(didRemoveImage)tempBlock
{
    [bgView addSubview: self];
    _removeImage = tempBlock;
    
    [UIView animateWithDuration:0.4f animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark ScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView *imageV = (UIImageView *)[self viewWithTag:scrollView.tag +900];
    return imageV;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = _scrollView.contentOffset;
    page = offset.x/self.frame.size.width;
    
    UIScrollView *nextScrollV = (UIScrollView *)[self viewWithTag:page +100 +1];
    
    if (nextScrollV.zoomScale !=1.0) {
        nextScrollV.zoomScale = 1.0;
    }
    
    UIScrollView *preScrollV = (UIScrollView *)[self viewWithTag:page +100 -1];
    
    if (preScrollV.zoomScale !=1.0) {
        preScrollV.zoomScale = 1.0;
    }

    
}
@end
