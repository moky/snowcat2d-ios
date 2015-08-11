//
//  S2Node+Rendering.h
//  SnowCat2D
//
//  Created by Moky on 15-8-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2Node.h"

@interface S2Node (Rendering)

- (CGAffineTransform) nodeToStageTransform;
- (CGAffineTransform) stageToNodeTransform;

- (CGPoint) convertToNodeSpace:(CGPoint)pointInStage;
- (CGPoint) convertToStageSpace:(CGPoint)pointInNode;

- (void) drawInContext:(CGContextRef)ctx;
- (void) visitInContext:(CGContextRef)ctx;

@end
