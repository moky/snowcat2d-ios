//
//  S2Node+Hierarchy.m
//  SnowCat2D
//
//  Created by Moky on 15-8-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "s2Macros.h"
#import "S2Node+Hierarchy.h"

@implementation S2Node (Common)

+ (void) node:(id<S2Node>)node addChild:(id<S2Node>)child z:(NSInteger)z tag:(NSInteger)tag
{
	NSAssert([child isKindOfClass:[S2Node class]], @"child error: %@", child);
	if (!child) {
		return;
	}
	
	NSMutableArray * children = node.children;
	S2Node * last = [children lastObject];
	if (!last || last.zOrder <= z) {
		[children addObject:child];
	} else {
		NSUInteger index = 0;
		S2_FOR_EACH(last, children) {
			if (last.zOrder > z) {
				break;
			}
			++index;
		}
		[children insertObject:child atIndex:index];
	}
	
	child.zOrder = z;
	child.tag = tag;
	
	if (node.running) {
		[child onEnter];
	}
}

+ (void) node:(id<S2Node>)node removeAllChildrenWithCleanup:(BOOL)cleanup
{
	S2Node * child;
	S2_FOR_EACH(child, node.children) {
		// IMPORTANT:
		//   1st do onExit
		//   2nd cleanup
		if (node.running) {
			[child onExit];
		}
		
		if (cleanup) {
			[child cleanup];
		}
		
		child.parent = nil;
	}
	
	[node.children removeAllObjects];
}

+ (void) node:(id<S2Node>)node removeChild:(id<S2Node>)child cleanup:(BOOL)cleanup
{
	NSAssert([child isKindOfClass:[S2Node class]], @"error child: %@", child);
	
	// IMPORTANT:
	//   1st do onExit
	//   2nd cleanup
	if (node.running) {
		[child onExit];
	}
	
	// If you don't do cleanup, the child's actions will not get removed and the
	// its scheduledSelectors dict will not get released!
	if (cleanup) {
		[child cleanup];
	}
	
	child.parent = nil;
	
	if ([node.children containsObject:child]) {
		[node.children removeObject:child];
	}
}

@end

@implementation S2Node (Hierarchy)

- (S2Node *) getChildByTag:(NSInteger)tag
{
	S2Node * child;
	S2_FOR_EACH(child, _children) {
		if (child.tag == tag) {
			return child;
		}
	}
	return nil;
}

- (void) removeChildByTag:(NSInteger)tag cleanup:(BOOL)cleanup
{
	S2Node * child = [self getChildByTag:tag];
	[self removeChild:child cleanup:cleanup];
}

- (void) removeFromParentAndCleanup:(BOOL)cleanup
{
	[_parent removeChild:self cleanup:cleanup];
}

@end
