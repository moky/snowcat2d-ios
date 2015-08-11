//
//  S2Node+Hierarchy.h
//  SnowCat2D
//
//  Created by Moky on 15-8-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2Node.h"

@interface S2Node (Common)

+ (void) node:(id<S2Node>)node addChild:(id<S2Node>)child z:(NSInteger)z tag:(NSInteger)tag;

+ (void) node:(id<S2Node>)node removeChild:(id<S2Node>)child cleanup:(BOOL)cleanup;
+ (void) node:(id<S2Node>)node removeAllChildrenWithCleanup:(BOOL)cleanup;

@end

@interface S2Node (Hierarchy)

// composition: GET
/** Gets a child from the container given its tag
 */
- (S2Node *) getChildByTag:(NSInteger)tag;

/** Removes a child from the container by tag value. It will also cleanup all running actions depending on the cleanup parameter
 */
- (void) removeChildByTag:(NSInteger)tag cleanup:(BOOL)cleanup;

/** Remove itself from its parent node. If cleanup is YES, then also remove all actions and callbacks.
 If the node orphan, then nothing happens.
 */
- (void) removeFromParentAndCleanup:(BOOL)cleanup;

@end
