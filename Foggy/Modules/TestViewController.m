//
//  TestViewController.m
//  Foggy
//
//  Created by yangkejun on 2021/4/27.
//

#import "TestViewController.h"
#import "OtherViewController.h"
#import "UINavigationController+KJException.h"
@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256)/255.0) green:((float)arc4random_uniform(256)/255.0) blue:((float)arc4random_uniform(256)/255.0) alpha:1.0];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (NSInteger i = 0; i < 3; i++) {
        OtherViewController *vc = [OtherViewController new];
        vc.title = [@"可以正常跳转" stringByAppendingFormat:@" -- %ld",i];
        vc.view.backgroundColor = UIColor.whiteColor;
        [self.navigationController kj_canRepetitionPushViewController:vc animated:YES];
    }
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
