//
//  SnowCat2D.h
//  SnowCat2D
//
//  Created by Moky on 15-7-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

/**
 *  Dependences:
 *
 *      <Foundation.framework>
 *      <CoreGraphics.framework>
 *      <CoreText.framework>
 *      <QuartzCore.framework>
 *      <UIKit.framework>
 *
 */

//
//  action
//
#import "S2Action.h"
#import "S2FiniteTimeAction.h"
#import "S2ActionInstant.h"
#import "S2ActionInterval.h"
#import "S2ActionInterval+Geometry.h"
#import "S2ActionInterval+Visibility.h"

//
//  node
//
#import "S2Node.h"
#import "S2Node+Hierarchy.h"
#import "S2Node+Rendering.h"
#import "S2Layer.h"
#import "S2Sprite.h"
#import "S2Label.h"

//
//  flash
//

//
//  common
//
#import "s2Macros.h"
#import "s2Types.h"
#import "S2Timer.h"

#import "S2SpriteFrame.h"
#import "S2SpriteFrameCache.h"
#import "S2Texture.h"
#import "S2TextureCache.h"

#import "S2Stage.h"
#import "S2View.h"

#import "S2ActionManager.h"
#import "S2Scheduler.h"
#import "S2Director.h"

NSString * snowcat2dVersion(void);
