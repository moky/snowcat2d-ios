//
//  S2Layer.m
//  SnowCat2D
//
//  Created by Moky on 15-7-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2Node+Rendering.h"
#import "S2Layer.h"

@implementation S2Layer

@synthesize color = _color;

- (void) dealloc
{
	self.color = NULL;
	
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.color = NULL;
	}
	return self;
}

+ (instancetype) layer
{
	return [[[self alloc] init] autorelease];
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
