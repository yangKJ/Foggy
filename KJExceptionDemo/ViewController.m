//
//  ViewController.m
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/2.
//  https://github.com/yangKJ/KJExceptionDemo

#import "ViewController.h"
#import "KJCrashException.h"
#import "TestViewController.h"
#import "OtherViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *temps;

//测试未实现类方法
+ (void)test_UnrecognizedSelector;

@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    
    //是否开启开发模式强制提醒
    KJCrashException.openThrow = NO;
    [KJCrashException kj_openCrashProtectorType:(KJCrashProtectorTypeAll)
                                      exception:^(KJExceptionInfo * _Nonnull userInfo) {
        NSLog(@"\n******************** crash 日志 ********************\
              \n%@\n异常方法：%@\n异常信息：%@\n堆栈信息：%@\n",
              userInfo.title, userInfo.selector, userInfo.exception, userInfo.stacks);
    }];
}
- (NSArray *)temps{
    if (!_temps) {
        _temps = @[@{@"sel":@"testUnrecognizedSelector",@"describeName":@"测试未找到方法"},
                   @{@"sel":@"testString",@"describeName":@"测试字符串崩溃"},
                   @{@"sel":@"testContainer",@"describeName":@"测试数组字典崩溃"},
                   @{@"sel":@"testUINonMain",@"describeName":@"测试不在主线程处理UI"},
                   @{@"sel":@"testkvc",@"describeName":@"测试kvc键值为空崩溃"},
                   @{@"sel":@"testDoublePush",@"describeName":@"防护重复跳转"},
                   @{@"sel":@"testNSUserDefaults",@"describeName":@"NSUserDefaults空键"},
                   @{@"sel":@"testNull",@"describeName":@"测试后台返回null"},
                   @{@"sel":@"testRunloopCatonMonitor",@"describeName":@"Runloop卡顿监测"},
        ];
    }
    return _temps;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
    }
    return _tableView;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.temps count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tableViewCell"];
    NSDictionary *dic = self.temps[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row + 1,dic[@"sel"]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.textLabel.textColor = UIColor.blueColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = dic[@"describeName"];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:13];
    cell.detailTextLabel.textColor = [UIColor.blueColor colorWithAlphaComponent:0.5];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.temps[indexPath.row];
    [self performSelector:NSSelectorFromString(dic[@"sel"])];
}

#pragma mark - 测试崩溃
- (void)testString{
    NSString *str = @"测试字符串崩溃";
    [str substringFromIndex:20];
}
- (void)testUnrecognizedSelector{
    [ViewController test_UnrecognizedSelector];
    [self performSelector:@selector(testCrash:xx:)];
}
- (void)testContainer{
    NSMutableArray *temp = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",nil];
    NSString *str = nil;
    [temp addObject:str];
    [temp setObject:@"1" atIndexedSubscript:4];
    [temp insertObject:str atIndex:4];
    NSDictionary *dicX = @{str:@"123",@"key":str,@"key":@"1"};
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjects:@[@"1",@"1"] forKeys:@[@"2",@"2"]];
    [dict setObject:str forKey:@"3"];
    [dict removeObjectForKey:str];
}
- (void)testUINonMain{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.center = self.view.center;
        view.backgroundColor = [UIColor redColor];
        [self.view addSubview:view];
    });
}
- (void)testkvc{
    NSString *nilKey = nil;
    NSString *nilValue = nil;
    [self setValue:@"xxx" forKey:nilKey];
    [self setValue:nilValue forKey:@"name"];
    [self setValue:@"xxx" forKey:@"xxxxx"];
}
- (void)testDoublePush{
    for (NSInteger i = 0; i < 2; i++) {
        TestViewController *vc = [TestViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)testNSUserDefaults{
    [[NSUserDefaults standardUserDefaults] setInteger:1234 forKey:nil];
    [[NSUserDefaults standardUserDefaults] setValue:@"1234566" forKey:nil];
    [[NSUserDefaults standardUserDefaults] valueForKey:nil];
    [[NSUserDefaults standardUserDefaults] stringForKey:nil];
}
- (void)testNull{
    NSString *json = @"{\"test\":\"<null>\"}";
    NSDictionary *dict = ({
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        dic;
    });
    NSString * value = [dict objectForKey:@"test"];
    NSDictionary * dictionary = (NSDictionary*)[NSNull null];
    NSString * objectForKey = [dictionary objectForKey:@"str"];
}
- (void)testRunloopCatonMonitor{
    OtherViewController *vc = [OtherViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

