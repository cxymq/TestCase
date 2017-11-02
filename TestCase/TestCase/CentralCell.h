//
//  CentralCell.h
//  TestCase
//
//  Created by wq on 2017/11/2.
//  Copyright © 2017年 wq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CentralCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titileLb;
@property (weak, nonatomic) IBOutlet UILabel *RSSILb;
@property (weak, nonatomic) IBOutlet UILabel *distanceLb;

+ (instancetype)cellWithTableView:(UITableView *)tableVeiw;

@end
