//
//  BeaconViewController.h
//  TestCase
//
//  Created by wq on 2017/11/3.
//  Copyright © 2017年 wq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BeaconViewController : UIViewController

@property (nonatomic, strong) NSArray *beacons;
@property (nonatomic, strong) CLBeaconRegion *beacon1;
@property (nonatomic, strong) CLLocationManager *localManager;

@end
