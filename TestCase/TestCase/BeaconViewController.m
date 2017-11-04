//
//  BeaconViewController.m
//  TestCase
//
//  Created by wq on 2017/11/3.
//  Copyright © 2017年 wq. All rights reserved.
//

#import "BeaconViewController.h"
#import <UserNotifications/UserNotifications.h>
//@"59461174-799D-46AD-9F24-5364706AEDFE"
#define BeaconUUID @"23A01AF0-232A-4518-9C0E-323FB773F5EF"
//@"95F428B1-4A3A-4E39-B086-21BFF38DEB6D"

@interface BeaconViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, 400)];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.beacons = [[NSArray alloc] init];
    
    self.localManager = [[CLLocationManager alloc]init];
    self.localManager.delegate = self;
    
    self.beacon1 = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:BeaconUUID] identifier:@"media"];//初始化监测的iBeacon信息
    
    [self.localManager requestAlwaysAuthorization];//设置location是一直允许的
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.localManager startMonitoringForRegion:self.beacon1];
    }
}

//发现有iBeacon进入监测范围

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    
    [self.localManager startRangingBeaconsInRegion:self.beacon1];//开始RegionBeacons
    
}
//找的iBeacon后扫描它的信息

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    
    //如果存在不是我们要监测的iBeacon那就停止扫描他
    
    if (![[region.proximityUUID UUIDString] isEqualToString:BeaconUUID]){
        
        [self.localManager stopMonitoringForRegion:region];
        
        [self.localManager stopRangingBeaconsInRegion:region];
        
    }
    
    //打印所有iBeacon的信息
    
    for (CLBeacon* beacon in beacons) {
        
        NSLog(@"rssi is :%ld",beacon.rssi);
        
        NSLog(@"beacon.proximity %ld",beacon.proximity);
        
    }
    
    self.beacons = beacons;
    
    [self.tableView reloadData];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return self.beacons.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    static NSString *ident = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
        
    }
    
    CLBeacon *beacon = [self.beacons objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [beacon.proximityUUID UUIDString];
    
    NSString *str;
    
    switch (beacon.proximity) {
            
        case CLProximityNear:
            
            str = @"近";
            
            break;
            
        case CLProximityImmediate:
            
            str = @"超近";
            
            break;
            
        case CLProximityFar:
            
            str = @"远";
            [self setLocal10WithAlert:nil];
            break;
            
        case CLProximityUnknown:
            
            str = @"不见了";
            
            break;
            
        default:
            
            break;
            
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ rssi:%ld major:%@ minor:%@",str,beacon.rssi,beacon.major,beacon.minor];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)setLocal10WithAlert:(NSString *)alert {
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    content.title = @"西西生活通知您";
    content.body = @"离发射源较远";
    UNNotificationSound *sound = [UNNotificationSound soundNamed:@"sub2.caf"];
    content.sound = sound;
    content.userInfo = @{@"noti":@"alarm"};
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"RequestSafe" content:content trigger:trigger];
    
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            //DLog(@"error:%@",error);
        }
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
