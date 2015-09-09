//
//  S2Node.m
//  SnowCat2D
//
//  Created by Moky on 15-7-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2Node+Hierarchy.h"
#import "S2Node.h"

@implementation S2Node

@synthesize running = _running;
@synthesize children = _children;

@synthesize tag = _tag;
@synthesize visible = _visible;

@synthesize touchEnabled = _touchEnabled;

// Geometry
@synthesize bounds = _bounds;
@synthesize anchorPoint = _anchorPoint;
@synthesize position = _position;

@synthesize rotation = _rotation;
@synthesize scaleX = _scaleX;
@synthesize scaleY = _scaleY;
@synthesize skewX = _skewX;
@synthesize skewY = _skewY;

// Hierarchy
@synthesize zOrder = _zOrder;
@synthesize parent = _parent;

- (void) dealloc
{
	[self removeAllChildrenWithCleanup:YES];
	[_children release];
	
	self.parent = nil;
	
	[super dealloc];
}

/* designated initializer */
- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super init];
	if (self) {
		_tag = 0;
		_running = NO;
		_visible = YES;
		
		_touchEnabled = NO;
		
		_isTransformDirty = _isInverseDirty = YES;
		
		_bounds = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
		_anchorPoint = CGPointMake(0.5f, 0.5f);
		_position = CGPointMake(frame.origin.x + frame.size.width * 0.5f,
								frame.origin.y + frame.size.height * 0.5f);
		
		_rotation = 0.0f;
		_scaleX = _scaleY = 1.0f;
		_skewX = _skewY = 0.0f;
		
		_zOrder = 0;
	}
	return self;
}

- (instancetype) init
{
	return [self initWithFrame:CGRectZero];
}

+ (instancetype) node
{
	return [[[self alloc] init] autorelease];
}

+ (instancetype) nodeWithFrame:(CGRect)frame
{
	return [[[self alloc] initWithFrame:frame] autorelease];
}

#pragma mark - setters/getters

- (CGAffineTransform) transform
{
	if (_isTransformDirty) {
		CGAffineTransform transform = CGAffineTransformIdentity;
		
		// 1. position
		CGPoint position = self.position;
		if (!CGPointEqualToPoint(position, CGPointZero)) {
			transform = CGAffineTransformTranslate(transform,
												   position.x,
												   position.y);
		}
		
		// 2. rotation
		CGFloat rotation = self.rotation;
		if (rotation != 0.0f) {
			transform = CGAffineTransformRotate(transform, rotation);
		}
		
		// 3. skew
		CGFloat skewX = self.skewX;
		CGFloat skewY = self.skewY;
		if (skewX != 0.0f || skewY != 0.0f) {
			// create a skewed coordinate system
			CGAffineTransform skew = CGAffineTransformMake(1.0f,
														   tanf(skewY),
														   tanf(skewX),
														   1.0f,
														   0.0f,
														   0.0f);
			// apply the skew to the transform
			transform = CGAffineTransformConcat(skew, transform);
		}
		
		// 4. scale
		CGFloat scaleX = self.scaleX;
		CGFloat scaleY = self.scaleY;
		if (scaleX != 1.0f || scaleY != 1.0f) {
			transform = CGAffineTransformScale(transform, scaleX, scaleY);
		}
		
		// 5. anchor point
		CGRect bounds = self.bounds;
		CGPoint ap = self.anchorPoint;
		if (!CGPointEqualToPoint(ap, CGPointZero)) {
			transform = CGAffineTransformTranslate(transform,
												   -bounds.size.width * ap.x,
												   -bounds.size.height * ap.y);
		}
		
		// 6. origin
		if (!CGPointEqualToPoint(bounds.origin, CGPointZero)) {
			transform = CGAffineTransformTranslate(transform,
												   -bounds.origin.x,
												   -bounds.origin.y);
		}
		
		_transform = transform;
		_isTransformDirty = NO;
	}
	return _transform;
}

- (CGAffineTransform) inverse
{
	if (_isInverseDirty) {
		_inverse = CGAffineTransformInvert([self transform]);
		_isInverseDirty = NO;
	}
	return _inverse;
}

- (void) setBounds:(CGRect)bounds
{
	if (!CGRectEqualToRect(_bounds, bounds)) {
		_bounds = bounds;
		_isTransformDirty = _isInverseDirty = YES;
	}
}

- (CGSize) size
{
	return _bounds.size;
}

- (void) setSize:(CGSize)size
{
	if (!CGSizeEqualToSize(_bounds.size, size)) {
		_bounds.size = size;
		_isTransformDirty = _isInverseDirty = YES;
	}
}

- (void) setPosition:(CGPoint)position
{
	if (!CGPointEqualToPoint(_position, position)) {
		_position = position;
		_isTransformDirty = _isInverseDirty = YES;
	}
}

- (void) setAnchorPoint:(CGPoint)anchorPoint
{
	if (!CGPointEqualToPoint(_anchorPoint, anchorPoint)) {
		_anchorPoint = anchorPoint;
		_isTransformDirty = _isInverseDirty = YES;
	}
}

