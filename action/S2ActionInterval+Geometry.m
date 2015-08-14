//
//  S2ActionInterval+Geometry.m
//  SnowCat2D
//
//  Created by Moky on 15-7-28.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2Node.h"
#import "S2ActionInterval+Geometry.h"

@implementation S2MoveTo

- (instancetype) initWithDuration:(s2Time)duration position:(CGPoint)endPoint
{
	self = [self initWithDuration:duration];
	if (self) {
		_endPoint = endPoint;
	}
	return self;
}

+ (instancetype) actionWithDuration:(s2Time)duration position:(CGPoint)endPoint
{
	return [[[self alloc] initWithDuration:duration position:endPoint] autorelease];
}

- (void) startWithTarget:(id)target
{
	NSAssert([target isKindOfClass:[S2Node class]],
			 @"error target: %@", target);
	
	[super startWithTarget:target];
	_startPoint = [(S2Node *)target position];
	_distance = CGPointMake(_endPoint.x - _startPoint.x,
							_endPoint.y - _startPoint.y);
}

- (void) update:(s2Time)time
{
	NSAssert([_target isKindOfClass:[S2Node class]],
			 @"error target: %@", _target);
	
	CGPoint point = CGPointMake(_startPoint.x + _distance.x * time,
								_startPoint.y + _distance.y * time);
	[(S2Node *)_target setPosition:point];
}

@end

@implementation S2MoveBy

- (instancetype) initWithDuration:(s2Time)duration position:(CGPoint)endPoint
{
	NSAssert(false, @"use 'initWithDuration:distance:'");
	return [self initWithDuration:duration distance:endPoint];
}

- (instancetype) initWithDuration:(s2Time)duration distance:(CGPoint)distance
{
	self = [self initWithDuration:duration];
	if (self) {
		_distance = distance;
	}
	return self;
}

+ (instancetype) actionWithDuration:(s2Time)duration position:(CGPoint)endPoint
{
	NSAssert(false, @"use 'actionWithDuration:distance:'");
	return [self actionWithDuration:duration distance:endPoint];
}

+ (instancetype) actionWithDuration:(s2Time)duration distance:(CGPoint)distance
{
	return [[[self alloc] initWithDuration:duration distance:distance] autorelease];
}

- (void) startWithTarget:(id)target
{
	CGPoint point = _distance;
	[super startWithTarget:target];
	_distance = point;
}

- (S2ActionInterval *) reverse
{
	CGPoint distance = CGPointMake(-_distance.x, -_distance.y);
	return [[self class] actionWithDuration:_duration distance:distance];
}

@end

@implementation S2RotateTo

- (instancetype) initWithDuration:(s2Time)duration angle:(CGFloat)angle
{
	self = [self initWithDuration:duration];
	if (self) {
		_endAngle = angle;
	}
	return self;
}

+ (instancetype) actionWithDuration:(s2Time)duration angle:(CGFloat)angle
{
	return [[[self alloc] initWithDuration:duration angle:angle] autorelease];
}

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	
	_startAngle = [target rotation];
	if (_startAngle >= M_PI * 2.0f) {
		_startAngle = fmodf(_startAngle, M_PI * 2.0f);
	} else if (_startAngle < 0.0f) {
		_startAngle = fmodf(_startAngle, -M_PI * 2.0f);
	}
	
	_delta = _endAngle - _startAngle;
	if (_delta > M_PI) {
		_delta -= M_PI * 2.0f;
	} else if (_delta < -M_PI) {
		_delta += M_PI * 2.0f;
	}
}

- (void) update:(s2Time)time
{
	[_target setRotation:(_startAngle + _delta * time)];
}

@end

@implementation S2RotateBy

- (instancetype) initWithDuration:(s2Time)duration angle:(CGFloat)angle
{
	self = [self initWithDuration:duration];
	if (self) {
		_delta = angle;
	}
	return self;
}

- (void) startWithTarget:(id)target
{
	CGFloat delta = _delta;
	[super startWithTarget:target];
	_delta = delta;
}

- (S2ActionInterval *) reverse
{
	return [[[[self class] alloc] initWithDuration:_duration angle:-_delta] autorelease];
}

@end

@implementation S2SkewTo

- (instancetype) initWithDuration:(s2Time)duration skewX:(CGFloat)sx skewY:(CGFloat)sy
{
	self = [self initWithDuration:duration];
	if (self) {
		_endSkew = CGPointMake(sx, sy);
	}
	return self;
}

