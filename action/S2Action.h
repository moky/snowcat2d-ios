//
//  S2Action.h
//  SnowCat2D
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "s2Types.h"

/** Base class for Action objects.
 */
@interface S2Action : NSObject {
	
	id _target;
}

/** The "target". The action will modify the target properties.
 The target will be set with the 'startWithTarget' method.
 When the 'stop' method is called, target will be set to nil.
 The target is 'assigned', it is not 'retained'.
 */
@property(nonatomic, readonly, assign) id target;

/** Allocates and initializes the action */
+ (instancetype) action;

//! return YES if the action has finished
- (BOOL) isDone;

//! called before the action start. It will also set the target.
- (void) startWithTarget:(id)target;

//! called after the action has finished. It will set the 'target' to nil.
//! IMPORTANT: You should never call "[action stop]" manually. Instead, use: "[target stopAction:action];"
- (void) stop;

//! called every frame with it's delta time. DON'T override unless you know what you are doing.
- (void) tick:(s2Time)dt;

//! called once per frame. time a value between 0 and 1
//! For example:
//! * 0 means that the action just started
//! * 0.5 means that the action is in the middle
//! * 1 means that the action is over
- (void) update:(s2Time)time;

@end

@class S2ActionInterval;
/** Repeats an action for ever.
 To repeat the an action for a limited number of times use the Repeat action.
 @warning This action can't be Sequenceable because it is not an IntervalAction
 */
@interface S2RepeatForever : S2Action {
	
	S2ActionInterval * _innerAction; // retain
}

@property(nonatomic, readonly) S2ActionInterval * innerAction;

- (instancetype) initWithAction:(S2ActionInterval *)action;

+ (instancetype) actionWithAction:(S2ActionInterval *)action;

@end
