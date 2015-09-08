//
//  S2SpriteFrameCache.m
//  SnowCat2D
//
//  Created by Moky on 15-8-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "s2Macros.h"
#import "S2TextureCache.h"
#import "S2SpriteFrame.h"
#import "S2SpriteFrameCache.h"

@interface S2SpriteFrameCache ()

@property(nonatomic, retain) NSMutableDictionary * pool;
@property(nonatomic, retain) NSMutableDictionary * aliases;

@end

@implementation S2SpriteFrameCache

@synthesize pool = _pool;
@synthesize aliases = _aliases;

- (void) dealloc
{
	self.pool = nil;
	self.aliases = nil;
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.pool = [NSMutableDictionary dictionaryWithCapacity:64];
		self.aliases = [NSMutableDictionary dictionaryWithCapacity:64];
	}
	return self;
}

S2_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)

+ (void) purgeSharedSpriteFrameCache
{
	[s_singleton_instance release];
	s_singleton_instance = nil;
}

- (void) addSpriteFramesWithDictionary:(NSDictionary *)dictionary texture:(S2Texture *)texture
{
	if (!dictionary || !texture) {
		NSAssert(false, @"parameters error: %@, %@", dictionary, texture);
		return;
	}
	/*
	 Supported Zwoptex Formats:
	 ZWTCoordinatesFormatOptionXMLLegacy = 0, // Flash Version
	 ZWTCoordinatesFormatOptionXML1_0 = 1, // Desktop Version 0.0 - 0.4b
	 ZWTCoordinatesFormatOptionXML1_1 = 2, // Desktop Version 1.0.0 - 1.0.1
	 ZWTCoordinatesFormatOptionXML1_2 = 3, // Desktop Version 1.0.2+
	 */
	NSDictionary * metadata = [dictionary objectForKey:@"metadata"];
	NSDictionary * frames = [dictionary objectForKey:@"frames"];
	
	int format = 0;
	
	// get the format
	if (metadata) {
		format = [[metadata objectForKey:@"format"] intValue];
	}
	
	// check the format
	NSAssert(format >= 0 && format <= 3,
			 @"WARNING: format is not supported for SpriteFrameCache addSpriteFramesWithDictionary:texture:");
	
	S2SpriteFrame * spriteFrame;
	
	NSString * frameName;
	NSDictionary * frameDict;
	S2_FOR_EACH_KEY_VALUE(frames, frameName, frameDict) {
		spriteFrame = nil;
		
		if (format == 0)
		{
			float x = [[frameDict objectForKey:@"x"] floatValue];
			float y = [[frameDict objectForKey:@"y"] floatValue];
			float w = [[frameDict objectForKey:@"width"] floatValue];
			float h = [[frameDict objectForKey:@"height"] floatValue];
//			float ox = [[frameDict objectForKey:@"offsetX"] floatValue];
//			float oy = [[frameDict objectForKey:@"offsetY"] floatValue];
//			int ow = [[frameDict objectForKey:@"originalWidth"] intValue];
//			int oh = [[frameDict objectForKey:@"originalHeight"] intValue];
//			// check ow/oh
//			if (!ow || !oh) {
//				S2Log(@"WARNING: originalWidth/Height not found on the SpriteFrame. AnchorPoint won't work as expected. Regenerate the .plist");
//			}
//			
//			// abs ow/oh
//			ow = abs(ow);
//			oh = abs(oh);
			
			CGRect rect = CGRectMake(x, y, w, h);
			
			// create sprite frame
			spriteFrame = [[S2SpriteFrame alloc] initWithTexture:texture
															rect:rect
														 rotated:NO];
		}
		else if (format == 1 || format == 2)
		{
			CGRect frame = CGRectFromString([frameDict objectForKey:@"frame"]);
			BOOL rotated = NO;
			
			// rotated texture
			if (format == 2) {
				rotated = [[frameDict objectForKey:@"rotated"] boolValue];
			}
			
//			CGPoint offset = CGPointFromString([frameDict objectForKey:@"offset"]);
//			CGSize sourceSize = CGSizeFromString([frameDict objectForKey:@"sourceSize"]);
			
			// create frame
			spriteFrame = [[S2SpriteFrame alloc] initWithTexture:texture
															rect:frame
														 rotated:rotated];
		}
		else if (format == 3)
		{
//			CGSize spriteSize = CGSizeFromString([frameDict objectForKey:@"spriteSize"]);
//			CGPoint spriteOffset = CGPointFromString([frameDict objectForKey:@"spriteOffset"]);
//			CGSize spriteSourceSize = CGSizeFromString([frameDict objectForKey:@"spriteSourceSize"]);
			CGRect textureRect = CGRectFromString([frameDict objectForKey:@"textureRect"]);
			BOOL textureRotated = [[frameDict objectForKey:@"textureRotated"] boolValue];
			
			// get aliases
			NSArray * aliases = [frameDict objectForKey:@"aliases"];
			NSString * alias;
			S2_FOR_EACH(aliases, alias) {
				// setObject:frameName forKey:alias
				@synchronized(_aliases) {
					NSAssert(![_aliases objectForKey:alias],
							 @"an alias with name %@ already exists", alias);
					[_aliases setObject:frameName forKey:alias];
				}
			}
			
			// create frame
			spriteFrame = [[S2SpriteFrame alloc] initWithTexture:texture
															rect:textureRect
														 rotated:textureRotated];
		}
		
		[self addSpriteFrame:spriteFrame name:frameName];
		[spriteFrame release];
	}
}

