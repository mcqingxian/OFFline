//
//  AnswerController.m
//  MyUnityOniOS
//
//  C reated by Apple on 16/8/8.
//  Copyright © 2016年 Oneprime. All rights reserved.
//

#import "AnswerController.h"
#import "AnswerCell.h"
#import "Question.h"
#import "StartChipController.h"

#define A_width [UIApplication sharedApplication].keyWindow.bounds.size.width
#define A_height [UIApplication sharedApplication].keyWindow.bounds.size.height
@interface AnswerController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>

@property (nonatomic, strong)UIImageView * iconImageView;
//@property (nonatomic, strong)UILabel * timeLab;
@property (nonatomic, strong)UICollectionView * myCollectionView;
@property (nonatomic, strong)UICollectionViewLayout * customLayout;
@property (nonatomic, strong)NSIndexPath * myIndexPath;

@property (nonatomic, strong)UIImageView * bgImageView;//背景视图

@end

int secondsCountDown; //倒计时总时长
NSTimer *countDownTimer;
@implementation AnswerController

- (void)viewWillDisappear:(BOOL)animated
{
    AnswerCell * cell = (AnswerCell *)[_myCollectionView cellForItemAtIndexPath:_myIndexPath];
    [cell.myTimer1 invalidate];
    cell.myTimer1 = nil;
    [cell.myTimer2 invalidate];
    cell.myTimer2 = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor clearColor];

    [self loadData];
    [self createSubViews];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(answerQuestionError) name:@"answerError" object:nil];
    [center addObserver:self selector:@selector(answerQuestionRight) name:@"answerRight" object:nil];
    [center addObserver:self selector:@selector(answerQuestionOverTime) name:@"answerOverTime" object:nil];
    
}

//返回碎片初始页面
- (void)backToStartView
{
    StartChipController *vc = self.navigationController.viewControllers[2];
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)createSubViews
{
    self.bgImageView = [UIImageView imageViewWithFrame:self.view.frame backgroundColor:nil image:[UIImage imageNamed:@"答题界面背景.png"]];
    _bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:_bgImageView];
    
    //返回按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(20, 20, 13, 20) backgroundImage:[UIImage imageNamed:@"back2@2x.png"] target:self action:@selector(backToStartView)];
    [_bgImageView addSubview:backBtn];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height - 25) collectionViewLayout:layout];
    _myCollectionView.backgroundColor = [UIColor clearColor];
    [_myCollectionView registerClass:[AnswerCell class] forCellWithReuseIdentifier:@"myCollectionViewCell1"];
    _myCollectionView.dataSource = self;
    _myCollectionView.delegate = self;
    _myCollectionView.pagingEnabled = YES;
    _myCollectionView.bounces = YES;
    _myCollectionView.contentOffset = CGPointMake(0, 0);
//    if (_dataArray.count) {
//        _myCollectionView.contentSize = CGSizeMake(A_width * _dataArray.count, A_height);
//    }else{
        _myCollectionView.contentSize = CGSizeMake(A_width * 5, A_height);
//    }
    
    [_bgImageView addSubview:_myCollectionView];
    _myCollectionView.scrollEnabled = NO;
    
    
}


#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"myCollectionViewCell1";
    
    AnswerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (self.dataArray.count) {
        Question * question = [self.dataArray objectAtIndex:indexPath.item];
        cell.question = question;
    }
    
    self.myIndexPath = indexPath;
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(A_width, A_height);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    AnswerCell * cell = (AnswerCell *)[collectionView cellForItemAtIndexPath:indexPath];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//加载数据
- (void)loadData
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    NSString * userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSDictionary * parameters = @{@"Key":@"A2BB2C892444B155A2540CBF04AB1752", @"Method":@"GetSubject", @"UserID":userID};
    [manager POST:MyURL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@", responseObject);
        for (NSDictionary * dic in responseObject) {
            Question * question = [[Question alloc] initWithDictionary:dic];
            [self.dataArray addObject:question];
        }
        [_myCollectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请稍后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"error: %@", error);
    }];
}

//加载数据
- (void)uploadQuestionData:(NSString *)QID
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    NSString * userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSDictionary * parameters = @{@"Key":@"A2BB2C892444B155A2540CBF04AB1752", @"Method":@"UpdateSubjectByUserID", @"UserID":userID, @"QID":QID};
    [manager POST:MyURL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        [self.QIDArray removeAllObjects];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请稍后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"error: %@", error);
    }];
}

//回答正确
- (void)answerQuestionRight
{
    if (self.myIndexPath.item < _dataArray.count - 1) {
        //进入下一题
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:self.myIndexPath.item + 1 inSection:self.myIndexPath.section];
        [_myCollectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"答题成功,恭喜您获得一个碎片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 2003;
        [alert show];
    }
    AnswerCell * cell = (AnswerCell *)[_myCollectionView cellForItemAtIndexPath:_myIndexPath];
    [self.QIDArray addObject:cell.question.QID];
}

//回答问题错误
- (void)answerQuestionError
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"答案错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = 2002;
    [alert show];

}

//答题超时
- (void)answerQuestionOverTime
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你没有在规定时间内完成答题,请下次继续努力" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = 2004;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2002 | alertView.tag == 2003 | alertView.tag == 2004) {
        if (self.QIDArray.count) {
            NSString * QID = [self.QIDArray componentsJoinedByString:@","];
            [self uploadQuestionData:QID];
            NSLog(@"++++%@", QID);
        }
        //回到上一页
        StartChipController *vc = self.navigationController.viewControllers[2];
        [self.navigationController popToViewController:vc animated:YES];
    }
}


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

- (NSMutableArray *)QIDArray
{
    if (!_QIDArray) {
        self.QIDArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _QIDArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
