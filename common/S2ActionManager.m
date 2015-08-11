//
//  S2ActionManager.m
//  SnowCat2D
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "s2Macros.h"
#import "S2Scheduler.h"
#import "S2Action.h"
#import "S2ActionManager.h"

@interface S2ActionTarget : NSObject

@property(nonatomic, retain) id target;
@property(nonatomic, retain) S2Action * action;
@property(nonatomic, readwrite) BOOL paused;

/* designated initializer */
- (instancetype) initWithTarget:(id)target action:(S2Action *)action paused:(BOOL)paused;

@end

@implementation S2ActionTarget

@synthesize target = _target;
@synthesize action = _action;
@synthesize paused = _paused;

- (void) dealloc
{
	self.target = nil;
	self.action = nil;
	[super dealloc];
}

- (instancetype) init
{
	return [self initWithTarget:nil action:NULL paused:YES];
}

- (instancetype) initWithTarget:(id)target action:(S2Action *)action paused:(BOOL)paused
{
	self = [super init];
	if (self) {
		self.target = target;
		self.action = action;
		self.paused = paused;
	}
	return self;
}

@end

#pragma mark -

@interface S2ActionManager ()

@property(nonatomic, retain) NSMutableArray * targets;

@end

@implementation S2ActionManager

@synthesize targets = _targets;

- (void) dealloc
{
	self.targets = nil;
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.targets = [NSMutableArray arrayWithCapacity:32];
		
		[[S2Scheduler getInstance] scheduleTickForTarget:self priority:0 paused:NO];
	}
	return self;
}

S2_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)

- (void) tick:(s2Time)dt
{
	@synchronized(_targets) {
		S2ActionTarget * item;
		S2_FOR_EACH(item, _targets) {
			if (item.paused == NO) {
				[item.action tick:dt];
			}
		}
	}
}

- (void) addAction:(S2Action *)action target:(id)target paused:(BOOL)paused
{
	NSAssert(action != nil, @"action cannot be nil");
	NSAssert(target != nil, @"target cannot be nil");
	
	S2ActionTarget * item = [[S2ActionTarget alloc] initWithTarget:target action:action paused:paused];
	@synchronized(_targets) {
		[_targets addObject:item];
	}
	[item release];
	
	[action startWithTarget:target];
}

- (void) removeAllActions
{
	@synchronized(_targets) {
		[_targets removeAllObjects];
	}
}

- (void) removeAllActionsFromTarget:(id)target
{
	@synchronized(_targets) {
		NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:[_targets count]];
		
		S2ActionTarget * item;
		S2_FOR_EACH(item, _targets) {
			if (item.target == target) {
				[mArray addObject:item];
			}
		}
		
		[_targets removeObjectsInArray:mArray];
		[mArray release];
	}
}

- (void) removeAction:(S2Action *)action
{
	@synchronized(_targets) {
		NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:[_targets count]];
		
		S2ActionTarget * item;
		S2_FOR_EACH(item, _targets) {
			if (item.action == action) {
				[mArray addObject:item];
			}
		}
		
		[_targets removeObjectsInArray:mArray];
		[mArray release];
	}
}

- (void) pauseTarget:(id)target
{
	@synchronized(_targets) {
		S2ActionTarget * item;
		S2_FOR_EACH(item, _targets) {
			if (item.target == target) {
				item.paused = YES;
			}
		}
	}
}

- (void) resumeTarget:(id)target
{
	@synchronized(_targets) {
		S2ActionTarget * item;
		S2_FOR_EACH(item, _targets) {
			if (item.target == target) {
				item.paused = NO;
			}
		}
	}
}

@end
