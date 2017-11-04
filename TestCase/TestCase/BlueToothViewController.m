//
//  BlueToothViewController.m
//  TestCase
//
//  Created by wq on 2017/11/1.
//  Copyright © 2017年 wq. All rights reserved.
//

#import "BlueToothViewController.h"
#import "CentralViewController.h"
#import "PeripheralViewController.h"
#import "BeaconViewController.h"

@interface BlueToothViewController ()

@end

@implementation BlueToothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}
- (IBAction)centralEvent:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CentralViewController *centralVc = [storyBoard instantiateViewControllerWithIdentifier:@"CentralViewController"];
    [self.navigationController pushViewController:centralVc animated:YES];
}
- (IBAction)PeripheralEvent:(id)sender {
    PeripheralViewController *PeripheralVc = [[PeripheralViewController alloc]init];
    [self.navigationController pushViewController:PeripheralVc animated:YES];
}
- (IBAction)beaconEvent:(id)sender {
    BeaconViewController *beaconVc = [[BeaconViewController alloc]init];
    [self.navigationController pushViewController:beaconVc animated:YES];
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