+ (instancetype) actionWithDuration:(s2Time)duration skewX:(CGFloat)sx skewY:(CGFloat)sy
{
	return [[[self alloc] initWithDuration:duration skewX:sx skewY:sy] autorelease];
}

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	
	_startSkew = CGPointMake([target skewX], [target skewY]);
	
	if (_startSkew.x >= M_PI * 2.0f) {
		_startSkew.x = fmodf(_startSkew.x, M_PI * 2.0f);
	} else if (_startSkew.x < 0.0f) {
		_startSkew.x = fmodf(_startSkew.x, -M_PI * 2.0f);
	}
	
	if (_startSkew.y >= M_PI * 2.0f) {
		_startSkew.y = fmodf(_startSkew.y, M_PI * 2.0f);
	} else if (_startSkew.y < 0.0f) {
		_startSkew.y = fmodf(_startSkew.y, -M_PI * 2.0f);
	}
	
	_delta = CGPointMake(_endSkew.x - _startSkew.x,
						 _endSkew.y - _startSkew.y);
	
	if (_delta.x > M_PI) {
		_delta.x -= M_PI * 2.0f;
	} else if (_delta.x < -M_PI) {
		_delta.x += M_PI * 2.0f;
	}
	
	if (_delta.y > M_PI) {
		_delta.y -= M_PI * 2.0f;
	} else if (_delta.y < -M_PI) {
		_delta.y += M_PI * 2.0f;
	}
}

- (void) update:(s2Time)time
{
	[_target setSkewX:(_startSkew.x + _delta.x * time)];
	[_target setSkewY:(_startSkew.y + _delta.y * time)];
}

@end

@implementation S2SkewBy

- (instancetype) initWithDuration:(s2Time)duration skewX:(CGFloat)sx skewY:(CGFloat)sy
{
	self = [super initWithDuration:duration skewX:sx skewY:sy];
	if (self) {
		_delta = CGPointMake(sx, sy);
	}
	return self;
}

- (void) startWithTarget:(id)target
{
	CGPoint delta = _delta;
	[super startWithTarget:target];
	_delta = delta;
}

- (S2ActionInterval *) reverse
{
	return [[self class] actionWithDuration:_duration
									  skewX:-_delta.x
									  skewY:-_delta.y];
}

@end

@implementation S2ScaleTo

- (instancetype) initWithDuration:(s2Time)duration scaleX:(CGFloat)sx scaleY:(CGFloat)sy
{
	self = [self initWithDuration:duration];
	if (self) {
		_endScale = CGPointMake(sx, sy);
	}
	return self;
}

- (instancetype) initWithDuration:(s2Time)duration scale:(CGFloat)scale
{
	return [self initWithDuration:duration scaleX:scale scaleY:scale];
}

+ (instancetype) actionWithDuration:(s2Time)duration scaleX:(CGFloat)sx scaleY:(CGFloat)sy
{
	return [[[self alloc] initWithDuration:duration scaleX:sx scaleY:sy] autorelease];
}

+ (instancetype) actionWithDuration:(s2Time)duration scale:(CGFloat)scale
{
	return [self actionWithDuration:duration scaleX:scale scaleY:scale];
}

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	_startScale = CGPointMake([target scaleX], [target scaleY]);
	_delta = CGPointMake(_endScale.x - _startScale.x,
						 _endScale.y - _startScale.y);
}

- (void) update:(s2Time)time
{
	[_target setScaleX:(_startScale.x + _delta.x * time)];
	[_target setScaleY:(_startScale.y + _delta.y * time)];
}

@end

@implementation S2ScaleBy

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	_delta = CGPointMake(_startScale.x * _endScale.x - _startScale.x,
						 _startScale.y * _endScale.y - _startScale.y);
}

- (S2ActionInterval *) reverse
{
	return [[self class] actionWithDuration:_duration
									 scaleX:(1.0f / _endScale.x)
									 scaleY:(1.0f / _endScale.y)];
}

@end

#pragma mark -

@implementation S2JumpTo

- (instancetype) initWithDuration:(s2Time)duration position:(CGPoint)position height:(s2Time)height jumps:(NSUInteger)jumps
{
	self = [self initWithDuration:duration];
	if (self) {
		_endPosition = position;
		_height = height;
		_jumps = jumps;
	}
	return self;
}

+ (instancetype) actionWithDuration:(s2Time)duration position:(CGPoint)position height:(s2Time)height jumps:(NSUInteger)jumps
{
	return [[[self alloc] initWithDuration:duration position:position height:height jumps:jumps] autorelease];
}

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	_startPosition = [target position];
	_delta = CGPointMake(_endPosition.x - _startPosition.x,
						 _endPosition.y - _startPosition.y);
}

