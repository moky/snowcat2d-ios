//
//  S2View.m
//  SnowCat2D
//
//  Created by Moky on 15-7-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2Node+Rendering.h"
#import "S2View.h"

@interface S2View ()

@property(nonatomic, retain) UITapGestureRecognizer * tapGestureRecognizer;

@end

@implementation S2View

@synthesize tapGestureRecognizer = _tapGestureRecognizer;

+ (Class) layerClass
{
	return [S2Stage class];
}

- (void) dealloc
{
	S2Stage * stage = self.stage;
	if (stage.running) {
		[stage onExit];
	}
	
	self.tapGestureRecognizer = nil;
	
	[super dealloc];
}

- (void) _initializeS2View
{
	// active gesture recognizer
	self.userInteractionEnabled = NO;
	self.userInteractionEnabled = YES;
	
	// start state
	S2Stage * stage = self.stage;
	if (stage.running == NO) {
		[stage onEnter];
	}
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeS2View];
	}
	return self;
}

// default initializer
- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeS2View];
	}
	return self;
}

- (S2Stage *) stage
{
	return (S2Stage *)self.layer;
}

- (void) setNeedsDisplay
{
	[super setNeedsDisplay];
	[self.layer setNeedsDisplay];
}

- (void) setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
	if (self.userInteractionEnabled != userInteractionEnabled) {
		[super setUserInteractionEnabled:userInteractionEnabled];
		
		UITapGestureRecognizer * recognizer = nil;
		if (userInteractionEnabled) {
			recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
																 action:@selector(_handleTapGesture:)];
			recognizer = [recognizer autorelease];
		}
		self.tapGestureRecognizer = recognizer;
	}
}

- (void) setTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer
{
	if (_tapGestureRecognizer != tapGestureRecognizer) {
		
		if (tapGestureRecognizer) {
			[self addGestureRecognizer:tapGestureRecognizer];
			[tapGestureRecognizer retain];
		}
		if (_tapGestureRecognizer) {
			[self removeGestureRecognizer:_tapGestureRecognizer];
			[_tapGestureRecognizer release];
		}
		
		_tapGestureRecognizer = tapGestureRecognizer;
	}
}

- (S2Node *) _hitTest:(CGPoint)pointInStage node:(S2Node *)node
{
	if (node.isVisible == NO) {
		return nil;
	}
	
	NSEnumerator * enumerator = [node.children reverseObjectEnumerator];
	S2Node * child;
	
	// check child.zOrder >= 0
	while (child = [enumerator nextObject]) {
		if (child.zOrder < 0) {
			break;
		}
		if (child.isVisible == NO) {
			continue;
		}
		if (child.isTouchEnabled &&
			CGRectContainsPoint(child.bounds, [child convertToNodeSpace:pointInStage])) {
			return child; // got it
		}
	}
	
	// check self
	if (node.isTouchEnabled &&
		CGRectContainsPoint(node.bounds, [node convertToNodeSpace:pointInStage])) {
		return node; // got it
	}
	
	// check child.zOrder < 0
	while (child = [enumerator nextObject]) {
		if (child.isVisible == NO) {
			continue;
		}
		if (child.isTouchEnabled &&
			CGRectContainsPoint(child.bounds, [child convertToNodeSpace:pointInStage])) {
			return child; // got it
		}
	}
	
	// not found
	return nil;
}

- (void) _hitTest:(CGPoint)pointInStage
{
	S2Stage * stage = self.stage;
	S2Node * node;
	S2_FOR_EACH_REVERSE(stage.children, node) {
		node = [self _hitTest:pointInStage node:node];
		if (node) {
			break; // got it
		}
	}
	if (node) {
		[node onClick];
	}
}

- (void) _handleTapGesture:(UITapGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateEnded) {
		CGPoint point = [recognizer locationInView:recognizer.view];
		[self _hitTest:point];
	}
}

@end
