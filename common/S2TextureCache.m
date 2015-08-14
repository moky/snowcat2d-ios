//
//  S2TextureCache.m
//  SnowCat2D
//
//  Created by Moky on 15-8-7.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "s2Macros.h"
#import "S2Log.h"
#import "S2Image.h"
#import "S2Texture.h"
#import "S2TextureCache.h"

@interface S2TextureCache ()

@property(nonatomic, retain) NSMutableDictionary * pool;

@end

@implementation S2TextureCache

@synthesize pool = _pool;

- (void) dealloc
{
	self.pool = nil;
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.pool = [NSMutableDictionary dictionaryWithCapacity:64];
	}
	return self;
}

S2_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)

+ (void) purgeSharedTextureCache
{
	[s_singleton_instance release];
	s_singleton_instance = nil;
}

- (S2Texture *) addImage:(NSString *)filename
{
	if (!filename) {
		NSAssert(false, @"texture name cannot be nil");
		return nil;
	}
	S2Texture * texture = nil;
	@synchronized(_pool) {
		texture = [_pool objectForKey:filename];
		if (texture) {
			// 1. got from pool
			[texture retain]; // retainCount += 1
		} else {
			// 2. create new one
			UIImage * image = [S2Image imageNamed:filename];
			if (image) {
				texture = [[S2Texture alloc] initWithUIImage:image]; // retainCount = 1
				[_pool setObject:texture forKey:filename];
			}
		}
	}
	NSAssert([texture isKindOfClass:[S2Texture class]], @"failed to get texture: %@", filename);
	return [texture autorelease];
}

- (S2Texture *) addCGImage:(CGImageRef)imageRef forKey:(NSString *)key
{
	NSAssert(imageRef && key, @"parameters error");
	if (!key) {
		return nil;
	}
	S2Texture * texture = nil;
	@synchronized(_pool) {
		texture = [_pool objectForKey:key];
		if (texture) {
			[texture retain]; // retainCount += 1
		} else {
			texture = [[S2Texture alloc] initWithCGImage:imageRef]; // retainCount = 1
			[_pool setObject:texture forKey:key];
		}
	}
	NSAssert([texture isKindOfClass:[S2Texture class]], @"failed to add CGIImage");
	return [texture autorelease];
}

- (S2Texture *) textureForKey:(NSString *)key
{
	@synchronized(_pool) {
		S2Texture * texture = [_pool objectForKey:key];
		if (texture) {
			return [[texture retain] autorelease];
		}
	}
	return nil;
}

- (void) removeTexture:(S2Texture *)texture
{
	@synchronized(_pool) {
		NSArray * keys = [_pool allKeysForObject:texture];
		NSAssert([keys count] > 0, @"no cache found for texture: %@", texture);
		[_pool removeObjectsForKeys:keys];
	}
}

- (void) removeTextureForKey:(NSString *)key
{
	@synchronized(_pool) {
		NSAssert([_pool objectForKey:key], @"no cache found for key: %@", key);
		[_pool removeObjectForKey:key];
	}
}

- (void) removeAllTextures
{
	@synchronized(_pool) {
		[_pool removeAllObjects];
	}
}

- (void) removeUnusedTextures;
{
	@synchronized(_pool) {
		NSUInteger total = [_pool count], count = 0;
		if (total == 0) {
			S2Log(@"texture cache is empty");
			return ;
		}
		
		NSMutableArray * keysToRemove = [[NSMutableArray alloc] initWithCapacity:total];
		
		NSString * key;
		id object;
		S2_FOR_EACH_KEY_VALUE(key, object, _pool) {
			if ([object retainCount] == 1) {
				S2Log(@"removing unused texture: %@", key);
				[keysToRemove addObject:key];
				++count;
			}
		}
		[_pool removeObjectsForKeys:keysToRemove];
		
		[keysToRemove release];
		
		S2Log(@"removed %u / %u item(s) in texture cache",
			  (unsigned int)count, (unsigned int)total);
	}
}

@end
