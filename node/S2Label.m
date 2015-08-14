
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
@property(nonatomic, readwrite) CGRect bounds;

/* designated initializer */
- (instancetype) initWithCTLine:(CTLineRef)line bounds:(CGRect)bounds;

@end

@implementation S2LabelLine

@synthesize line = _line;
@synthesize bounds = _bounds;

- (void) dealloc
{
	self.line = nil;
	[super dealloc];
}

/* designated initializer */
- (instancetype) initWithCTLine:(CTLineRef)line bounds:(CGRect)bounds
{
	self = [super init];
	if (self) {
		self.line = line;
		self.bounds = bounds;
	}
	return self;
}

- (instancetype) init
{
	return [self initWithCTLine:nil bounds:CGRectZero];
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

@property(nonatomic, readwrite) CTLineRef truncationToken;

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

@synthesize truncationToken = _truncationToken;

- (void) dealloc
{
	self.text = nil;
	
	self.color = NULL;
	self.fontName = nil;
	
	self.lines = nil;
	
	self.truncationToken = NULL;
	
	[super dealloc];
}

/* designated initializer */
- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
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
		
		self.truncationToken = NULL;
	}
	return self;
}

- (instancetype) initWithText:(NSString *)text
{
	self = [self initWithFrame:CGRectZero];
	if (self) {
		self.text = text;
	}
	return self;
}

+ (instancetype) labelWithText:(NSString *)text
{
	return [[[self alloc] initWithText:text] autorelease];
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
		CGRect lineBounds = CGRectZero;
		
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
		
		if (!_truncationToken) {
			text = CFStringCreateWithNSString(@"...");
			aStr = CFAttributedStringCreate(NULL, text, attrs);
			_truncationToken = CTLineCreateWithAttributedString(aStr);
			CFRelease(aStr);
			CFRelease(text);
		}
		
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
			
			lineBounds = CTLineGetBounds(line);
			textSize = CGSizeMake(MAX(textSize.width, lineBounds.size.width + lineBounds.origin.x),
								  textSize.height + lineBounds.size.height + lineBounds.origin.y);
			
			label = [[S2LabelLine alloc] initWithCTLine:line bounds:lineBounds];
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
		
		textSize.height += _leading * (count - 1);
		if (CGRectEqualToRect(_bounds, CGRectZero)) {
			self.size = CGSizeMake(_paddingLeft + textSize.width + _paddingRight,
								   _paddingTop + textSize.height + _paddingBottom);
		}
		self.textSize = textSize;
	}
	return _lines;
}

- (void) setTruncationToken:(CTLineRef)truncationToken
{
	if (_truncationToken != truncationToken) {
		CFRetainSafe(truncationToken);
		CFReleaseSafe(_truncationToken);
		_truncationToken = truncationToken;
	}
}

- (void) drawInContext:(CGContextRef)ctx
{
	[super drawInContext:ctx];
	
	NSArray * lines = self.lines;
	
	CGRect bounds = self.bounds;
	
	//
	//  DRAWING
	//
	
	// affine transform matrix for rotated text
	CGAffineTransform atm = CGAffineTransformIdentity;
	atm = CGAffineTransformTranslate(atm, bounds.origin.x, bounds.origin.y + bounds.size.height);
	atm = CGAffineTransformScale(atm, 1.0f, -1.0f);
	
	// 1. transform the matrix of current context for drawing texture
	CGContextConcatCTM(ctx, atm);
	
	// 2. drawing text
	CGPoint position = CGPointZero;
	if (_verticalAlignment == S2TextAlignmentTop) {
		position.y = bounds.size.height - _paddingTop;
	} else if (_verticalAlignment == S2TextAlignmentBottom) {
		position.y = _textSize.height + _paddingBottom;
	} else {
		position.y = bounds.size.height * 0.5f + _textSize.height * 0.5f;
	}
	
	CTLineRef tLine = NULL;
	S2LabelLine * label;
	S2_FOR_EACH(label, lines) {
		position.y -= label.bounds.size.height;
		if (position.y < _paddingBottom || position.y > (bounds.size.height - _paddingTop)) {
			// skip this line
			position.y -= label.bounds.origin.y + _leading;
			continue;
		}
		
		position.x = bounds.origin.x + _paddingLeft + label.bounds.origin.x;
		if (_alignment == S2TextAlignmentCenter) {
			position.x = (bounds.origin.x + bounds.size.width - label.bounds.size.width - label.bounds.origin.x) * 0.5f;
		} else if (_alignment == S2TextAlignmentRight) {
			position.x = bounds.origin.x + bounds.size.width - _paddingRight - label.bounds.size.width;
		}
		
		if ((label.bounds.origin.x + label.bounds.size.width) < (bounds.size.width - _paddingLeft - _paddingRight)) {
			tLine = NULL;
		} else {
			// is the line too long?
			CTLineTruncationType type = kCTLineTruncationMiddle;
			if (_alignment == S2TextAlignmentLeft) {
				type = kCTLineTruncationEnd;
			} else if (_alignment == S2TextAlignmentRight) {
				type = kCTLineTruncationStart;
			}
			tLine = CTLineCreateTruncatedLine(label.line,
											  bounds.size.width - _paddingLeft - _paddingRight,
											  type,
											  _truncationToken);
			if (tLine) {
				CGRect b = CTLineGetBounds(tLine);
				if (_alignment == S2TextAlignmentCenter) {
					position.x = (bounds.origin.x + bounds.size.width - b.size.width - b.origin.x) * 0.5f;
				} else if (_alignment == S2TextAlignmentRight) {
					position.x = bounds.origin.x + bounds.size.width - _paddingRight - b.size.width;
				}
			}
		}
		CGContextSetTextPosition(ctx, position.x, position.y);
		
		if (tLine) {
			CTLineDraw(tLine, ctx);
			CFRelease(tLine);
		} else {
			CTLineDraw(label.line, ctx);
		}
		
		position.y -= label.bounds.origin.y + _leading;
	}
	
	// 3. restore the matrix of current context
	CGContextConcatCTM(ctx, CGAffineTransformInvert(atm));
}

@end
