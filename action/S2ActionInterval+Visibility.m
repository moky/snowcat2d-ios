//
//  S2ActionInterval+Visibility.m
//  SnowCat2D
//
//  Created by Moky on 15-8-3.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2Node.h"
#import "S2ActionInterval+Visibility.h"

@implementation S2Blink

- (instancetype) initWithDuration:(s2Time)duration blinks:(NSUInteger)blinks
{
	NSAssert(blinks > 0, @"parameter error");
	self = [self initWithDuration:duration];
	if (self) {
		_times = blinks;
	}
	return self;
}

+ (instancetype) actionWithDuration:(s2Time)duration blinks:(NSUInteger)blinks
{
	return [[[self alloc] initWithDuration:duration blinks:blinks] autorelease];
}

- (void) update:(s2Time)time
{
	if (![self isDone]) {
		s2Time slice = 1.0f / _times;
		s2Time m = fmodf(time, slice);
		[_target setVisible:(m > slice/2.0f)];
	}
}

- (S2ActionInterval *) reverse
{
	return self;
}

@end

@implementation S2FadeIn

- (void) update:(s2Time)time
{
	// TODO: setOpacity:(255 * time)
}

- (S2ActionInterval *) reverse
{
	return [S2FadeOut actionWithDuration:_duration];
}

@end

@implementation S2FadeOut

- (void) update:(s2Time)time
{
	// TODO: setOpacity:(255 * (1 - time))
}

- (S2ActionInterval *) reverse
{
	return [S2FadeIn actionWithDuration:_duration];
}

@end

@implementation S2FadeTo

- (instancetype) initWithDuration:(s2Time)duration opacity:(s2Byte)opacity
{
	self = [self initWithDuration:duration];
	if (self) {
		_toOpacity = opacity;
	}
	return self;
}

+ (instancetype) actionWithDuration:(s2Time)duration opacity:(s2Byte)opacity
{
	return [[[self alloc] initWithDuration:duration opacity:opacity] autorelease];
}

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	// TODO: get start opacity
}

- (void) update:(s2Time)time
{
	// TODO: setOpacity:(_fromOpacity + (_toOpacity - _fromOpacity) * time)
}

@end

@implementation S2TintTo

- (instancetype) initWithDuration:(s2Time)duration red:(s2Byte)r green:(s2Byte)g blue:(s2Byte)b
{
	self = [self initWithDuration:duration];
	if (self) {
		_toColor.r = r;
		_toColor.g = g;
		_toColor.b = b;
	}
	return self;
}

+ (instancetype) actionWithDuration:(s2Time)duration red:(s2Byte)r green:(s2Byte)g blue:(s2Byte)b
{
	return [[[self alloc] initWithDuration:duration red:r green:g blue:b] autorelease];
}

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	// TODO: get from color
}

- (void) update:(s2Time)time
{
	// TODO: set delta color
}

@end

@implementation S2TintBy

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	_delta = _toColor;
}

@end
