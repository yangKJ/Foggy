//
//  OtherViewController.m
//  KJExceptionDemo
//
//  Created by yangkejun on 2021/4/27.
//

#import "OtherViewController.h"

@interface OtherViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
}
- (UITableView *)tableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    _tableView.backgroundColor = [UIColor whiteColor];
    return _tableView;
}
#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 500;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    NSString *text = [NSString stringWithFormat:@"cell - %ld",indexPath.row];;
    if (indexPath.row > 0 && indexPath.row % 15 == 0) {
        //休眠0.5s，模拟卡顿来测试卡顿监控
        usleep(500 * 1000);
        text = @"模拟卡顿来测试卡顿监控";
    }
    cell.textLabel.text = text;
    return cell;
}


@end
