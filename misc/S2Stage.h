//
//  S2Stage.h
//  SnowCat2D
//
//  Created by Moky on 15-7-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "S2Node.h"

@interface S2Stage : CALayer<S2Node>

- (void) redraw;

@end
