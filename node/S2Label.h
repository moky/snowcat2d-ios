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

@interface S2Label : S2Node {
	
	NSString * _text;
	CGColorRef _color;
	
	NSString * _fontName;
	CGFloat _fontSize;
	
	S2TextAlignment _alignment;
}

@property(nonatomic, retain) NSString * text;
@property(nonatomic, readwrite) CGColorRef color;

@property(nonatomic, retain) NSString * fontName;
@property(nonatomic, readwrite) CGFloat fontSize;

@property(nonatomic, readwrite) S2TextAlignment alignment;

@end
