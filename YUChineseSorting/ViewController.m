//
//  ViewController.m
//  https://github.com/c6357/YUChineseSorting
//
//  Created by BruceYu on 15/4/19.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//

#import "ViewController.h"
#import "ChineseString.h"

#define screenW [[UIScreen mainScreen]applicationFrame].size.width
#define screenH [[UIScreen mainScreen]applicationFrame].size.height

@interface ViewController ()
@property(nonatomic,strong)NSMutableArray *indexArray;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic, strong) UILabel *sectionTitleView;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ViewController

//注意ViewController继承自UITableViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    //自定义弹出框
    self.sectionTitleView= [[UILabel alloc] initWithFrame:CGRectMake((screenW-100)/2, (screenH-100)/2,100,100)];
    self.sectionTitleView.textAlignment = NSTextAlignmentCenter;
    self.sectionTitleView.font = [UIFont boldSystemFontOfSize:60];
    self.sectionTitleView.textColor = [UIColor blueColor];
    self.sectionTitleView.backgroundColor = [UIColor whiteColor];
    self.sectionTitleView.layer.cornerRadius = 6;
    self.sectionTitleView.layer.borderWidth = 3.f/[UIScreen mainScreen].scale;
    self.sectionTitleView.layer.borderColor = [UIColor blackColor].CGColor;
//    self.sectionTitleView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    //添加方式
    [self.navigationController.view addSubview:self.sectionTitleView];
    self.sectionTitleView.hidden = YES;
    
    //通讯录数据源 乱
    NSArray *stringsToSort = @[@"￥hhh, .$",@"￥Chin ese ",
                               @"开源中国",@"www.oschina.net",
                               @"开源技术", @"社区",
                               @"开发者", @"传播",
                               @"2014", @"a1",
                               @"100",@"中国",
                               @"暑假作业",@"键盘",
                               @"鼠标",@"hello",
                               @"world",@"b1"];
    //下标  "#",A,B,C,H,J,K,S,W,Z
    self.indexArray = [ChineseString IndexArray:stringsToSort];
    //分类整理好的二维数组，即table的数据源
    self.dataArray = [ChineseString LetterSortArray:stringsToSort];
}


//1.
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
//2.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}
//3.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}



/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return self.indexArray[section];
}

*/
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lab = [UILabel new];
    lab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lab.text = self.indexArray[section];
    lab.textColor = [UIColor blackColor];
    return lab;
}
 
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}
//返回 右边index 点击index的时候自动跳转到对应的分区
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexArray;
}
//点击右侧index的时候响应事件 ：弹一个自定义的框出来

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self showSectionTitle:title];
    return index;
}
 
-(void)showSectionTitle:(NSString*)title{
    self.sectionTitleView.text=title;
    self.sectionTitleView.hidden = NO;
    self.sectionTitleView.alpha = 1;
    
    //加这两句话的原因是防止上一次点击事件3秒内未执行完，再次点击出问题。所以点击的时候把上一次的清除掉
    [self.timer invalidate];
    self.timer = nil;
    
   
    //repeats YES 每隔开三秒执行一次
    //repeats NO 等价于三秒后执行
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandler:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
#pragma mark - private
- (void)timerHandler:(NSTimer *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.3 animations:^{
            self.sectionTitleView.alpha = 0;
        } completion:^(BOOL finished) {
            self.sectionTitleView.hidden = YES;
        }];
    });
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
