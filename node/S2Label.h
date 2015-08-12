//
//  S2Label.h
//  SnowCat2D
//
//  Created by Moky on 15-8-4.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2Node.h"

typedef NS_ENUM(NSUInteger, S2TextAlignment) {
	S2TextAlignmentLeft   = 0,
	S2TextAlignmentCenter = 1,
	S2TextAlignmentRight  = 2,
};

typedef NS_ENUM(NSUInteger, S2TextVerticalAlignment) {
	S2TextAlignmentTop   = 0,
	S2TextAlignmentMiddle = 1,
	S2TextAlignmentBottom = 2,
};

@interface S2Label : S2Node {
	
	NSString * _text;
	NSArray * _lines;
	
	CGColorRef _color;
	NSString * _fontName;
	CGFloat _fontSize;
	
	CGFloat _paddingLeft;
	CGFloat _paddingTop;
	CGFloat _paddingRight;
	CGFloat _paddingBottom;
	
	CGFloat _leading;
	
	S2TextAlignment _alignment;
	S2TextVerticalAlignment _verticalAlignment;
}

@property(nonatomic, retain) NSString * text;

@property(nonatomic, readwrite) CGColorRef color;
@property(nonatomic, retain) NSString * fontName;
@property(nonatomic, readwrite) CGFloat fontSize;

@property(nonatomic, readwrite) CGFloat padding;
@property(nonatomic, readwrite) CGFloat paddingLeft;
@property(nonatomic, readwrite) CGFloat paddingTop;
@property(nonatomic, readwrite) CGFloat paddingRight;
@property(nonatomic, readwrite) CGFloat paddingBottom;

@property(nonatomic, readwrite) CGFloat leading; // row spacing

@property(nonatomic, readwrite) S2TextAlignment alignment; // default is Center
@property(nonatomic, readwrite) S2TextVerticalAlignment verticalAlignment; // default is Middle

@end
