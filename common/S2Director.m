//
//  S2Director.m
//  SnowCat2D
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#include <sys/time.h>

#import "s2Macros.h"
#import "s2Types.h"
#import "S2Scheduler.h"
#import "S2Director.h"

#define kDefaultFPS 60.0f // 60 frames per second
#define kDefaultInterval (1.0f / kDefaultFPS)

@interface S2Director () {
	
	/* last time the main loop was updated */
	struct timeval _lastTime;
	/* delta time since last tick to main loop */
	s2Time _deltaTime;
}

@property(nonatomic, retain) NSMutableArray * stages;

@end

@implementation S2Director

@synthesize running = _running;

@synthesize stages = _stages;

- (void) dealloc
{
	self.stages = nil;
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		gettimeofday(&_lastTime, NULL);
		_deltaTime = FLT_EPSILON;
		
		self.stages = [NSMutableArray arrayWithCapacity:8];
		
		[self start];
	}
	return self;
}

S2_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)

- (void) addStage:(S2Stage *)stage
{
	if (!stage) {
		NSAssert(false, @"stage cannot be nil");
		return;
	}
	@synchronized(_stages) {
		NSAssert(![_stages containsObject:stage], @"stage already exists");
		[_stages addObject:stage];
	}
}

- (void) removeStage:(S2Stage *)stage
{
	if (!stage) {
		NSAssert(false, @"stage cannot be nil");
		return;
	}
	@synchronized(_stages) {
		NSAssert([_stages containsObject:stage], @"stage not exists");
		[_stages removeObject:stage];
	}
}

- (void) start
{
	[self startAnimation];
}

- (void) stop
{
	// TODO: stop the thread
}

- (void) _calculateDeltaTime
{
	struct timeval now;
	
	if (gettimeofday(&now, NULL) != 0) {
		NSAssert(false, @"error in gettimeofday");
		_deltaTime = FLT_EPSILON;
		return;
	}
	
	_deltaTime = s2_difftime(now, _lastTime);
	NSAssert(_deltaTime > 0.0f, @"time error");
	
	_lastTime = now;
}

- (void) startAnimation
{
	NSAssert(_running == NO, @"Calling startAnimation twice?");
	
	_running = YES;
	
	NSThread * thread = [[NSThread alloc] initWithTarget:self
												selector:@selector(mainLoop)
												  object:nil];
	[thread start];
	[thread release];
}

- (void) mainLoop
{
	while (![[NSThread currentThread] isCancelled]) {
		if (!_running) {
			s2_sleep(0.5); // if paused, don't consume CPU
			continue;
		}
		
		[self _calculateDeltaTime];
		
		// drive scheduler
		[[S2Scheduler getInstance] tick:_deltaTime];
		
		// redraw all stages
		@synchronized(_stages) {
			S2Stage * stage;
			S2_FOR_EACH(_stages, stage) {
				[stage performSelectorOnMainThread:@selector(redraw)
										withObject:nil
									 waitUntilDone:NO];
			}
		}
		
		float dt = kDefaultInterval - _deltaTime;
		if (dt < 0.01f) {
			s2_sleep(0.01f);
		} else {
			s2_sleep(dt);
		}
	}
}

@end
