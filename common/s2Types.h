//
//  s2Types.h
//  SnowCat2D
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#ifndef SnowCat2D_s2Types_h
#define SnowCat2D_s2Types_h

typedef unsigned char s2Byte;

typedef struct _s2Color3B {
	s2Byte r;
	s2Byte g;
	s2Byte b;
} s2Color3B;

typedef struct _s2Color4B {
	s2Byte r;
	s2Byte g;
	s2Byte b;
	s2Byte a;
} s2Color4B;

typedef struct _s2Color4F {
	float r;
	float g;
	float b;
	float a;
} s2Color4F;

#endif
