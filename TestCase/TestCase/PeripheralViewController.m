//
//  PeripheralViewController.m
//  TestCase
//
//  Created by wq on 2017/11/1.
//  Copyright © 2017年 wq. All rights reserved.
//

#import "PeripheralViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface PeripheralViewController ()<CBPeripheralManagerDelegate>
{
    CBPeripheralManager *_peripheralManager;
    NSString *_notiCharacterUUID;
    NSString *_readWriteCharaterUUID;
    NSString *_readCharaterUUID;
    NSString *_writeCharaterUUID;
    NSString *_serviceUUID;
    NSString *_localNameKey;
    NSTimer *_timer;
    CBMutableCharacteristic *_notiCharacter;
}

@end

@implementation PeripheralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
    _notiCharacterUUID = @"68753A44-4D6F-1226-9C60-0050E4C00011";
    _readWriteCharaterUUID = @"68753A44-4D6F-1226-9C60-0050E4C00012";
    _readCharaterUUID = @"68753A44-4D6F-1226-9C60-0050E4C00013";
    _writeCharaterUUID = @"68753A44-4D6F-1226-9C60-0050E4C00014";
    _serviceUUID = @"68753A44-4D6F-1226-9C60-0050E4C00021";
    _localNameKey = @"iphone6s_Peripheral";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//判断外设是否正常，正常情况下才能配置
//iOS 10.0 以后 NS_ENUM_AVAILABLE(10_13, 10_0);
- (void)peripheralManagerDidUpdateState:(nonnull CBPeripheralManager *)peripheral { 
    switch (_peripheralManager.state) {
        case CBManagerStateUnknown:
            NSLog(@"外设状态：CBManagerStateUnknown");
            break;
        case CBManagerStateResetting:
            NSLog(@"外设状态：CBManagerStateResetting");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"外设状态：CBManagerStateUnsupported");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"外设状态：CBManagerStateUnauthorized");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"外设状态：CBManagerStatePoweredOff");
            break;
        case CBManagerStatePoweredOn:
            NSLog(@"外设状态：CBManagerStatePoweredOn");
            [self configBt];
            break;
        default:
            break;
    }
}
//配置蓝牙
- (void)configBt {
    //设置特征
    _notiCharacter = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:_notiCharacterUUID] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    CBMutableCharacteristic *readWriteCharater = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:_readWriteCharaterUUID] properties:CBCharacteristicPropertyWrite | CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsWriteable | CBAttributePermissionsReadable];
    CBMutableCharacteristic *readCharater = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:_readCharaterUUID] properties:CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable];
    CBMutableCharacteristic *writeCharater = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:_writeCharaterUUID] properties:CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsWriteable];
    //创建描述信息，添加到某个服务或特征上.特征字段描述
    CBUUID *cbUUIDDes = [CBUUID UUIDWithString:CBUUIDCharacteristicUserDescriptionString];
    CBMutableDescriptor *readWriteDes = [[CBMutableDescriptor alloc]initWithType:cbUUIDDes value:@"心率"];
    CBMutableDescriptor *readWriteDes2 = [[CBMutableDescriptor alloc]initWithType:cbUUIDDes value:@"身高"];
    //将描述加入特征中
    [readWriteCharater setDescriptors:@[readWriteDes]];
    [writeCharater setDescriptors:@[readWriteDes2]];
    //设置服务，将特征加入服务中
    CBMutableService *service1 = [[CBMutableService alloc]initWithType:[CBUUID UUIDWithString:_serviceUUID] primary:YES];
    [service1 setCharacteristics:@[_notiCharacter,readWriteCharater,readCharater,writeCharater]];
    //将服务加入到外设中,可以添加多个服务
    [_peripheralManager addService:service1];
}

//添加服务成功的回调
-(void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@"add service fail,reason=%@",error);
        return;
    }
    //成功添加服务之后，向外部发出广播信息
    [_peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[[CBUUID UUIDWithString:_serviceUUID]],CBAdvertisementDataLocalNameKey:_localNameKey}];
}
//广播成功的回调
-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    if (error) {
        NSLog(@"advertising fail,reason=%@",error);
        return;
    }
    NSLog(@"advertising success");
}

#pragma mark 数据交互
//通知功能
-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"开启了UUID为：%@的通知功能",characteristic.UUID);
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendData:) userInfo:characteristic repeats:YES];
}
- (BOOL)sendData:(NSTimer *)t {
    CBMutableCharacteristic *charater = t.userInfo;
    NSDateFormatter *dft = [[NSDateFormatter alloc]init];
    [dft setDateFormat:@"ss"];
    BOOL isSend = [_peripheralManager updateValue:[[dft stringFromDate:[NSDate date]] dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:charater onSubscribedCentrals:nil];
    return isSend;
}
//取消通知功能
-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"关闭了UUID为：%@的通知功能",characteristic.UUID);
    [_timer invalidate];
    _timer = nil;
}
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    NSLog(@"didReceiveReadRequest");
    //判断是否有读数据的权限
    if (request.characteristic.properties & CBCharacteristicPropertyRead) {
        NSData *data = request.characteristic.value;
        [request setValue:data];
        //对请求作出成功响应
        [_peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
    }else{
        [_peripheralManager respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
    }
}
//写characteristics请求
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests{
    NSLog(@"didReceiveWriteRequests");
    CBATTRequest *request = requests[0];
    //判断是否有写数据的权限
    if (request.characteristic.properties & CBCharacteristicPropertyWrite) {
        //需要转换成CBMutableCharacteristic对象才能进行写值
        CBMutableCharacteristic *c =(CBMutableCharacteristic *)request.characteristic;
        c.value = request.value;
        [self setLocal10WithAlert:[[NSString alloc]initWithData:request.value encoding:NSUTF8StringEncoding]];
        [_peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
    }else{
        [_peripheralManager respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
    }
}

- (void)setLocal10WithAlert:(NSString *)alert {
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    content.title = @"西西生活通知您";
    content.body = alert;
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
@end
