//
//  ViewController.m
//  TestCase
//
//  Created by wq on 2017/10/17.
//  Copyright © 2017年 wq. All rights reserved.
//

#import "ViewController.h"
#import "LiftContrlViewController.h"
#import "AnimationViewController.h"
#import "BlueToothViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *vcs;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[self getUmengUDID];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.titles = @[@"梯控测试",@"动画测试",@"蓝牙测试"];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LiftContrlViewController *liftVc = [storyBoard instantiateViewControllerWithIdentifier:@"LiftContrlViewController"];
    AnimationViewController *animationVc = [storyBoard instantiateViewControllerWithIdentifier:@"AnimationViewController"];
    BlueToothViewController *blueVc = [storyBoard instantiateViewControllerWithIdentifier:@"BlueToothViewController"];
    self.vcs = @[liftVc,animationVc,blueVc];
    //[self test1];
}
- (void)getUmengUDID {
    
}
- (void)openUDIDString {
    
}
/*
 *关于clang warning一些用法
 *
 */
- (void) test1 {
#warning "123"
//#error @"321"
    NSString *str = [[NSData alloc]init];
    [str stringByAppendingString:@"123"];
    //[str base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inTest:) name:@"justTest" object:nil];
#pragma clang diagnostic pop
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:self.vcs[indexPath.row] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

