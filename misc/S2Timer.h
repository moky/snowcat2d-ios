//
//  S2Timer.h
//  SnowCat2D
//
//  Created by Moky on 15-7-28.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "s2Types.h"

@protocol S2TickCallback <NSObject>

- (void) tick:(s2Time)dt;

@end

typedef void (*S2TickImp)(id, SEL, s2Time);

@interface S2TickCallback : NSObject<S2TickCallback> {
	
	id _target;
	SEL _selector;
	S2TickImp _impMethod;
	
	BOOL _paused;
}

@property(nonatomic, assign) id target;
@property(nonatomic, readwrite) SEL selector;

@property(nonatomic, readwrite, getter=isPaused) BOOL paused;

/* designated initializer */
- (instancetype) initWithTarget:(id)target selector:(SEL)selector;

@end

#pragma mark -

@interface S2Timer : S2TickCallback {
	
	s2Time _elapsed;  // second(s)
	s2Time _interval; // second(s)
}

@property(nonatomic, readwrite) s2Time interval;

@end
