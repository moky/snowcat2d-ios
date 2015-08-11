//
//  S2FiniteTimeAction.m
//  SnowCat2D
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2FiniteTimeAction.h"

@implementation S2FiniteTimeAction

@synthesize duration = _duration;

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.duration = 0.0f;
	}
	return self;
}

- (S2FiniteTimeAction *) reverse
{
	NSAssert(false, @"implement me");
	return nil;
}

@end