- (void) addSpriteFramesWithFile:(NSString *)plist
{
	NSDictionary * dict = [[NSDictionary alloc] initWithContentsOfFile:plist];
	
	NSDictionary * metadata = [dict objectForKey:@"metadata"];
	NSString * texturePath = [metadata objectForKey:@"textureFileName"];
	
	if (texturePath) {
		NSString * dir = [plist stringByDeletingLastPathComponent];
		texturePath = [dir stringByAppendingPathComponent:texturePath];
	} else {
		NSString * str = [plist stringByDeletingPathExtension];
		texturePath = [str stringByAppendingPathExtension:@"png"];
		S2Log(@"Trying to use file '%@' as texture", texturePath);
	}
	
	S2Texture * texture = [[S2TextureCache getInstance] addImage:texturePath];
	NSAssert(texture, @"Couldn't load texture for: %@", plist);
	[self addSpriteFramesWithDictionary:dict texture:texture];
	
	[dict release];
}

- (void) addSpriteFramesWithFile:(NSString *)plist texture:(S2Texture *)texture
{
	NSDictionary * dict = [[NSDictionary alloc] initWithContentsOfFile:plist];
	[self addSpriteFramesWithDictionary:dict texture:texture];
	[dict release];
}

- (void) addSpriteFramesWithFile:(NSString *)plist textureFile:(NSString *)textureFileName
{
	S2Texture * texture = [[S2TextureCache getInstance] addImage:textureFileName];
	NSAssert(texture, @"Couldn't load texture for: %@, %@", plist, textureFileName);
	[self addSpriteFramesWithFile:plist texture:texture];
}

- (void) addSpriteFrame:(S2SpriteFrame *)frame name:(NSString *)frameName
{
	if (!frame || !frameName) {
		NSAssert(false, @"parameters error: %@, %@", frame, frameName);
		return;
	}
	@synchronized(_pool) {
		[_pool setObject:frame forKey:frameName];
	}
}

- (void) removeSpriteFrames
{
	@synchronized(_pool) {
		[_pool removeAllObjects];
		[_aliases removeAllObjects];
	}
}

- (void) removeUnusedSpriteFrames
{
	@synchronized(_pool) {
		NSUInteger total = [_pool count], count = 0;
		if (total == 0) {
			S2Log(@"sprite frame cache is empty");
			return ;
		}
		
		NSMutableArray * keysToRemove = [[NSMutableArray alloc] initWithCapacity:total];
		
		NSString * key;
		id object;
		S2_FOR_EACH_KEY_VALUE(_pool, key, object) {
			if ([object retainCount] == 1) {
				S2Log(@"removing unused sprite frame: %@", key);
				[keysToRemove addObject:key];
				++count;
			}
		}
		[_pool removeObjectsForKeys:keysToRemove];
		
		[keysToRemove release];
		
		S2Log(@"removed %u / %u item(s) in texture cache", (unsigned int)count, (unsigned int)total);
	}
}

- (void) removeSpriteFrameByName:(NSString *)name
{
	if (!name) {
		NSAssert(false, @"sprite frame name cannot be nil");
		return;
	}
	
	// is this an alias?
	@synchronized(_aliases) {
		NSString * key = [_aliases objectForKey:name];
		if (key) {
			[key retain];
			[_aliases removeObjectForKey:name];
			name = [key autorelease];
		}
	}
	
	@synchronized(_pool) {
		[_pool removeObjectForKey:name];
	}
}

- (void) removeSpriteFramesFromFile:(NSString *)plist
{
	NSDictionary * dict = [[NSDictionary alloc] initWithContentsOfFile:plist];
	[self removeSpriteFramesFromDictionary:dict];
	[dict release];
}

- (void) removeSpriteFramesFromDictionary:(NSDictionary *)dictionary
{
	NSDictionary * frames = [dictionary objectForKey:@"frames"];
	NSArray * keysToRemove = [frames allKeys];
	NSAssert([keysToRemove count] > 0, @"nothing to removed?");
	@synchronized(_pool) {
		[_pool removeObjectsForKeys:keysToRemove];
	}
}

- (void) removeSpriteFramesFromTexture:(S2Texture *)texture
{
	NSMutableArray * keysToRemove = [[NSMutableArray alloc] initWithCapacity:64];
	
	@synchronized(_pool) {
		NSString * frameName;
		S2SpriteFrame * spriteFrame;
		S2_FOR_EACH_KEY_VALUE(_pool, frameName, spriteFrame) {
			if (spriteFrame.texture == texture) {
				[keysToRemove addObject:frameName];
			}
		}
		NSAssert([keysToRemove count] > 0, @"nothing to removed?");
		[_pool removeObjectsForKeys:keysToRemove];
	}
	
	[keysToRemove release];
}

- (S2SpriteFrame *) spriteFrameByName:(NSString *)name
{
	@synchronized(_pool) {
		S2SpriteFrame * frame = [_pool objectForKey:name];
		if (frame) {
			return [[frame retain] autorelease];
		}
		
		// try alias
		@synchronized(_aliases) {
			NSString * key = [_aliases objectForKey:name];
			if (key) {
				frame = [_pool objectForKey:key];
				return [[frame retain] autorelease];
			}
		}
	}
	
	NSAssert(false, @"no sprite frame name: %@", name);
	return nil;
}

@end
