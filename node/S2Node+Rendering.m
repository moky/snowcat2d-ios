//
//  S2Node+Rendering.m
//  SnowCat2D
//
//  Created by Moky on 15-8-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "s2Macros.h"
#import "S2Node+Rendering.h"

#ifdef S2_DEBUG
void S2DrawSkeleton(CGContextRef ctx, const CGRect rect, const CGPoint anchorPoint)
{
	CGContextBeginPath(ctx);
	
	// 1. draw frame
	CGContextSetLineCap(ctx, kCGLineCapSquare);
	CGContextSetLineWidth(ctx, 1.0f);
	CGContextSetRGBStrokeColor(ctx, 0.0f, 1.0f, 0.0f, 0.5f);
	
	CGContextMoveToPoint(ctx,    rect.origin.x,                   rect.origin.y);
	CGContextAddLineToPoint(ctx, rect.origin.x + rect.size.width, rect.origin.y);
	CGContextAddLineToPoint(ctx, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
	CGContextAddLineToPoint(ctx, rect.origin.x,                   rect.origin.y + rect.size.height);
	CGContextAddLineToPoint(ctx, rect.origin.x,                   rect.origin.y);
	CGContextStrokePath(ctx);
	
	// 2. draw anchor point
	CGContextSetRGBStrokeColor(ctx, 1.0f, 0.0f, 0.0f, 1.0f);
	
	CGPoint point = CGPointMake(rect.origin.x + rect.size.width * anchorPoint.x,
								rect.origin.y + rect.size.height * anchorPoint.y);
	
	static const CGFloat len = 2.0f;
	
	CGContextMoveToPoint(ctx, point.x - len, point.y);
	CGContextAddLineToPoint(ctx, point.x + len, point.y);
	CGContextStrokePath(ctx);
	
	CGContextMoveToPoint(ctx, point.x, point.y - len);
	CGContextAddLineToPoint(ctx, point.x, point.y + len);
	CGContextStrokePath(ctx);
}
#endif

@implementation S2Node (Rendering)

- (CGAffineTransform) nodeToStageTransform
{
	CGAffineTransform t = CGAffineTransformIdentity;
	for (S2Node * p = self; p; p = p.parent) {
		t = CGAffineTransformConcat(t, [p transform]);
	}
	return t;
}

- (CGAffineTransform) stageToNodeTransform
{
	return CGAffineTransformInvert([self transform]);
}

- (CGPoint) convertToNodeSpace:(CGPoint)pointInStage
{
	return CGPointApplyAffineTransform(pointInStage, [self stageToNodeTransform]);
}

- (CGPoint) convertToStageSpace:(CGPoint)pointInNode
{
	return CGPointApplyAffineTransform(pointInNode, [self nodeToStageTransform]);
}

- (void) drawInContext:(CGContextRef)ctx
{
	// inherit me
}

- (void) visitInContext:(CGContextRef)ctx
{
	// quick return if not visible
	if (!_visible) {
		return;
	}
	
	CGContextSaveGState(ctx);
	CGContextConcatCTM(ctx, self.transform);
	
	if ([_children count] > 0) {
		NSEnumerator * enumerator = [_children objectEnumerator];
		S2Node * child = [enumerator nextObject];
		
		// draw children zOrder < 0
		while (child && child.zOrder < 0) {
			[child visitInContext:ctx];
			child = [enumerator nextObject];
		}
		
		// draw self
		[self drawInContext:ctx];
		
#ifdef S2_DEBUG
		// draw skeleton for debug
		S2DrawSkeleton(ctx, self.bounds, self.anchorPoint);
#endif
		
		// draw children zOrder >= 0
		while (child) {
			[child visitInContext:ctx];
			child = [enumerator nextObject];
		}
	} else {
		[self drawInContext:ctx];
		
#ifdef S2_DEBUG
		// draw skeleton for debug
		S2DrawSkeleton(ctx, self.bounds, self.anchorPoint);
#endif
	}
	
	CGContextRestoreGState(ctx);
}

@end
