
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

@interface S2LabelLine : NSObject

@property(nonatomic, readwrite) CTLineRef line;
@property(nonatomic, readwrite) CGSize size;

/* designated initializer */
- (instancetype) initWithCTLine:(CTLineRef)line size:(CGSize)size;

@end

@implementation S2LabelLine

@synthesize line = _line;
@synthesize size = _size;

- (void) dealloc
{
	self.line = nil;
	[super dealloc];
}

/* designated initializer */
- (instancetype) initWithCTLine:(CTLineRef)line size:(CGSize)size
{
	self = [super init];
	if (self) {
		self.line = line;
		self.size = size;
	}
	return self;
}

- (instancetype) init
{
	return [self initWithCTLine:nil size:CGSizeZero];
}

- (void) setLine:(CTLineRef)line
{
	if (_line != line) {
		CFRetainSafe(line);
		CFReleaseSafe(_line);
		_line = line;
	}
}

@end

#pragma mark -

@interface S2Label ()

@property(nonatomic, retain) NSArray * lines;
@property(nonatomic, readwrite) CGSize textSize;

@end

@implementation S2Label

@synthesize text = _text;

@synthesize color = _color;
@synthesize fontName = _fontName;
@synthesize fontSize = _fontSize;

@synthesize paddingLeft = _paddingLeft;
@synthesize paddingTop = _paddingTop;
@synthesize paddingRight = _paddingRight;
@synthesize paddingBottom = _paddingBottom;

@synthesize leading = _leading;

@synthesize alignment = _alignment;
@synthesize verticalAlignment = _verticalAlignment;

@synthesize lines = _lines;
@synthesize textSize = _textSize;

- (void) dealloc
{
	self.text = nil;
	
	self.color = nil;
	self.fontName = nil;
	
	self.lines = nil;
	
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
		
		self.padding = 2.0f;
		self.leading = 2.0f;
		
		self.alignment = S2TextAlignmentCenter;
		self.verticalAlignment = S2TextAlignmentMiddle;
		
		self.lines = nil;
		self.textSize = CGSizeZero;
	}
	return self;
}

- (void) setText:(NSString *)text
{
	if (![_text isEqualToString:text]) {
		[text retain];
		[_text release];
		_text = text;
		
		self.lines = nil;
	}
}

- (void) setColor:(CGColorRef)color
{
	if (_color != color) {
		CGColorRetain(color);
		CGColorRelease(_color);
		_color = color;
		
		self.lines = nil;
	}
}

- (void) setFontName:(NSString *)fontName
{
	if (![_fontName isEqualToString:fontName]) {
		[fontName retain];
		[_fontName release];
		_fontName = fontName;
		
		self.lines = nil;
	}
}

- (void) setFontSize:(CGFloat)fontSize
{
	if (_fontSize != fontSize) {
		_fontSize = fontSize;
		
		self.lines = nil;
	}
}

- (void) setPadding:(CGFloat)padding
{
	_paddingLeft = padding;
	_paddingTop = padding;
	_paddingRight = padding;
	_paddingBottom = padding;
}

- (CGFloat) padding
{
	NSAssert(_paddingLeft == _paddingTop &&
			 _paddingTop == _paddingRight &&
			 _paddingRight == _paddingBottom, @"unknown which to return");
	return _paddingLeft;
}