- (void) setRotation:(CGFloat)rotation
{
	if (_rotation != rotation) {
		_rotation = rotation;
		_isTransformDirty = _isInverseDirty = YES;
	}
}

- (CGFloat) scale
{
	NSAssert(_scaleX == _scaleY,
			 @"scaleX != scaleY, don't know which to return");
	return _scaleX;
}

- (void) setScale:(CGFloat)scale
{
	[self setScaleX:scale];
	[self setScaleY:scale];
}

- (void) setScaleX:(CGFloat)scaleX
{
	if (_scaleX != scaleX) {
		_scaleX = scaleX;
		_isTransformDirty = _isInverseDirty = YES;
	}
}

- (void) setScaleY:(CGFloat)scaleY
{
	if (_scaleY != scaleY) {
		_scaleY = scaleY;
		_isTransformDirty = _isInverseDirty = YES;
	}
}

- (void) setSkewX:(CGFloat)skewX
{
	if (_skewX != skewX) {
		_skewX = skewX;
		_isTransformDirty = _isInverseDirty = YES;
	}
}

- (void) setSkewY:(CGFloat)skewY
{
	if (_skewY != skewY) {
		_skewY = skewY;
		_isTransformDirty = _isInverseDirty = YES;
	}
}

#pragma mark - protocol

- (NSMutableArray *) children
{
	if (!_children) {
		_children = [[NSMutableArray alloc] init];
	}
	return _children;
}

- (void) onEnter
{
	[_children makeObjectsPerformSelector:@selector(onEnter)];
	
	// resumeSchedulerAndActions
	[[S2Scheduler getInstance] resumeTarget:self];
	[[S2ActionManager getInstance] resumeTarget:self];
	
	_running = YES;
}

- (void) onExit
{
	_running = NO;
	
	// pauseSchedulerAndActions
	[[S2Scheduler getInstance] pauseTarget:self];
	[[S2ActionManager getInstance] pauseTarget:self];
	
	[_children makeObjectsPerformSelector:@selector(onExit)];
}

- (void) onClick
{
	NSAssert(_touchEnabled, @"touch enabled");
}

- (void) cleanup
{
	// actions
	[self stopAllActions];
	// timers
	[self unscheduleAllSelectors];
	
	[_children makeObjectsPerformSelector:@selector(cleanup)];
}

- (void) addChild:(id<S2Node>)child
{
	[self addChild:child z:child.zOrder tag:child.tag];
}

- (void) addChild:(id<S2Node>)child z:(NSInteger)z
{
	[self addChild:child z:z tag:child.tag];
}

- (void) addChild:(id<S2Node>)child z:(NSInteger)z tag:(NSInteger)tag
{
	child.parent = self;
	[S2Node node:self addChild:child z:z tag:tag];
}

- (void) removeAllChildrenWithCleanup:(BOOL)cleanup
{
	[S2Node node:self removeAllChildrenWithCleanup:cleanup];
}

- (void) removeChild:(id<S2Node>)child cleanup:(BOOL)cleanup
{
	[S2Node node:self removeChild:child cleanup:cleanup];
}

@end

#pragma mark -

@implementation S2Node (Action)

- (S2Action *) runAction:(S2Action *)action
{
	[[S2ActionManager getInstance] addAction:action
									  target:self
									  paused:!_running];
	return action;
}

- (void) stopAction:(S2Action *)action
{
	[[S2ActionManager getInstance] removeAction:action];
}

- (void) stopAllActions
{
	[[S2ActionManager getInstance] removeAllActionsFromTarget:self];
}

@end

@implementation S2Node (Schedule)

//- (BOOL) isScheduled:(SEL)selector
//{
//	// TODO: ...
//	return NO;
//}

- (void) scheduleTick
{
	[self scheduleTickWithPriority:0];
}

- (void) scheduleTickWithPriority:(NSInteger)priority
{
	[[S2Scheduler getInstance] scheduleTickForTarget:self
											priority:priority
											  paused:!_running];
}

- (void) unscheduleTick
{
	[[S2Scheduler getInstance] unscheduleTickForTarget:self];
}

- (void) schedule:(SEL)selector
{
	[self schedule:selector interval:0];
}

- (void) schedule:(SEL)selector interval:(float)seconds
{
	NSAssert(selector && [self respondsToSelector:selector],
			 @"selector error: %@", NSStringFromSelector(selector));
	NSAssert(seconds >= 0, @"interval must be positive");
	[[S2Scheduler getInstance] scheduleSelector:selector
									  forTarget:self
									   interval:seconds
										 paused:!_running];
}

- (void) unschedule:(SEL)selector
{
	NSAssert(selector && [self respondsToSelector:selector],
			 @"selector error: %@", NSStringFromSelector(selector));
	[[S2Scheduler getInstance] unscheduleSelector:selector forTarget:self];
}

- (void) unscheduleAllSelectors
{
	[[S2Scheduler getInstance] unscheduleAllSelectorsForTarget:self];
}

@end
