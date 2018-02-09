//
//  XXSound.m
//  TestCase
//
//  Created by wq on 2018/1/19.
//  Copyright © 2018年 wq. All rights reserved.
//

#import "XXSound.h"
#import <objc/runtime.h>

@implementation XXSound

// Initializers

- (instancetype)initWithFrequency:(float)freq amplitude:(float)amp duration:(float)dur {
    if (self = [super init]) {
        _frequency = freq;
        _amplitude = amp;
        _duration = dur;
    }
    return self;
}

// Class factory methods

+ (instancetype) soundWithFrequency:(float)freq amplitude:(float)amp duration:(float)dur {
    return [[self alloc] initWithFrequency:freq amplitude:amp duration:dur];
}

// NSCopying protocol

- (id)copyWithZone:(NSZone *)zone {
    return [[self class] soundWithFrequency:self.frequency
                                  amplitude:self.amplitude
                                   duration:self.duration];
}

-(void)printName {
    NSLog(@"%@",@"XXSound");
}

@end

@implementation XXSound (Addition)

-(void)setName:(NSString *)name {
    objc_setAssociatedObject(self, @"name", name, OBJC_ASSOCIATION_COPY);
}
-(NSString *)name {
    return objc_getAssociatedObject(self, @"name");
}

- (void)printName {
    NSLog(@"%@",@"Addition");
}

@end

