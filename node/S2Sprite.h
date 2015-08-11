//
//  S2Sprite.h
//  SnowCat2D
//
//  Created by Moky on 15-7-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "S2Node.h"

@class S2Texture;
@class S2SpriteFrame;

@interface S2Sprite : S2Node {
	
	S2Texture * _texture;
	CGRect _textureRect;
	BOOL _textureRectRotated;
}

@property(nonatomic, retain) S2Texture * texture;
@property(nonatomic) CGRect textureRect;
@property(nonatomic) BOOL textureRectRotated;

#pragma mark initializers

/* designated initializer */
- (instancetype) initWithTexture:(S2Texture *)texture rect:(CGRect)rect rotated:(BOOL)rotated;
- (instancetype) initWithTexture:(S2Texture *)texture rect:(CGRect)rect;
- (instancetype) initWithTexture:(S2Texture *)texture;

- (instancetype) initWithSpriteFrame:(S2SpriteFrame *)spriteFrame;

- (instancetype) initWithFile:(NSString *)file rect:(CGRect)rect rotated:(BOOL)rotated;
- (instancetype) initWithFile:(NSString *)file rect:(CGRect)rect;
- (instancetype) initWithFile:(NSString *)file;

#pragma mark factories

+ (instancetype) sprite;

+ (instancetype) spriteWithTexture:(S2Texture *)texture rect:(CGRect)rect rotated:(BOOL)rotated;
+ (instancetype) spriteWithTexture:(S2Texture *)texture rect:(CGRect)rect;
+ (instancetype) spriteWithTexture:(S2Texture *)texture;

+ (instancetype) spriteWithSpriteFrame:(S2SpriteFrame *)spriteFrame;

+ (instancetype) spriteWithFile:(NSString *)file rect:(CGRect)rect rotated:(BOOL)rotated;
+ (instancetype) spriteWithFile:(NSString *)file rect:(CGRect)rect;
+ (instancetype) spriteWithFile:(NSString *)file;

@end
