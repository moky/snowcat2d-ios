//
//  S2Action.m
//  SnowCat2D
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2ActionInterval.h"
#import "S2Action.h"

@implementation S2Action

@synthesize target = _target;

- (instancetype) init
{
	self = [super init];
	if (self) {
		_target = nil;
	}
	return self;
}

+ (instancetype) action
{
	return [[[self alloc] init] autorelease];
}

- (BOOL) isDone
{
	return YES;
}

- (void) startWithTarget:(id)target
{
	_target = target;
}

- (void) stop
{
	_target = nil;
}

- (void) tick:(s2Time)dt
{
	NSAssert(false, @"override me!");
}

- (void) update:(s2Time)time
{
	NSAssert(false, @"override me!");
}

@end

@interface S2RepeatForever ()

@property(nonatomic, retain) S2ActionInterval * innerAction;

@end

@implementation S2RepeatForever

@synthesize innerAction = _innerAction;

- (void) dealloc
{
	self.innerAction = nil;
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.innerAction = nil;
	}
	return self;
}

- (instancetype) initWithAction:(S2ActionInterval *)action
{
	self = [self init];
	if (self) {
		self.innerAction = action;
	}
	return self;
}

+ (instancetype) actionWithAction:(S2ActionInterval *)action
{
	return [[[self alloc] initWithAction:action] autorelease];
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	NSAssert([_innerAction isKindOfClass:[S2ActionInterval class]],
			 @"inner action error: %@", _innerAction);
	[_innerAction startWithTarget:_target];
}

-(void) tick:(s2Time) dt
{
	[_innerAction tick:dt];
	
	if ([_innerAction isDone]) {
		dt += _innerAction.duration - _innerAction.elapsed;
		[_innerAction startWithTarget:_target];
		[_innerAction tick:dt];
	}
}

@end
