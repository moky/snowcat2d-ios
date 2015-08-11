//
//  S2Director.h
//  SnowCat2D
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "S2Stage.h"

@interface S2Director : NSObject

@property(nonatomic, readonly, getter=isRunning) BOOL running;

+ (instancetype) getInstance;

- (void) addStage:(S2Stage *)stage;
- (void) removeStage:(S2Stage *)stage;

- (void) start;
- (void) stop;

@end
