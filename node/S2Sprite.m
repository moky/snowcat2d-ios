//
//  S2Sprite.m
//  SnowCat2D
//
//  Created by Moky on 15-7-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2Node+Rendering.h"
#import "S2Texture.h"
#import "S2TextureCache.h"
#import "S2SpriteFrame.h"
#import "S2Sprite.h"

@interface S2Sprite ()

@property(nonatomic, readwrite) CGImageRef imageRef;

@end

@implementation S2Sprite

@synthesize texture = _texture;
@synthesize textureRect = _textureRect;
@synthesize textureRectRotated = _textureRectRotated;

@synthesize imageRef = _imageRef;

- (void) dealloc
{
	self.texture = nil;
	self.imageRef = NULL;
	[super dealloc];
}

#pragma mark initializers

- (instancetype) init
{
	return [self initWithTexture:nil rect:CGRectZero rotated:NO];
}

- (instancetype) initWithFrame:(CGRect)frame
{
	return [self initWithTexture:nil rect:frame rotated:NO];
}

/* designated initializer */
- (instancetype) initWithTexture:(S2Texture *)texture rect:(CGRect)rect rotated:(BOOL)rotated
{
	CGRect frame = rotated ? CGRectMake(rect.origin.x, rect.origin.y, rect.size.height, rect.size.width) : rect;
	self = [super initWithFrame:frame];
	if (self) {
		self.texture = texture;
		self.textureRect = rect;
		self.textureRectRotated = rotated;
		
		if (_textureRectRotated) {
			self.size = CGSizeMake(_textureRect.size.height, _textureRect.size.width);
		} else {
			self.size = _textureRect.size;
		}
	}
	return self;
}

- (instancetype) initWithTexture:(S2Texture *)texture rect:(CGRect)rect
{
	return [self initWithTexture:texture rect:rect rotated:NO];
}

- (instancetype) initWithTexture:(S2Texture *)texture
{
	CGRect rect = CGRectMake(0.0f, 0.0f, texture.size.width, texture.size.height);
	return [self initWithTexture:texture rect:rect rotated:NO];
}

- (instancetype) initWithFile:(NSString *)file rect:(CGRect)rect rotated:(BOOL)rotated
{
	S2Texture * texture = [[S2TextureCache getInstance] addImage:file];
	return [self initWithTexture:texture rect:rect rotated:rotated];
}

- (instancetype) initWithFile:(NSString *)file rect:(CGRect)rect
{
	S2Texture * texture = [[S2TextureCache getInstance] addImage:file];
	return [self initWithTexture:texture rect:rect rotated:NO];
}

- (instancetype) initWithFile:(NSString *)file
{
	S2Texture * texture = [[S2TextureCache getInstance] addImage:file];
	CGRect rect = CGRectMake(0.0f, 0.0f, texture.size.width, texture.size.height);
	return [self initWithTexture:texture rect:rect rotated:NO];
}

- (instancetype) initWithSpriteFrame:(S2SpriteFrame *)spriteFrame
{
	self = [self initWithTexture:nil rect:spriteFrame.rect rotated:spriteFrame.rotated];
	if (self) {
		self.imageRef = spriteFrame.imageRef;
	}
	return self;
}

#pragma mark factories

+ (instancetype) sprite
{
	return [[[self alloc] init] autorelease];
}

+ (instancetype) spriteWithTexture:(S2Texture *)texture rect:(CGRect)rect rotated:(BOOL)rotated
{
	return [[[self alloc] initWithTexture:texture rect:rect rotated:rotated] autorelease];
}

+ (instancetype) spriteWithTexture:(S2Texture *)texture rect:(CGRect)rect
{
	return [[[self alloc] initWithTexture:texture rect:rect] autorelease];
}

+ (instancetype) spriteWithTexture:(S2Texture *)texture
{
	return [[[self alloc] initWithTexture:texture] autorelease];
}

+ (instancetype) spriteWithSpriteFrame:(S2SpriteFrame *)spriteFrame
{
	return [[[self alloc] initWithSpriteFrame:spriteFrame] autorelease];
}

+ (instancetype) spriteWithFile:(NSString *)file rect:(CGRect)rect rotated:(BOOL)rotated
{
	return [[[self alloc] initWithFile:file rect:rect rotated:rotated] autorelease];
}

+ (instancetype) spriteWithFile:(NSString *)file rect:(CGRect)rect
{
	return [[[self alloc] initWithFile:file rect:rect] autorelease];
}

+ (instancetype) spriteWithFile:(NSString *)file
{
	return [[[self alloc] initWithFile:file] autorelease];
}

#pragma mark - setters/getters

