//
//  S2SpriteFrame.h
//  SnowCat2D
//
//  Created by Moky on 15-8-6.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class S2Texture;

@interface S2SpriteFrame : NSObject {
	
	S2Texture * _texture;
	CGRect _rect;
	BOOL _rotated;
	
	CGImageRef _imageRef;
}

@property(nonatomic, retain) S2Texture * texture;
@property(nonatomic, readwrite) CGRect rect;
@property(nonatomic, readwrite) BOOL rotated;

@property(nonatomic, readonly) CGImageRef imageRef;

/* designated initializer */
- (instancetype) initWithTexture:(S2Texture *)texture rect:(CGRect)rect rotated:(BOOL)rotated;

- (instancetype) initWithTexture:(S2Texture *)texture rect:(CGRect)rect;

- (instancetype) initWithTexture:(S2Texture *)texture;

@end
