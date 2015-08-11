//
//  S2Node.h
//  SnowCat2D
//
//  Created by Moky on 15-7-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "s2Types.h"

@protocol S2Node <NSObject>

@property(nonatomic) NSInteger tag;
@property(nonatomic) NSInteger zOrder;
@property(nonatomic, readwrite, getter=isRunning) BOOL running;

@property(nonatomic, readonly, retain) NSMutableArray * children;
@property(nonatomic, readwrite, assign) id<S2Node> parent;

- (void) onEnter;
- (void) onExit;

/** Stops all running actions and schedulers
 */
- (void) cleanup;

/** Adds a child to the container with z-order as 0.
 If the child is added to a 'running' node, then 'onEnter' and 'onEnterTransitionDidFinish' will be called immediately.
 */
- (void) addChild:(id<S2Node>)child;

/** Adds a child to the container with a z-order.
 If the child is added to a 'running' node, then 'onEnter' and 'onEnterTransitionDidFinish' will be called immediately.
 */
- (void) addChild:(id<S2Node>)child z:(NSInteger)z;

/** Adds a child to the container with z order and tag.
 If the child is added to a 'running' node, then 'onEnter' and 'onEnterTransitionDidFinish' will be called immediately.
 */
- (void) addChild:(id<S2Node>)child z:(NSInteger)z tag:(NSInteger)tag;

/** Removes a child from the container. It will also cleanup all running actions depending on the cleanup parameter.
 */
- (void) removeChild:(id<S2Node>)child cleanup:(BOOL)cleanup;

/** Removes all children from the container and do a cleanup all running actions depending on the cleanup parameter.
 */
- (void) removeAllChildrenWithCleanup:(BOOL)cleanup;

@end

@class S2Action;

@interface S2Node : NSObject<S2Node> {
	
	NSInteger _tag;
	BOOL _running:1;
	BOOL _visible:1;
	
	BOOL _touchEnabled:1;
	
	BOOL _isTransformDirty:1;
	BOOL _isInverseDirty:1;
	CGAffineTransform _transform;
	CGAffineTransform _inverse;
	
	// Geometry
	CGRect _bounds;
	CGPoint _anchorPoint;
	CGPoint _position;
	
	CGFloat _rotation;
	CGFloat _scaleX;
	CGFloat _scaleY;
	CGFloat _skewX;
	CGFloat _skewY;
	
	// Hierarchy
	NSInteger _zOrder;
	NSMutableArray * _children;
	__unsafe_unretained S2Node * _parent;
}

@property(nonatomic, getter=isVisible) BOOL visible;
@property(nonatomic, getter=isTouchEnabled) BOOL touchEnabled;

@property(nonatomic, readonly) CGAffineTransform transform; // nodeToParentTransform
@property(nonatomic, readonly) CGAffineTransform inverse; // parentToNodeTransform

// Geometry
@property(nonatomic) CGRect bounds;
@property(nonatomic) CGSize size; // REF _bounds.size
@property(nonatomic) CGPoint anchorPoint;
@property(nonatomic) CGPoint position;

@property(nonatomic) CGFloat rotation;
@property(nonatomic) CGFloat scale;
@property(nonatomic) CGFloat scaleX;
@property(nonatomic) CGFloat scaleY;
@property(nonatomic) CGFloat skewX;
@property(nonatomic) CGFloat skewY;

+ (instancetype) node;

- (void) onClick;

@end

@interface S2Node (Action)

/** Executes an action, and returns the action that is executed.
 The node becomes the action's target.
 @warning actions don't retain their target.
 @return An Action pointer
 */
- (S2Action *) runAction:(S2Action *)action;

/** Removes an action from the running action list */
- (void) stopAction:(S2Action *)action;

/** Removes all actions from the running action list */
- (void) stopAllActions;

@end

@interface S2Node (Schedule)

/** check whether a selector is scheduled. */
//- (BOOL) isScheduled:(SEL)selector;

/** schedules the "tick:" method. It will use the order number 0. This method will be called every frame.
 Scheduled methods with a lower order value will be called before the ones that have a higher order value.
 Only one "tick:" method could be scheduled per node.
 */
- (void) scheduleTick;

/** schedules the "tick:" selector with a custom priority. This selector will be called every frame.
 Scheduled selectors with a lower priority will be called before the ones that have a higher value.
 Only one "tick:" selector could be scheduled per node (You can't have 2 'tick:' selectors).
 */
- (void) scheduleTickWithPriority:(NSInteger)priority;

/* unschedules the "tick:" method.
 */
- (void) unscheduleTick;

/** schedules a selector.
 The scheduled selector will be ticked every frame
 */
- (void) schedule:(SEL)selector;

/** schedules a custom selector with an interval time in seconds.
 If time is 0 it will be ticked every frame.
 If time is 0, it is recommended to use 'scheduleTick' instead.
 
 If the selector is already scheduled, then the interval parameter will be updated without scheduling it again.
 */
- (void) schedule:(SEL)selector interval:(s2Time)seconds;

/** unschedules a custom selector.*/
- (void) unschedule:(SEL)selector;

/** unschedule all scheduled selectors: custom selectors, and the 'tick:' selector.
 Actions are not affected by this method.
 */
- (void) unscheduleAllSelectors;

@end
