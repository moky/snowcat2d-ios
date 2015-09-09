//
//  S2ActionInstant.m
//  SnowCat2D
//
//  Created by Moky on 15-7-31.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2Node.h"
#import "S2ActionInstant.h"

@implementation S2Show

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	NSAssert([target isKindOfClass:[S2Node class]],
			 @"target must be a node: %@", target);
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
	NSAssert([target isKindOfClass:[S2Node class]],
			 @"target must be a node: %@", target);
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
	NSAssert([target isKindOfClass:[S2Node class]],
			 @"target must be a node: %@", target);
	((S2Node *)target).visible = !(((S2Node *)target).visible);
}

@end
