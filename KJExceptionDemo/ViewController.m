//
//  ViewController.m
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/2.
//  https://github.com/yangKJ/KJExceptionDemo

#import "ViewController.h"
#import "KJExceptionTool.h"

@interface ViewController ()
@property(nonatomic,strong)UITextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-40, self.view.frame.size.height-120)];
    self.textView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    self.textView.layer.borderColor = UIColor.greenColor.CGColor;
    self.textView.layer.borderWidth = 2.;
    self.textView.editable = NO;
    self.textView.selectable = NO;
    self.textView.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.textView];
    self.textView.text = @"回调处理:\n\n";
    
    [self test];
}

- (void)test{
    __weak __typeof(&*self) weakself = self;
    [KJExceptionTool kj_crashBlock:^BOOL(NSDictionary * _Nonnull dict) {
        weakself.textView.text = [weakself.textView.text stringByAppendingFormat:@"%@\n%@\n\n",dict[@"crashTitle"],dict[@"crashReason"]];
        return YES;
    }];
    NSMutableArray *temp = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",nil];
    NSString *str = nil;
    [temp addObject:str];
    [temp setObject:@"1" atIndexedSubscript:4];
    [temp insertObject:str atIndex:4];
    NSDictionary *dicX = @{str:@"123",@"key":str,@"key":@"1"};
    NSLog(@"%@",dicX);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjects:@[@"1",@"1"] forKeys:@[@"2",@"2"]];
    [dict setObject:str forKey:@"3"];
    [dict removeObjectForKey:str];
}

@end
