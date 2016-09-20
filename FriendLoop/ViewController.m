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
    [self initTableView];
    [self loadTextData];
}

-(void)loadTextData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *chDataArray = [[NSMutableArray alloc]init];
        
        for (int i = 0; i<_contentDataSource.count; i++) {
            CHMessageBody *messBody = [_contentDataSource objectAtIndex:i];
            
            CHTextData *ymData = [[CHTextData alloc] init ];
            ymData.messageBody = messBody;
            
            [chDataArray addObject:ymData];
        }
        [self caculateHeight:chDataArray];
    });
}
-(void)caculateHeight:(NSMutableArray *)dataArray
{
//    NSDate *tempDate = [NSDate date];
    for (CHTextData *ymData in dataArray) {
        
        ymData.shuoshuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:NO];//折叠
        
        ymData.unFoldShuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:YES];//展开
        
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
        
        ymData.favourHeight = [ymData calculateFavourHeightWidth:self.view.frame.size.width];
        
        [_tableViewDataSource addObject:ymData];
    }
    
    
//    double delaTime = [[NSDate date] timeIntervalSinceDate:tempDate];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [mainTable reloadData];
    });

}
-(void)initTableView
{

    mainTable = [[UITableView alloc]initWithFrame:self.view.bounds];
    mainTable.backgroundColor = [UIColor clearColor];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    
    [self.view addSubview:mainTable];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableViewDataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHTextData *ch = [_tableViewDataSource objectAtIndex:indexPath.row];
    
    BOOL unFold = ch.foldOrNot;
    return TableHeader +kLocationToBottom+ch.replyHeight+ch.showImageHeight +kDistance+(ch.islessLimit?0:30)+(unFold?ch.shuoshuoHeight:ch.unFoldShuoHeight)+kReplyBtnDistance+ch.favourHeight+(ch.favourHeight==0?0:kReply_FavourDistance);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseS = @"cell";
    CHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CHTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseS];
        
    }
    cell.stamp = indexPath.row;
    cell.replyButton.appendIndexPath = indexPath;
    [cell.replyButton addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    
    [cell setCHViewWith:[_tableViewDataSource objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)replyAction:(CHButton *)sender
{
    CGRect rectInTableView = [mainTable rectForRowAtIndexPath:sender.appendIndexPath];
    CGFloat orgin_Y = rectInTableView.origin.y+sender.frame.origin.y;
    CGRect targetRect = CGRectMake(CGRectGetMidX(sender.frame), orgin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
    
    
    if (self.operationView.shouldShowed) {
        [self.operationView dissMiss];
        return;
    }
    
    _selectedIndexPath = sender.appendIndexPath;
    CHTextData *ch = [_tableViewDataSource objectAtIndex:_selectedIndexPath.row];
    [self.operationView showAtView:mainTable rect:targetRect isFavor:ch.hasFavour];
    
}


-(CHPopView *)operationView
{
    if (!_operationView) {
        _operationView = [CHPopView initalizerCHOperationView];
        WS(ws);
        
        _operationView.didSelectedOpeartionCompletion = ^(CHOperationType operationType){
            switch (operationType) {
                case CHOperationTypeLike:
                    [ws addLike];
                    break;
                    case CHOperationTypeReply:
                    [ws replyMessage:nil];
                    break;
                    
                default:
                    break;
            }
        };
        
    }
    return _operationView;
}

-(void)addLike
{
    CHTextData *chData = [_tableViewDataSource objectAtIndex:_selectedIndexPath.row];
    CHMessageBody *messageBody = chData.messageBody;
    
    if (messageBody.isFavour == YES) {
        [messageBody.posterFavor removeObject:kAdmin];
        messageBody.isFavour = NO;
    }else{
    
        [messageBody.posterFavor addObject:kAdmin];
    }
    chData.messageBody = messageBody;
    
    [chData.attributedDataFavour removeAllObjects];
    
    chData.favourHeight = [chData calculateFavourHeightWidth:self.view.frame
                           .size.width];
    
    [_tableViewDataSource replaceObjectAtIndex:_selectedIndexPath.row withObject:chData];
    
    
    [mainTable reloadData];

}
-(void)replyMessage:(CHButton *)sender
{
    if (replyInputView) {
        return;
    }
    replyInputView = [[CHReplyInputView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44, screenWidth, 44) andAboveView:self.view];
    replyInputView.delegate = self;
    replyInputView.replyTag = _selectedIndexPath.row;
    
    [self.view addSubview:replyInputView];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.operationView dissMiss];
}

-(void)changeFoldState:(CHTextData *)chData onCellInRow:(NSInteger)cellStamp
{
    [_tableViewDataSource replaceObjectAtIndex:cellStamp withObject:chData];
    
    [mainTable reloadData];
}

#pragma mark - 图片点击事件回调
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
    
    UIView *maskview = [[UIView alloc] initWithFrame:self.view.bounds];
    maskview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:maskview];
    
    CHShowImageView *ymImageV = [[CHShowImageView alloc] initWithFrame:self.view.bounds byClick:clickTag appendArray:imageViews];
    [ymImageV show:maskview didFinish:^(){
        
        [UIView animateWithDuration:0.5f animations:^{
            
            ymImageV.alpha = 0.0f;
            maskview.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            
            [ymImageV removeFromSuperview];
            [maskview removeFromSuperview];
        }];
        
    }];
    
}

