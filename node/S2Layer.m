//
//  S2Layer.m
//  SnowCat2D
//
//  Created by Moky on 15-7-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "S2Node+Rendering.h"
#import "S2Layer.h"

@implementation S2Layer

@synthesize color = _color;

- (void) dealloc
{
	self.color = NULL;
	
	[super dealloc];
}

/* designated initializer */
- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.color = NULL;
	}
	return self;
}

- (instancetype) initWithCGColor:(CGColorRef)color
{
	self = [self initWithFrame:CGRectZero];
	if (self) {
		self.color = color;
	}
	return self;
}

- (instancetype) initWithUIColor:(UIColor *)color
{
	return [self initWithCGColor:color.CGColor];
}

- (instancetype) initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
	UIColor * color = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:alpha];
	self = [self initWithUIColor:color];
	[color release];
	return self;
}

+ (instancetype) layer
{
	return [[[self alloc] init] autorelease];
}

+ (instancetype) layerWithCGColor:(CGColorRef)color
{
	return [[[self alloc] initWithCGColor:color] autorelease];
}

+ (instancetype) layerWithUIColor:(UIColor *)color
{
	return [[[self alloc] initWithUIColor:color] autorelease];
}

+ (instancetype) layerWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
	return [[[self alloc] initWithRed:red green:green blue:blue alpha:alpha] autorelease];
}

- (void) setColor:(CGColorRef)color
{
	if (_color != color) {
		CGColorRetain(color);
		CGColorRelease(_color);
		_color = color;
	}
}

#pragma mark - draw

- (void) drawInContext:(CGContextRef)ctx
{
	[super drawInContext:ctx];
	
	if (!_color) {
		return;
	}
	
	CGRect bounds = self.bounds;
	
	//
	//  DRAWING
	//
	CGContextSaveGState(ctx);
	CGContextConcatCTM(ctx, [self nodeToStageTransform]);
	
	CGContextSetFillColorWithColor(ctx, _color);
	CGContextFillRect(ctx, bounds);
	
	CGContextRestoreGState(ctx);
}

@end
