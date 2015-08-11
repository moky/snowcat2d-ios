//
//  S2ActionInstant.m
//  SnowCat2D
//
//  Created by Moky on 15-7-31.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2Node.h"
#import "S2ActionInstant.h"

@implementation S2ActionInstant

- (instancetype) init
{
	self = [super init];
	if (self) {
		_duration = 0.0f;
	}
	return self;
}

- (BOOL) isDone
{
	return YES;
}

- (void) tick:(s2Time)dt
{
	[self update:1.0f];
}

- (void) update:(s2Time)time
{
	// do nothing
}

- (S2FiniteTimeAction *) reverse
{
	return [[[[self class] alloc] init] autorelease];
}

@end

@implementation S2Show

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	NSAssert([target isKindOfClass:[S2Node class]], @"target must be a node: %@", target);
	((S2Node *)target).visible = YES;
}

- (S2FiniteTimeAction *) reverse
{
	return [S2Hide action];
}

@end

@implementation S2Hide

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	NSAssert([target isKindOfClass:[S2Node class]], @"target must be a node: %@", target);
	((S2Node *)target).visible = NO;
}

- (S2FiniteTimeAction *) reverse
{
	return [S2Show action];
}

@end

@implementation S2ToggleVisibility

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	NSAssert([target isKindOfClass:[S2Node class]], @"target must be a node: %@", target);
	((S2Node *)target).visible = !(((S2Node *)target).visible);
}

@end

#pragma mark - Callback

@interface S2CallFunc ()

@property(nonatomic, retain) id targetCallback;
@property(nonatomic, readwrite) SEL selector;

@end

@implementation S2CallFunc

@synthesize targetCallback = _targetCallback;
@synthesize selector = _selector;

- (void) dealloc
{
	self.targetCallback = nil;
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.targetCallback = nil;
		self.selector = NULL;
	}
	return self;
}

- (instancetype) initWithTarget:(id)target selector:(SEL)selector
{
	self = [self init];
	if (self) {
		self.targetCallback = target;
		self.selector = selector;
	}
	return self;
}

+ (instancetype) actionWithTarget:(id)target selector:(SEL)selector
{
	return [[self alloc] initWithTarget:target selector:selector];
}

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	// execute
	NSAssert([_targetCallback respondsToSelector:_selector], @"error target & selector");
	[_targetCallback performSelector:_selector];
}

@end

#pragma mark Blocks Support

#if NS_BLOCKS_AVAILABLE

@implementation S2CallBlock

- (void) dealloc
{
	[_block release];
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		[_block release];
		_block = NULL;
	}
	return self;
}

- (instancetype) initWithBlock:(void (^)())block
{
	self = [self init];
	if (self) {
		[_block release];
		_block = [block copy];
	}
	return self;
}

+ (instancetype) actionWithBlock:(void (^)())block
{
	return [[[self alloc] initWithBlock:block] autorelease];
}

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	// execute
	_block();
}

@end

#endif
