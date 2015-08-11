//
//  S2Texture.h
//  SnowCat2D
//
//  Created by Moky on 15-8-6.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface S2Texture : NSObject {
	
	CGImageRef _imageRef;
	CGSize _size;
	CGFloat _scale;
}

@property(nonatomic, readonly) CGImageRef imageRef;
@property(nonatomic, readonly) CGSize size;
@property(nonatomic, readonly) CGFloat scale;

- (instancetype) initWithCGImage:(CGImageRef)image scale:(CGFloat)scale;
- (instancetype) initWithCGImage:(CGImageRef)image;

- (instancetype) initWithUIImage:(UIImage *)image;

@end
