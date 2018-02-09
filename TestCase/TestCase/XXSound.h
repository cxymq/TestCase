//
//  XXSound.h
//  TestCase
//
//  Created by wq on 2018/1/19.
//  Copyright © 2018年 wq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXSound : NSObject <NSCopying>

@property (nonatomic) float frequency;
@property (nonatomic) float amplitude;
@property (nonatomic) float duration;

- (void)printName;

// Designated Initializer
- (instancetype)initWithFrequency:(float)freq
                        amplitude:(float)amp
                         duration:(float)dur;

+ (instancetype)soundWithFrequency:(float)freq
                         amplitude:(float)amp
                          duration:(float)dur;

@end

@interface XXSound (Addition)

@property (nonatomic, strong) NSString *name;

- (void)printName;

@end
