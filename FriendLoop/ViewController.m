//
//  ViewController.m
//  FriendLoop
//
//  Created by 楊利嘉 on 16/9/13.
//  Copyright © 2016年 楊利嘉. All rights reserved.
//

#import "ViewController.h"

#import "CHTableViewCell.h"
#import "Header.h"
#import "CHShowImageView.h"
#import "CHTextData.h"
#import "CHReplyInputView.h"
#import "CHReplyBody.h"
#import "CHMessageBody.h"
#import "CHPopView.h"
#import "CHActionSheet.h"


#define dataCount 10
#define kLocationToBottom 20
#define kAdmin @"July"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,cellDelegate,InputDelegate,UIActionSheetDelegate>
{
    NSMutableArray *_imageDataSource;
    NSMutableArray *_contentDataSource;
    NSMutableArray *_tableViewDataSource;
    NSMutableArray *_shuoshuoDataSource;
    UITableView *mainTable;
    UIView *popView;
    CHReplyInputView *replyInputView;
    NSInteger _replyIndex;
    
}


@property(nonatomic, strong)CHPopView *operationView;
@property(nonatomic, strong)NSIndexPath *selectedIndexPath;
@end

@implementation ViewController



- (void)configData{
    
    _tableViewDataSource = [[NSMutableArray alloc] init];
    _contentDataSource = [[NSMutableArray alloc] init];
    _replyIndex = -1;//代表是直接评论
    
    
    CHReplyBody *body1 = [[CHReplyBody alloc] init];
    body1.replyUser = kAdmin;
    body1.repliedUser = @"红领巾";
    body1.replyInfo = kContentText1;
    
    
    CHReplyBody *body2 = [[CHReplyBody alloc] init];
    body2.replyUser = @"迪恩";
    body2.repliedUser = @"";
    body2.replyInfo = kContentText2;
    
    
    CHReplyBody *body3 = [[CHReplyBody alloc] init];
    body3.replyUser = @"山姆";
    body3.repliedUser = @"";
    body3.replyInfo = kContentText3;
    
    
    CHReplyBody *body4 = [[CHReplyBody alloc] init];
    body4.replyUser = @"雷锋";
    body4.repliedUser = @"简森·阿克斯";
    body4.replyInfo = kContentText4;
    
    
    CHReplyBody *body5 = [[CHReplyBody alloc] init];
    body5.replyUser = kAdmin;
    body5.repliedUser = @"";
    body5.replyInfo = kContentText5;
    
    
    CHReplyBody *body6 = [[CHReplyBody alloc] init];
    body6.replyUser = @"红领巾";
    body6.repliedUser = @"";
    body6.replyInfo = kContentText6;
    
    
    CHMessageBody *messBody1 = [[CHMessageBody alloc] init];
    messBody1.posterContent = kShuoshuoText1;
    messBody1.posterPostImage = @[@"1.png",@"2.png",@"3.png"];
    messBody1.posterReplies = [NSMutableArray arrayWithObjects:body1,body2,body4, nil];
    messBody1.posterImageStr = @"mao.jpg";
    messBody1.posterName = @"迪恩·温彻斯特";
    messBody1.postertIntro = @"这个人很懒，什么都没有留下";
    messBody1.posterFavor = [NSMutableArray arrayWithObjects:@"路人甲",@"希尔瓦娜斯",kAdmin,@"鹿盔", nil];
    messBody1.isFavour = YES;
    
    CHMessageBody *messBody2 = [[CHMessageBody alloc] init];
    messBody2.posterContent = kShuoshuoText1;
    messBody2.posterPostImage = @[@"1.png",@"2.png",@"3.png"];
    messBody2.posterReplies = [NSMutableArray arrayWithObjects:body1,body2,body4, nil];
    messBody2.posterImageStr = @"mao.jpg";
    messBody2.posterName = @"山姆·温彻斯特";
    messBody2.postertIntro = @"这个人很懒，什么都没有留下";
    messBody2.posterFavor = [NSMutableArray arrayWithObjects:@"塞纳留斯",@"希尔瓦娜斯",@"鹿盔", nil];
    messBody2.isFavour = NO;
    
    
    CHMessageBody *messBody3 = [[CHMessageBody alloc] init];
    messBody3.posterContent = kShuoshuoText3;
    messBody3.posterPostImage = @[@"1.png",@"2.png",@"3.png",@"2.png",@"1.png",@"3.png"];
    messBody3.posterReplies = [NSMutableArray arrayWithObjects:body1,body2,body4,body6,body5,body4, nil];
    messBody3.posterImageStr = @"mao.jpg";
    messBody3.posterName = @"伊利丹怒风";
    messBody3.postertIntro = @"这个人很懒，什么都没有留下";
    messBody3.posterFavor = [NSMutableArray arrayWithObjects:@"路人甲",kAdmin,@"希尔瓦娜斯",@"鹿盔",@"黑手", nil];
    messBody3.isFavour = YES;
    
    CHMessageBody *messBody4 = [[CHMessageBody alloc] init];
    messBody4.posterContent = kShuoshuoText4;
    messBody4.posterPostImage = @[@"1.png",@"2.png",@"3.png",@"1.png",@"3.png"];
    messBody4.posterReplies = [NSMutableArray arrayWithObjects:body1, nil];
    messBody4.posterImageStr = @"mao.jpg";
    messBody4.posterName = @"基尔加丹";
    messBody4.postertIntro = @"这个人很懒，什么都没有留下";
    messBody4.posterFavor = [NSMutableArray arrayWithObjects:nil];
    messBody4.isFavour = NO;
    
    CHMessageBody *messBody5 = [[CHMessageBody alloc] init];
    messBody5.posterContent = kShuoshuoText5;
    messBody5.posterPostImage = @[@"1.png",@"2.png",@"3.png",@"3.png"];
    messBody5.posterReplies = [NSMutableArray arrayWithObjects:body2,body4,body5, nil];
    messBody5.posterImageStr = @"mao.jpg";
    messBody5.posterName = @"阿克蒙德";
    messBody5.postertIntro = @"这个人很懒，什么都没有留下";
    messBody5.posterFavor = [NSMutableArray arrayWithObjects:@"希尔瓦娜斯",@"格鲁尔",@"魔兽世界5区石锤人类联盟女圣骑丨阿诺丨",@"钢铁女武神",@"魔兽世界5区石锤人类联盟女盗贼chaotics",@"克苏恩",@"克尔苏加德",@"钢铁议会", nil];
    messBody5.isFavour = NO;
    
    CHMessageBody *messBody6 = [[CHMessageBody alloc] init];
    messBody6.posterContent = kShuoshuoText5;
    messBody6.posterPostImage = @[@"1.png",@"2.png",@"3.png",@"3.png",@"2.png"];
    messBody6.posterReplies = [NSMutableArray arrayWithObjects:body2,body4,body5,body4,body6, nil];
    messBody6.posterImageStr = @"mao.jpg";
    messBody6.posterName = @"红领巾";
    messBody6.postertIntro = @"这个人很懒，什么都没有留下";
    messBody6.posterFavor = [NSMutableArray arrayWithObjects:@"爆裂熔炉",@"希尔瓦娜斯",@"阿尔萨斯",@"死亡之翼",@"玛里苟斯", nil];
    messBody6.isFavour = NO;
    
    
    [_contentDataSource addObject:messBody1];
    [_contentDataSource addObject:messBody2];
    [_contentDataSource addObject:messBody3];
    [_contentDataSource addObject:messBody4];
    [_contentDataSource addObject:messBody5];
    [_contentDataSource addObject:messBody6];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.view.backgroundColor = [UIColor grayColor];
    [self configData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