#pragma mark - 长按评论整块区域的回调
- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    
    [self.operationView dissMiss];
    CHTextData *ymData = (CHTextData *)[_tableViewDataSource objectAtIndex:index];
    CHReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = b.replyInfo;
    
}

#pragma mark - 点评论整块区域的回调
- (void)clickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    
    [self.operationView dissMiss];
    
    _replyIndex = replyIndex;
    
    CHTextData *ymData = (CHTextData *)[_tableViewDataSource objectAtIndex:index];
    CHReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    if ([b.replyUser isEqualToString:kAdmin]) {
        CHActionSheet *actionSheet = [[CHActionSheet alloc] initWithTitle:@"删除评论？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        actionSheet.actionIndex = index;
        [actionSheet showInView:self.view];
        
        
        
    }else{
        //回复
        if (replyInputView) {
            return;
        }
        replyInputView = [[CHReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
        replyInputView.delegate = self;
        replyInputView.labelPlaceHolder.text = [NSString stringWithFormat:@"回复%@:",b.replyUser];
        replyInputView.replyTag = index;
        [self.view addSubview:replyInputView];
    }
}

#pragma mark - 评论说说回调
- (void)YMReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag{
    
    CHTextData *ymData = nil;
    if (_replyIndex == -1) {
        
        CHReplyBody *body = [[CHReplyBody alloc] init];
        body.replyUser = kAdmin;
        body.repliedUser = @"";
        body.replyInfo = replyText;
        
        ymData = (CHTextData *)[_tableViewDataSource objectAtIndex:inputTag];
        CHMessageBody *m = ymData.messageBody;
        [m.posterReplies addObject:body];
        ymData.messageBody = m;
        
    }else{
        
        ymData = (CHTextData *)[_tableViewDataSource objectAtIndex:inputTag];
        CHMessageBody *m = ymData.messageBody;
        
        CHReplyBody *body = [[CHReplyBody alloc] init];
        body.replyUser = kAdmin;
        body.repliedUser = [(CHReplyBody *)[m.posterReplies objectAtIndex:_replyIndex] replyUser];
        body.replyInfo = replyText;
        
        [m.posterReplies addObject:body];
        ymData.messageBody = m;
        
    }
    
    
    
    //清空属性数组。否则会重复添加
    [ymData.completionReplySource removeAllObjects];
    [ymData.attributedDataReply removeAllObjects];
    
    
    ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
    [_tableViewDataSource replaceObjectAtIndex:inputTag withObject:ymData];
    
    [mainTable reloadData];
    
}

- (void)destorySelf{
    
    //  NSLog(@"dealloc reply");
    [replyInputView removeFromSuperview];
    replyInputView = nil;
    _replyIndex = -1;
    
}

-(void)actionSheet:(CHActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //delete
        CHTextData *ymData = (CHTextData *)[_tableViewDataSource objectAtIndex:actionSheet.cancelButtonIndex];
        CHMessageBody *m = ymData.messageBody;
        [m.posterReplies removeObjectAtIndex:_replyIndex];
        ymData.messageBody = m;
        [ymData.completionReplySource removeAllObjects];
        [ymData.attributedDataReply removeAllObjects];
        
        
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
        [_tableViewDataSource replaceObjectAtIndex:actionSheet.actionIndex withObject:ymData];
        
        [mainTable reloadData];
        
    }else{
        
    }
    _replyIndex = -1;
}



- (void)dealloc{
    
    NSLog(@"销毁");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
