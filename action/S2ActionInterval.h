//
//  S2ActionInterval.h
//  SnowCat2D
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2FiniteTimeAction.h"

/** An interval action is an action that takes place within a certain period of time.
 It has an start time, and a finish time. The finish time is the parameter
 duration plus the start time.
 
 These ActionInterval actions have some interesting properties, like:
 - They can run normally (default)
 - They can run reversed with the reverse method
 - They can run with the time altered with the Accelerate, AccelDeccel and Speed actions.
 
 For example, you can simulate a Ping Pong effect running the action normally and
 then running it again in Reverse mode.
 
 Example:
 
	S2Action * pingPongAction = [S2Sequence actions: action, [action reverse], nil];
 */
@interface S2ActionInterval : S2FiniteTimeAction {
	
	//! elapsed time in seconds
	s2Time _elapsed;
}

/** how many seconds had elapsed since the actions started to run. */
@property(nonatomic, readonly) s2Time elapsed;

- (instancetype) initWithDuration:(s2Time)duration;

+ (instancetype) actionWithDuration:(s2Time)duration;

/** returns a reversed action */
- (S2ActionInterval *) reverse;

@end

#pragma mark -

/** Delays the action a certain amount of seconds
 */
@interface S2DelayTime : S2ActionInterval

@end

/** Executes an action in reverse order, from time=duration to time=0
 
 @warning Use this action carefully. This action is not
 sequenceable. Use it as the default "reversed" method
 of your own actions, but using it outside the "reversed"
 scope is not recommended.
 */
@interface S2ReverseTime : S2ActionInterval {
	
	S2FiniteTimeAction * _innerAction;
}

- (instancetype) initWithAction:(S2FiniteTimeAction *)action;
+ (instancetype) actionWithAction:(S2FiniteTimeAction *)action;

@end

/** Repeats an action a number of times.
 * To repeat an action forever use the S2RepeatForever action.
 */
@interface S2Repeat : S2ActionInterval {
	
	S2FiniteTimeAction * _innerAction;
	NSUInteger _times;
	NSUInteger _total;
}

- (instancetype) initWithAction:(S2FiniteTimeAction *)action times:(NSUInteger)times;

+ (instancetype) actionWithAction:(S2FiniteTimeAction *)action times:(NSUInteger)times;

@end

/** Runs actions sequentially, one after another
 */
@interface S2Sequence : S2ActionInterval

/** initializes the action */
- (instancetype) initWithActionOne:(S2FiniteTimeAction *)action1 two:(S2FiniteTimeAction *)action2;

/** helper contructor to create an array of sequenceable actions */
+ (instancetype) actions:(S2FiniteTimeAction *)action1, ... NS_REQUIRES_NIL_TERMINATION;

/** helper contructor to create an array of sequenceable actions given an array */
+ (instancetype) actionsWithArray:(NSArray *)actions;

/** creates the action */
+ (instancetype) actionOne:(S2FiniteTimeAction *)action1 two:(S2FiniteTimeAction *)action2;

@end

/** Spawn a new action immediately
 */
@interface S2Spawn : S2Sequence

@end
