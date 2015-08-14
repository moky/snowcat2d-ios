//
//  S2Stage.m
//  SnowCat2D
//
//  Created by Moky on 15-7-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#include <sys/time.h>

#import <UIKit/UIKit.h>

#import "s2Macros.h"
#import "s2Types.h"
#import "S2Director.h"
#import "S2Node+Hierarchy.h"
#import "S2Node+Rendering.h"
#import "S2Stage.h"

#ifdef S2_DEBUG
#define kDisplayFPSInterval 1.0f
#endif

@interface S2Stage () {
	
#ifdef S2_DEBUG
	struct timeval _lastTime;
	s2Time _deltaTime;
	s2Time _drawTime;
	NSUInteger _frames;
#endif
}

@property(nonatomic, retain) NSMutableArray * children;

@end

@implementation S2Stage

@synthesize tag = _tag;
@synthesize zOrder = _zOrder;
@synthesize running = _running;

@synthesize children = _children;
@synthesize parent = _parent;

- (void) dealloc
{
	self.children = nil;
	
	[super dealloc];
}

/* The designated initializer. */
- (instancetype) init
{
	self = [super init];
	if (self) {
		self.children = [NSMutableArray arrayWithCapacity:1];
		self.running = NO;
#ifdef S2_DEBUG
		gettimeofday(&_lastTime, NULL);
		_deltaTime = 0.0f;
		_drawTime = 0.0f;
		_frames = 0;
#endif
	}
	return self;
}

- (void) setChildren:(NSMutableArray *)children
{
	if (_children != children) {
		[children retain];
		[self removeAllChildrenWithCleanup:YES];
		[_children release];
		_children = children;
	}
}

- (void) setRunning:(BOOL)running
{
	if (_running != running) {
		if (running) {
			[[S2Director getInstance] addStage:self];
		} else {
			[[S2Director getInstance] removeStage:self];
		}
		_running = running;
	}
}

- (void) redraw
{
	[self setNeedsDisplay];
}

- (void) drawInContext:(CGContextRef)ctx
{
#ifdef S2_DEBUG
	struct timeval time1;
	gettimeofday(&time1, NULL);
#endif
	
	[super drawInContext:ctx];
	[_children makeObjectsPerformSelector:@selector(visitInContext:) withObject:(id)ctx];
	
#ifdef S2_DEBUG
	struct timeval time2;
	gettimeofday(&time2, NULL);
	
	_drawTime += s2difftime(time2, time1);
	NSAssert(_drawTime > 0.0f, @"time error");
	
	_deltaTime += s2difftime(time2, _lastTime);
	NSAssert(_deltaTime > 0.0f, @"time error");
	
	_lastTime = time2;
	++_frames;
	
	if (_deltaTime >= kDisplayFPSInterval) {
		float fps = _frames / _deltaTime;
		float dt = _drawTime / _frames;
		[self _displayFPS:fps drawTime:dt];
		// reset
		_deltaTime = 0.0f;
		_drawTime = 0.0f;
		_frames = 0;
	}
	
#endif
}

#ifdef S2_DEBUG
- (void) _displayFPS:(float)fps drawTime:(float)dt
{
	CATextLayer * label;
	S2_FOR_EACH(label, self.sublayers) {
		if ([label isKindOfClass:[CATextLayer class]]) {
			break;
		}
	}
	if (!label) {
		label = [CATextLayer layer];
		label.font = @"Helvetica-Bold";
		label.fontSize = 12.0f;
		label.alignmentMode = kCAAlignmentLeft;
		label.frame = CGRectMake(self.bounds.origin.x + 4, self.bounds.origin.y + self.bounds.size.height - 36,
								 100, 32);
		label.borderWidth = 2.0f;
		label.borderColor = [UIColor clearColor].CGColor;
		label.foregroundColor = [UIColor whiteColor].CGColor;
		label.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f].CGColor;
		[self addSublayer:label];
	}
	
	label.string = [NSString stringWithFormat:@" FPS: %.1f\n DT: %.6fs", fps, dt];
}
#endif

#pragma mark - protocol

- (void) onEnter
{
	[_children makeObjectsPerformSelector:@selector(onEnter)];
	self.running = YES;
}

- (void) onExit
{
	self.running = NO;
	[_children makeObjectsPerformSelector:@selector(onExit)];
}

- (void) cleanup
{
	[_children makeObjectsPerformSelector:@selector(cleanup)];
}

- (void) addChild:(S2Node *)child
{
	[self addChild:child z:child.zOrder tag:child.tag];
}

- (void) addChild:(S2Node *)child z:(NSInteger)z
{
	[self addChild:child z:z tag:child.tag];
}

- (void) addChild:(S2Node *)child z:(NSInteger)z tag:(NSInteger)tag
{
	child.parent = nil; // stage cannot be parent node
	[S2Node node:self addChild:child z:z tag:tag];
}

- (void) removeAllChildrenWithCleanup:(BOOL)cleanup
{
	[S2Node node:self removeAllChildrenWithCleanup:cleanup];
}

- (void) removeChild:(S2Node *)child cleanup:(BOOL)cleanup
{
	[S2Node node:self removeChild:child cleanup:cleanup];
}

@end