- (void) update:(s2Time)time
{
	// Sin jump. Less realistic
//	CGFloat ss = _height * fabsf(sinf(time * (CGFloat)M_PI * _jumps));
//	CGFloat dy = ss + _delta.y * time;
//	CGFloat dx = _delta.x * time;
	
	// parabolic jump
	CGFloat frac = fmodf(time * _jumps, 1.0f);
	CGFloat dy = _height * 4 * frac * (1.0f - frac) + _delta.y * time;
	CGFloat dx = _delta.x * time;
	[_target setPosition:CGPointMake(_startPosition.x + dx,
									 _startPosition.y + dy)];
}

@end

@implementation S2JumpBy

- (instancetype) initWithDuration:(s2Time)duration position:(CGPoint)position height:(s2Time)height jumps:(NSUInteger)jumps
{
	NSAssert(false, @"use 'initWithDuration:distance:height:jumps:'");
	return [self initWithDuration:duration distance:position height:height jumps:jumps];
}

- (instancetype) initWithDuration:(s2Time)duration distance:(CGPoint)distance height:(s2Time)height jumps:(NSUInteger)jumps
{
	self = [self initWithDuration:duration];
	if (self) {
		_delta = distance;
		_height = height;
		_jumps = jumps;
	}
	return self;
}

+ (instancetype) actionWithDuration:(s2Time)duration position:(CGPoint)position height:(s2Time)height jumps:(NSUInteger)jumps
{
	NSAssert(false, @"use 'actionWithDuration:distance:height:jumps:'");
	return [self actionWithDuration:duration distance:position height:height jumps:jumps];
}

+ (instancetype) actionWithDuration:(s2Time)duration distance:(CGPoint)distance height:(s2Time)height jumps:(NSUInteger)jumps
{
	return [[[self alloc] initWithDuration:duration distance:distance height:height jumps:jumps] autorelease];
}

- (void) startWithTarget:(id)target
{
	CGPoint delta = _delta;
	[super startWithTarget:target];
	_delta = delta;
}

- (S2ActionInterval *) reverse
{
	CGPoint distance = CGPointMake(-_delta.x, -_delta.y);
	return [[self class] actionWithDuration:_duration distance:distance height:_height jumps:_jumps];
}

@end

// Bezier cubic formula:
//	((1 - t) + t)3 = 1
// Expands to…
//   (1 - t)3 + 3t(1-t)2 + 3t2(1 - t) + t3 = 1
static inline float bezierat(float a, float b, float c, float d, s2Time t)
{
	return (powf(1 - t, 3) * a +
			3 * t * (powf(1 - t, 2)) * b +
			3 * powf(t, 2) * (1 - t) * c +
			powf(t, 3) * d);
}

@implementation S2BezierTo

- (instancetype) initWithDuration:(s2Time)duration bezier:(s2BezierConfig)config
{
	self = [self initWithDuration:duration];
	if (self) {
		_config = config;
	}
	return self;
}

+ (instancetype) actionWithDuration:(s2Time)duration bezier:(s2BezierConfig)config
{
	return [[[self alloc] initWithDuration:duration bezier:config] autorelease];
}

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	_startPosition = [target position];
	
	_delta.endPosition = CGPointMake(_config.endPosition.x - _startPosition.x,
									 _config.endPosition.y - _startPosition.y);
	
	_delta.controlPoints[0] = CGPointMake(_config.controlPoints[0].x - _startPosition.x,
										  _config.controlPoints[0].y - _startPosition.y);
	
	_delta.controlPoints[1] = CGPointMake(_config.controlPoints[1].x - _startPosition.x,
										  _config.controlPoints[1].y - _startPosition.y);
}

- (void) update:(s2Time)time
{
	float xa = 0;
	float xb = _delta.controlPoints[0].x;
	float xc = _delta.controlPoints[1].x;
	float xd = _delta.endPosition.x;
	
	float ya = 0;
	float yb = _delta.controlPoints[0].y;
	float yc = _delta.controlPoints[1].y;
	float yd = _delta.endPosition.y;
	
	float dx = bezierat(xa, xb, xc, xd, time);
	float dy = bezierat(ya, yb, yc, yd, time);
	
	CGPoint position = CGPointMake(_startPosition.x + dx,
								   _startPosition.y + dy);
	[_target setPosition:position];
}

@end

@implementation S2BezierBy

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	_delta = _config;
}

- (S2ActionInterval *) reverse
{
	s2BezierConfig r;
	
	r.endPosition = CGPointMake(-_config.endPosition.x,
								-_config.endPosition.y);
	
	r.controlPoints[0] = CGPointMake(_config.controlPoints[1].x - _config.endPosition.x,
									 _config.controlPoints[1].y - _config.endPosition.y);
	
	r.controlPoints[1] = CGPointMake(_config.controlPoints[0].x - _config.endPosition.x,
									 _config.controlPoints[0].y - _config.endPosition.y);
	
	return [[[self class] actionWithDuration:_duration bezier:r] autorelease];
}

@end