- (NSArray *) lines
{
	if (!_lines) {
		CGSize textSize = CGSizeZero;
		CGSize lineSize = CGSizeZero;
		
		// separate lines
		NSAssert([_text isKindOfClass:[NSString class]], @"text empty");
		NSArray * array = [_text componentsSeparatedByString:@"\n"];
		NSUInteger count = [array count];
		if (count == 0) {
			NSAssert(false, @"lines count = 0");
			return nil;
		}
		NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:count];
		
		// text attributes
		CTFontRef font = CTFontCreateWithName(CFStringCreateWithNSString(_fontName), _fontSize, NULL);
		CGColorRef color = _color;
		CFStringRef keys[] = {kCTFontAttributeName, kCTForegroundColorAttributeName};
		CFTypeRef values[] = {font, color};
		CFDictionaryRef attrs = CFDictionaryCreateWithKeysAndValues(keys, values);
		
		CFStringRef text;
		CFAttributedStringRef aStr;
		CTLineRef line;
		S2LabelLine * label;
		
		NSString * string;
		S2_FOR_EACH(string, array) {
			if ([string isKindOfClass:[S2LabelLine class]]) {
				[mArray addObject:string];
				continue;
			}
			NSAssert([string isKindOfClass:[NSString class]], @"each line must be a string");
			// trim
			
			text = CFStringCreateWithNSString(string);
			aStr = CFAttributedStringCreate(NULL, text, attrs);
			line = CTLineCreateWithAttributedString(aStr);
			
			lineSize = CTLineGetSize(line);
			textSize = CGSizeMake(MAX(textSize.width, lineSize.width), textSize.height + lineSize.height);
			
			label = [[S2LabelLine alloc] initWithCTLine:line size:lineSize];
			[mArray addObject:label];
			[label release];
			
			CFRelease(line);
			CFRelease(aStr);
			CFRelease(text);
		}
		
		self.lines = mArray;

		CFRelease(attrs);
		CFRelease(font);
		
		[mArray release];
		
		if (CGRectEqualToRect(_bounds, CGRectZero)) {
			textSize.height += _leading * (count - 1);
			self.size = CGSizeMake(_paddingLeft + textSize.width + _paddingRight,
								   _paddingTop + textSize.height + _paddingBottom);
		}
		self.textSize = textSize;
	}
	return _lines;
}

- (void) drawInContext:(CGContextRef)ctx
{
	[super drawInContext:ctx];
	
	NSArray * lines = self.lines;
	
	CGRect bounds = self.bounds;
	
	CGContextSaveGState(ctx);
	CGContextConcatCTM(ctx, [self nodeToStageTransform]);
	
	// affine transform matrix for rotated text
	CGAffineTransform atm = CGAffineTransformIdentity;
	atm = CGAffineTransformTranslate(atm, 0.0f, bounds.size.height);
	atm = CGAffineTransformScale(atm, 1.0f, -1.0f);
	
	// 1. transform the matrix of current context for drawing texture
	CGContextConcatCTM(ctx, atm);
	
	// 2. drawing text
	CGFloat dx, dy;
	if (_verticalAlignment == S2TextAlignmentTop) {
		dy = bounds.size.height - _paddingTop;
	} else if (_verticalAlignment == S2TextAlignmentBottom) {
		dy = _textSize.height + _paddingBottom;
	} else {
		NSAssert(_verticalAlignment == S2TextAlignmentMiddle, @"default alignment middle");
		dy = bounds.size.height * 0.5f + _textSize.height * 0.5f;
	}
	
	S2LabelLine * label;
	if (_alignment == S2TextAlignmentLeft) {
		dx = _paddingLeft;
		S2_FOR_EACH(label, lines) {
			dy -= label.size.height;
			CGContextSetTextPosition(ctx, dx, dy);
			CTLineDraw(label.line, ctx);
			dy -= _leading;
		}
	} else if (_alignment == S2TextAlignmentRight) {
		S2_FOR_EACH(label, lines) {
			dx = bounds.size.width - _paddingRight - label.size.width;
			dy -= label.size.height;
			CGContextSetTextPosition(ctx, dx, dy);
			CTLineDraw(label.line, ctx);
			dy -= _leading;
		}
	} else {
		NSAssert(_alignment == S2TextAlignmentCenter, @"default alignment center");
		S2_FOR_EACH(label, lines) {
			dx = (bounds.size.width - label.size.width) * 0.5f;
			dy -= label.size.height;
			CGContextSetTextPosition(ctx, dx, dy);
			CTLineDraw(label.line, ctx);
			dy -= _leading;
		}
	}
	
	// 3. restore the matrix of current context
	CGContextConcatCTM(ctx, CGAffineTransformInvert(atm));
	
	CGContextRestoreGState(ctx);
}

@end
