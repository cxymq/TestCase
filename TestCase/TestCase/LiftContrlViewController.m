//
//  LiftContrlViewController.m
//  TestCase
//
//  Created by wq on 2017/10/17.
//  Copyright © 2017年 wq. All rights reserved.
//

#import "LiftContrlViewController.h"

@interface LiftContrlViewController ()

@end

@implementation LiftContrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (IBAction)Hex2Int:(id)sender {
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"A"];
    [hexDic setObject:@"1011" forKey:@"B"];
    [hexDic setObject:@"1100" forKey:@"C"];
    [hexDic setObject:@"1101" forKey:@"D"];
    [hexDic setObject:@"1110" forKey:@"E"];
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSString *hex = @"923b";
    NSString *binary = @"";
    NSMutableArray *floors = [[NSMutableArray alloc]init];
    for (NSInteger i= 0; i<[hex length]; i++) {
        NSString *key = [hex substringWithRange:NSMakeRange(i, 1)];
        NSString *value = [hexDic objectForKey:key.uppercaseString];
        if (value) {
            binary = [binary stringByAppendingString:value];
            for (NSInteger j = 0; j < 4; j++) {
                NSString *charter = [value substringWithRange:NSMakeRange(j, 1)];
                if ([charter isEqualToString:@"1"]) {
                    [floors addObject:@(4*(hex.length-i)-j)];
                }
            }
        }
    }
    NSLog(@"%@,%@",binary,floors);
}
- (IBAction)getHexByDecimalism:(id)sender {
    NSInteger decimal = 68;
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) { //不严谨，用 do while 循环
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            break;
        }
    }
    NSLog(@"16进制:%@",hex);
}
- (IBAction)getHexByFloor:(id)sender {
    NSString *hex = @"";
    NSString *floor = @"17";
    NSInteger floorInt = floor.integerValue;
    NSInteger quotient = floorInt / 4;
    NSInteger remainder = floorInt % 4;
    NSString *letter = @"";
    switch (remainder) {
        case 0:
            letter = @"8";
            break;
        case 1:
            letter = @"1";
            break;
        case 2:
            letter = @"2";
            break;
        case 3:
            letter = @"4";
            break;
        default:
            break;
    }
    hex = [hex stringByAppendingString:letter];
    for (int i = 0; i < quotient; i ++) {
        hex = [hex stringByAppendingString:@"0"];
    }
    NSLog(@"%@",hex);
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
