//
//  CHShowImageView.h
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/19.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didRemoveImage) (void);

@interface CHShowImageView : UIView<UIScrollViewDelegate>

{
    UIImageView *showImage;
    
}

@property(nonatomic,copy)didRemoveImage removeImage;

-(void)show:(UIView *)bgView didFinish:(didRemoveImage)tempBlock;
-(instancetype)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray;

@end