- (CGRect) bounds
{
	if (CGRectEqualToRect(_bounds, CGRectZero)) {
		CGRect textureRect = self.textureRect;
		if (_textureRectRotated) {
			return CGRectMake(0.0f, 0.0f, textureRect.size.height, textureRect.size.width);
		} else {
			return CGRectMake(0.0f, 0.0f, textureRect.size.width, textureRect.size.height);
		}
	}
	return _bounds;
}

- (CGSize) size
{
	if (CGRectEqualToRect(_bounds, CGRectZero)) {
		CGRect textureRect = self.textureRect;
		if (_textureRectRotated) {
			return CGSizeMake(textureRect.size.height, textureRect.size.width);
		} else {
			return _textureRect.size;
		}
	}
	return _bounds.size;
}

- (void) setTexture:(S2Texture *)texture
{
	if (_texture != texture) {
		[texture retain];
		[_texture release];
		_texture = texture;
		
		self.imageRef = NULL;
	}
}

- (S2Texture *) texture
{
	if (!_texture || _texture.size.width <= 0.0f || _texture.size.height <= 0.0f) {
		//NSAssert(false, @"texture error");
		return NULL;
	}
	return _texture;
}

- (void) setTextureRect:(CGRect)textureRect
{
	if (!CGRectEqualToRect(_textureRect, textureRect)) {
		_textureRect = textureRect;
		
		self.imageRef = NULL;
	}
}

- (CGRect) textureRect
{
	if (_textureRect.size.width <= 0.0f || _textureRect.size.height <= 0.0f) {
		S2Texture * texture = self.texture;
		if (texture) {
			self.textureRect = CGRectMake(0.0f, 0.0f, texture.size.width, texture.size.height);
		}
	}
	return _textureRect;
}

- (void) setTextureRectRotated:(BOOL)textureRectRotated
{
	if (_textureRectRotated != textureRectRotated) {
		_textureRectRotated = textureRectRotated;
		
		self.imageRef = NULL;
	}
}

- (void) setImageRef:(CGImageRef)imageRef
{
	if (_imageRef != imageRef) {
		CGImageRetain(imageRef);
		CGImageRelease(_imageRef);
		_imageRef = imageRef;
	}
}

- (CGImageRef) imageRef
{
	if (!_imageRef) {
		S2Texture * texture = self.texture;
		CGRect rect = self.textureRect;
		if (!texture || rect.size.width <= 0.0f || rect.size.height <= 0.0f) {
			NSAssert(false, @"texture error");
			return NULL;
		}
		
		if (CGPointEqualToPoint(rect.origin, CGPointZero) && CGSizeEqualToSize(rect.size, texture.size)) {
			// draw the whole texture
			_imageRef = CGImageRetain(texture.imageRef);
		} else {
			// draw partially
			_imageRef = CGImageCreateWithImageInRect(texture.imageRef, rect);
		}
	}
	return _imageRef;
}

#pragma mark - draw

- (void) drawInContext:(CGContextRef)ctx
{
	[super drawInContext:ctx];
	
	CGImageRef image = self.imageRef;
	CGRect rect = self.textureRect;
	BOOL rotated = self.textureRectRotated;
	
	CGRect bounds = self.bounds;
	
	if (!image) {
		return; // no need to draw a sprite without image
	}
	
	if (rect.size.width <= 0.0f || rect.size.height <= 0.0f) {
		NSAssert(false, @"error texture rect: %@", NSStringFromCGRect(rect));
		return;
	}
	if (bounds.size.width <= 0.0f || bounds.size.height <= 0.0f) {
		NSAssert(false, @"error bounds: %@", NSStringFromCGRect(bounds));
		return;
	}
	
	//
	//  DRAWING
	//
	CGContextSaveGState(ctx);
	CGContextConcatCTM(ctx, [self nodeToStageTransform]);
	
	// affine transform matrix for rotated texture
	CGAffineTransform atm = CGAffineTransformIdentity;
	if (rotated) {
		atm = CGAffineTransformTranslate(atm, bounds.size.width, bounds.size.height);
		atm = CGAffineTransformRotate(atm, -M_PI_2);
		atm = CGAffineTransformScale(atm, bounds.size.height / rect.size.width, -bounds.size.width / rect.size.height);
	} else {
		atm = CGAffineTransformTranslate(atm, 0.0f, bounds.size.height);
		atm = CGAffineTransformScale(atm, bounds.size.width / rect.size.width, -bounds.size.height / rect.size.height);
	}
	
	// 1. transform the matrix of current context for drawing texture
	CGContextConcatCTM(ctx, atm);
	
	// 2. drawing texture
	rect.origin = CGPointZero;
	CGContextDrawImage(ctx, rect, image);
	
	// 3. restore the matrix of current context
	CGContextConcatCTM(ctx, CGAffineTransformInvert(atm));
	
	CGContextRestoreGState(ctx);
}

@end
