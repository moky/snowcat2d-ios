
//
//  S2Label.m
//  SnowCat2D
//
//  Created by Moky on 15-8-4.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#import "s2Macros.h"
#import "S2Node+Rendering.h"
#import "S2Label.h"

@interface S2Label ()

@property(nonatomic, readwrite) CTLineRef line;

@end

@implementation S2Label

@synthesize text = _text;
@synthesize color = _color;

@synthesize fontName = _fontName;
@synthesize fontSize = _fontSize;

@synthesize alignment = _alignment;

@synthesize line = _line;

- (void) dealloc
{
	self.text = nil;
	self.color = nil;
	
	self.fontName = nil;
	
	self.line = NULL;
	
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.text = nil;
		self.color = [UIColor blackColor].CGColor;
		
		self.fontName = @"STHeitiSC-Medium";
		self.fontSize = 12.0f;
		
		self.alignment = S2TextAlignmentCenter;
		
		self.line = NULL;
	}
	return self;
}

- (void) setText:(NSString *)text
{
	if (![_text isEqualToString:text]) {
		[text retain];
		[_text release];
		_text = text;
		
		self.line = NULL;
	}
}

- (void) setColor:(CGColorRef)color
{
	if (_color != color) {
		CGColorRetain(color);
		CGColorRelease(_color);
		_color = color;
		
		self.line = NULL;
	}
}

- (void) setFontName:(NSString *)fontName
{
	if (![_fontName isEqualToString:fontName]) {
		[fontName retain];
		[_fontName release];
		_fontName = fontName;
		
		self.line = NULL;
	}
}

- (void) setFontSize:(CGFloat)fontSize
{
	if (_fontSize != fontSize) {
		_fontSize = fontSize;
		
		self.line = NULL;
	}
}

- (void) setAlignment:(S2TextAlignment)alignment
{
	if (_alignment != alignment) {
		_alignment = alignment;
		
		self.line = NULL;
	}
}

- (void) setLine:(CTLineRef)line
{
	if (_line != line) {
		CFRetain(line);
		CFRelease(_line);
		_line = line;
	}
}

- (CTLineRef) line
{
	if (!_line) {
		CTFontRef font = CTFontCreateWithName(CFStringCreateWithNSString(_fontName), _fontSize, NULL);
		CGColorRef color = _color;
		// Create attributes
		CFStringRef keys[] = {kCTFontAttributeName, kCTForegroundColorAttributeName};
		CFTypeRef values[] = {font, color};
		CFDictionaryRef attrs = CFDictionaryCreateWithKeysAndValues(keys, values);
		
		CFStringRef text = CFStringCreateWithNSString(_text);
		CFAttributedStringRef string = CFAttributedStringCreate(NULL, text, attrs);
		
		_line = CTLineCreateWithAttributedString(string);
		
		CFRelease(string);
		CFRelease(text);
		
		CFRelease(attrs);
		CFRelease(font);
		
		// set bounds to fit the line
		if (CGRectEqualToRect(_bounds, CGRectZero)) {
			CGRect rect = CTLineGetBoundsWithOptions(_line, kCTLineBoundsIncludeLanguageExtents);
			CGFloat w = rect.size.width - rect.origin.x;
			CGFloat h = rect.size.height - rect.origin.y;
			self.bounds = CGRectMake(0.0f, 0.0f, w, h);
		}
	}
	return _line;
}

- (void) drawInContext:(CGContextRef)ctx
{
	[super drawInContext:ctx];
	
	CGRect bounds = self.bounds;
	CTLineRef line = self.line;
	
	CGContextSaveGState(ctx);
	CGContextConcatCTM(ctx, [self nodeToStageTransform]);
	
	// affine transform matrix for rotated text
	CGAffineTransform atm = CGAffineTransformIdentity;
	atm = CGAffineTransformTranslate(atm, 0.0f, bounds.size.height);
	atm = CGAffineTransformScale(atm, 1.0f, -1.0f);
	
	// 1. transform the matrix of current context for drawing texture
	CGContextConcatCTM(ctx, atm);
	
	// 2. drawing text
	CGFloat dx = bounds.origin.x;
	CGFloat dy = bounds.origin.y;
	CGRect rect = CTLineGetBoundsWithOptions(line, kCTLineBoundsIncludeLanguageExtents);
	if (!CGRectEqualToRect(rect, bounds)) {
		if (_alignment == S2TextAlignmentCenter) {
			dx += (bounds.size.width - rect.size.width) * 0.5f;
		} else if (_alignment == S2TextAlignmentRight) {
			dx += bounds.size.width - rect.size.width;
		}
		dy += (bounds.size.height - rect.size.height) * 0.5f;
		// considering origin point
		dx -= rect.origin.x;
		dy -= rect.origin.y;
	}
	CGContextSetTextPosition(ctx, dx, dy);
	CTLineDraw(line, ctx);
	
	// 3. restore the matrix of current context
	CGContextConcatCTM(ctx, CGAffineTransformInvert(atm));
	
	CGContextRestoreGState(ctx);
}

@end
