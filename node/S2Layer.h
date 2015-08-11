//
//  S2Layer.h
//  SnowCat2D
//
//  Created by Moky on 15-7-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2Node.h"

@interface S2Layer : S2Node {
	
	CGColorRef _color;
}

@property(nonatomic, readwrite) CGColorRef color;

+ (instancetype) layer;

@end
