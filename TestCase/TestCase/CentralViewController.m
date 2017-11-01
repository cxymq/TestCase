//
//  CentralViewController.m
//  TestCase
//
//  Created by wq on 2017/11/1.
//  Copyright © 2017年 wq. All rights reserved.
//

#import "CentralViewController.h"

#define SERVICE_TEST  @"73097A48-A2BD-40BA-8699-B18283E16993"
#define SERVICE_TEST2  @"AF920361-2859-42E5-A860-11AE0215719D"
#define SERVICE_UUID @"68753A44-4D6F-1226-9C60-0050E4C00021"
#define CHAR_NOTIFY_UUID1 @"68753A44-4D6F-1226-9C60-0050E4C00011"
#define CHAR_READWRITE_UUID2 @"68753A44-4D6F-1226-9C60-0050E4C00012"
#define CHAR_READ_UUID3 @"68753A44-4D6F-1226-9C60-0050E4C00013"
#define CHAR_WRITE_UUID4 @"68753A44-4D6F-1226-9C60-0050E4C00014"

@interface CentralViewController ()<CBCentralManagerDelegate,UITableViewDelegate,UITableViewDataSource,CBPeripheralDelegate>
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, strong) NSMutableArray *peripheralArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation CentralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    _peripheralArray = [[NSMutableArray alloc]init];
}

//判断设备是否正常工作
-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@"中心状态：CBManagerStateUnknown");
            break;
        case CBManagerStateResetting:
            NSLog(@"中心状态：CBManagerStateResetting");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"中心状态：CBManagerStateUnsupported");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"中心状态：CBManagerStateUnauthorized");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"中心状态：CBManagerStatePoweredOff");
            break;
        case CBManagerStatePoweredOn:
            NSLog(@"中心状态：CBManagerStatePoweredOn");
            //中心开始扫描外设
            [self.centralManager scanForPeripheralsWithServices:nil options:nil];//第一个参数为空的话，默认扫描所有，也可以给个参数设置过滤条件
            break;
        default:
            break;
    }
}
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if (![_peripheralArray containsObject:peripheral]) {
        [_peripheralArray addObject:peripheral];//RSSI 获取与设备的距离
        [self.tableView reloadData];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.peripheralArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CentralCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CentralCell"];
    }
    CBPeripheral *peri = self.peripheralArray[indexPath.row];
    if (peri.name) {
        cell.textLabel.text = peri.name;
    }else {
        cell.textLabel.text = @"Null";
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self connectPeripheral:self.peripheralArray[indexPath.row]];
}
//链接外设的方法
- (void)connectPeripheral:(CBPeripheral *)peripheral {
    [self.centralManager connectPeripheral:peripheral options:nil];
}
//断开外设的方法
- (void)disConnectionPeripheral:(CBPeripheral *)peripheral {
    [self.centralManager cancelPeripheralConnection:peripheral];
}
//链接成功的回调
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"connection success %@",peripheral.name);
    self.peripheral = peripheral;
    peripheral.delegate = self;
    //链接成功后停止扫描 ???
    //发现外设服务
    [self discoverSerivce];
}
//链接失败的回调
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"connection fail %@",error);
}

- (void)discoverSerivce {//@[[CBUUID UUIDWithString:SERVICE_UUID]]
    [self.peripheral discoverServices:@[[CBUUID UUIDWithString:SERVICE_TEST],[CBUUID UUIDWithString:SERVICE_TEST2],[CBUUID UUIDWithString:@"1111"]]];
}

//成功发现服务的回调
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        NSLog(@"disCoverServices error %@",error);
        return;
    }
    for (CBService *service in peripheral.services) {
        NSLog(@"service UUID %@",service.UUID);
        //发现服务的特征
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

//发现服务的特征回调
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@"disCoverCharacteristics error %@",error);
        return;
    }
    [self didFindAllCharacteristic:service.characteristics forService:service];
}
- (void)didFindAllCharacteristic:(NSArray *)charaterArr forService:(CBService *)service {
    for (CBCharacteristic *cha in charaterArr) {
        switch (cha.properties) {
            case CBCharacteristicPropertyRead:
                NSLog(@"%@--------read",cha);
                break;
            case CBCharacteristicPropertyWrite:
                NSLog(@"%@--------write",cha);
                break;
            case CBCharacteristicPropertyNotify:
                NSLog(@"%@--------notify",cha);
                break;
            default:
                break;
        }
        if ([cha.UUID isEqual:[CBUUID UUIDWithString:@"2222"]]) {
            //注册通知
            [self.peripheral setNotifyValue:YES forCharacteristic:cha];
        }
        if ([cha.UUID isEqual:CHAR_READWRITE_UUID2]) {
            //注册通知
            [self.peripheral setNotifyValue:YES forCharacteristic:cha];
        }
        if ([cha.UUID isEqual:CHAR_READ_UUID3]) {
            //注册通知
            [self.peripheral setNotifyValue:YES forCharacteristic:cha];
        }
        if ([cha.UUID isEqual:CHAR_WRITE_UUID4]) {
            //只有写入的属性，不能注册通知
        }
    }
}
//监听通知的状态
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"注册失败 %@",error);
        return;
    }
    NSLog(@"注册成功 %@",characteristic);
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
