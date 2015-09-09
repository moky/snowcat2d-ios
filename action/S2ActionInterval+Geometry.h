//
//  S2ActionInterval+Geometry.h
//  SnowCat2D
//
//  Created by Moky on 15-7-28.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

#import "S2ActionInterval.h"

/** Moves a Node object to the position x,y. x and y are absolute coordinates by modifying it's position attribute.
 */
@interface S2MoveTo : S2ActionInterval {
	
	CGPoint _startPoint;
	CGPoint _endPoint;
	CGPoint _distance;
}

- (instancetype) initWithDuration:(float)duration position:(CGPoint)endPoint;
+ (instancetype) actionWithDuration:(float)duration position:(CGPoint)endPoint;

@end

/**  Moves a Node object x,y pixels by modifying it's position attribute.
 x and y are relative to the position of the object.
 Duration is is seconds.
 */
@interface S2MoveBy : S2MoveTo

- (instancetype) initWithDuration:(float)duration distance:(CGPoint)distance;
+ (instancetype) actionWithDuration:(float)duration distance:(CGPoint)distance;

@end

/**  Rotates a Node object to a certain angle by modifying it's
 rotation attribute.
 The direction will be decided by the shortest angle.
 */
@interface S2RotateTo : S2ActionInterval {
	
	CGFloat _startAngle;
	CGFloat _endAngle;
	CGFloat _delta;
}

- (instancetype) initWithDuration:(float)duration angle:(CGFloat)angle;
+ (instancetype) actionWithDuration:(float)duration angle:(CGFloat)angle;

@end

/** Rotates a Node object clockwise a number of degrees by modiying it's rotation attribute.
 */
@interface S2RotateBy : S2RotateTo

@end

/** Skews a Node object to given angles by modifying it's skewX and skewY attributes
 */
@interface S2SkewTo : S2ActionInterval {
	
	CGPoint _startSkew;
	CGPoint _endSkew;
	CGPoint _delta;
}

- (instancetype) initWithDuration:(float)duration skewX:(CGFloat)sx skewY:(CGFloat)sy;
+ (instancetype) actionWithDuration:(float)duration skewX:(CGFloat)sx skewY:(CGFloat)sy;

@end

/** Skews a Node object by skewX and skewY degrees
 */
@interface S2SkewBy : S2SkewTo

@end

/** Scales a Node object to a zoom factor by modifying it's scale attribute.
 */
@interface S2ScaleTo : S2ActionInterval {
	
	CGPoint _startScale;
	CGPoint _endScale;
	CGPoint _delta;
}

- (instancetype) initWithDuration:(float)duration scaleX:(CGFloat)sx scaleY:(CGFloat)sy;
- (instancetype) initWithDuration:(float)duration scale:(CGFloat)scale;
+ (instancetype) actionWithDuration:(float)duration scaleX:(CGFloat)sx scaleY:(CGFloat)sy;
+ (instancetype) actionWithDuration:(float)duration scale:(CGFloat)scale;

@end

/** Scales a Node object a zoom factor by modifying it's scale attribute.
 */
@interface S2ScaleBy : S2ScaleTo

@end

#pragma mark -

/** Moves a Node object simulating a parabolic jump movement by modifying it's position attribute.
 */
@interface S2JumpTo : S2ActionInterval {
	
	CGPoint _startPosition;
	CGPoint _endPosition;
	CGPoint _delta;
	float _height;
	NSUInteger _jumps;
}

- (instancetype) initWithDuration:(float)duration position:(CGPoint)position height:(float)height jumps:(NSUInteger)jumps;
+ (instancetype) actionWithDuration:(float)duration position:(CGPoint)position height:(float)height jumps:(NSUInteger)jumps;

@end

@interface S2JumpBy : S2JumpTo

- (instancetype) initWithDuration:(float)duration distance:(CGPoint)distance height:(float)height jumps:(NSUInteger)jumps;
+ (instancetype) actionWithDuration:(float)duration distance:(CGPoint)distance height:(float)height jumps:(NSUInteger)jumps;

@end

/** bezier configuration structure
 */
typedef struct _s2BezierConfig {
	//! end position of the bezier
	CGPoint endPosition;
	//! Bezier control points
	CGPoint controlPoints[2];
} s2BezierConfig;

/** An action that moves the target with a cubic Bezier curve to a destination point.
 */
@interface S2BezierTo : S2ActionInterval {
	
	CGPoint _startPosition;
	s2BezierConfig _config;
	s2BezierConfig _delta;
}

- (instancetype) initWithDuration:(float)duration bezier:(s2BezierConfig)config;
+ (instancetype) actionWithDuration:(float)duration bezier:(s2BezierConfig)config;

@end

/** An action that moves the target with a cubic Bezier curve by a certain distance.
 */
@interface S2BezierBy : S2BezierTo

@end
