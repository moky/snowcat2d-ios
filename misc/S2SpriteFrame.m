//
//  S2SpriteFrame.m
//  SnowCat2D
//
//  Created by Moky on 15-8-6.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2Texture.h"
#import "S2SpriteFrame.h"

@interface S2SpriteFrame ()

@property(nonatomic, readwrite) CGImageRef imageRef;

@end

@implementation S2SpriteFrame

@synthesize texture = _texture;
@synthesize rect = _rect;
@synthesize rotated = _rotated;

@synthesize imageRef = _imageRef;

- (void) dealloc
{
	self.texture = nil;
	[super dealloc];
}

- (instancetype) init
{
	return [self initWithTexture:nil rect:CGRectZero rotated:NO];
}

- (instancetype) initWithTexture:(S2Texture *)texture rect:(CGRect)rect rotated:(BOOL)rotated
{
	self = [super init];
	if (self) {
		self.texture = texture;
		_rect = rect;
		_rotated = rotated;
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

#pragma mark - setters/getters

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
		NSAssert(false, @"texture error");
		return NULL;
	}
	return _texture;
}

- (void) setRect:(CGRect)rect
{
	if (!CGRectEqualToRect(_rect, rect)) {
		_rect = rect;
		
		self.imageRef = NULL;
	}
}

- (CGRect) rect
{
	if (_rect.size.width <= 0.0f || _rect.size.height <= 0.0f) {
		S2Texture * texture = self.texture;
		if (texture) {
			self.rect = CGRectMake(0.0f, 0.0f, texture.size.width, texture.size.height);
		}
	}
	return _rect;
}

- (void) setRotated:(BOOL)rotated
{
	if (_rotated != rotated) {
		_rotated = rotated;
		
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
	S2Texture * texture = self.texture;
	CGRect rect = self.rect;
	if (!texture || rect.size.width <= 0.0f || rect.size.height <= 0.0f) {
		NSAssert(false, @"texture error");
		return NULL;
	}
	if (!_imageRef) {
		if (CGPointEqualToPoint(rect.origin, CGPointZero) && CGSizeEqualToSize(rect.size, texture.size)) {
			// the whole texture
			_imageRef = CGImageRetain(texture.imageRef);
		} else {
			// partially
			_imageRef = CGImageCreateWithImageInRect(texture.imageRef, rect);
		}
	}
	return _imageRef;
}

@end
