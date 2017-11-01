//
//  AnimationViewController.m
//  TestCase
//
//  Created by wq on 2017/10/21.
//  Copyright © 2017年 wq. All rights reserved.
//

#import "AnimationViewController.h"

@interface AnimationViewController ()

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)ImplicitAnimation:(id)sender {
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor greenColor].CGColor;
    layer.frame = CGRectMake(0, 0, 100, 100);
    [self.view.layer addSublayer:layer];
    
    layer.frame = CGRectOffset(layer.frame, 100, 500);
}
- (IBAction)transformAnimation:(id)sender {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 50, 80)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    [UIView animateWithDuration:5.f delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:2.f options:UIViewAnimationOptionRepeat animations:^{
        //view.transform = CGAffineTransformMakeTranslation(100, 600);
        //view.transform = CGAffineTransformMakeScale(2, 3);
        //view.transform = CGAffineTransformMakeRotation(180);
        //view.layer.transform = CATransform3DMakeTranslation(100, 500, 50);
        CATransform3D t = CATransform3DMakeTranslation(100, 500, 50);
        view.layer.transform = CATransform3DRotate(t, 180, 50, 300, 10);
    } completion:^(BOOL finished) {
        //view.transform = CGAffineTransformIdentity;
        [view removeFromSuperview];
    }];
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
