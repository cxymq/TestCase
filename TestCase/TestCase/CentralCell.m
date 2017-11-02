//
//  CentralCell.m
//  TestCase
//
//  Created by wq on 2017/11/2.
//  Copyright © 2017年 wq. All rights reserved.
//

#import "CentralCell.h"

@implementation CentralCell
+ (instancetype)cellWithTableView:(UITableView *)tableVeiw {
    static NSString *identifer = @"";
    CentralCell *cell = [tableVeiw dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CentralCell" owner:nil options:nil].firstObject;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
