//
//  S2Layer.h
//  SnowCat2D
//
//  Created by Moky on 15-7-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2Node.h"

@class UIColor;

@interface S2Layer : S2Node {
	
	CGColorRef _color;
}

@property(nonatomic, readwrite) CGColorRef color;

/* designated initializer */
- (instancetype) initWithFrame:(CGRect)frame;

- (instancetype) initWithCGColor:(CGColorRef)color;
- (instancetype) initWithUIColor:(UIColor *)color;
- (instancetype) initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

+ (instancetype) layer;
+ (instancetype) layerWithCGColor:(CGColorRef)color;
+ (instancetype) layerWithUIColor:(UIColor *)color;
+ (instancetype) layerWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

@end
