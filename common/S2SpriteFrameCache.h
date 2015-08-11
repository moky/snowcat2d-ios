//
//  S2SpriteFrameCache.h
//  SnowCat2D
//
//  Created by Moky on 15-8-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class S2Texture;
@class S2SpriteFrame;

@interface S2SpriteFrameCache : NSObject

+ (instancetype) getInstance;

/** Purges the cache. It releases all the Sprite Frames and the retained instance.
 */
+ (void) purgeSharedSpriteFrameCache;

/** Adds multiple Sprite Frames with a dictionary. The texture will be associated with the created sprite frames.
 */
- (void) addSpriteFramesWithDictionary:(NSDictionary *)dictionary texture:(S2Texture *)texture;

/** Adds multiple Sprite Frames from a plist file.
 * A texture will be loaded automatically. The texture name will composed by replacing the .plist suffix with .png
 * If you want to use another texture, you should use the addSpriteFramesWithFile:texture method.
 */
- (void) addSpriteFramesWithFile:(NSString *)plist;

/** Adds multiple Sprite Frames from a plist file. The texture will be associated with the created sprite frames.
 */
- (void) addSpriteFramesWithFile:(NSString *)plist texture:(S2Texture *)texture;

/** Adds multiple Sprite Frames from a plist file. The texture will be associated with the created sprite frames.
 */
- (void) addSpriteFramesWithFile:(NSString *)plist textureFile:(NSString *)textureFileName;

/** Adds an sprite frame with a given name.
 If the name already exists, then the contents of the old name will be replaced with the new one.
 */
- (void) addSpriteFrame:(S2SpriteFrame *)frame name:(NSString*)frameName;


/** Purges the dictionary of loaded sprite frames.
 * Call this method if you receive the "Memory Warning".
 * In the short term: it will free some resources preventing your app from being killed.
 * In the medium term: it will allocate more resources.
 * In the long term: it will be the same.
 */
- (void) removeSpriteFrames;

/** Removes unused sprite frames.
 * Sprite Frames that have a retain count of 1 will be deleted.
 * It is convinient to call this method after when starting a new Scene.
 */
- (void) removeUnusedSpriteFrames;

/** Deletes an sprite frame from the sprite frame cache.
 */
- (void) removeSpriteFrameByName:(NSString *)name;

/** Removes multiple Sprite Frames from a plist file.
 * Sprite Frames stored in this file will be removed.
 * It is convinient to call this method when a specific texture needs to be removed.
 */
- (void) removeSpriteFramesFromFile:(NSString *)plist;

/** Removes multiple Sprite Frames from NSDictionary.
 */
- (void) removeSpriteFramesFromDictionary:(NSDictionary *)dictionary;

/** Removes all Sprite Frames associated with the specified textures.
 * It is convinient to call this method when a specific texture needs to be removed.
 */
- (void) removeSpriteFramesFromTexture:(S2Texture *)texture;

/** Returns an Sprite Frame that was previously added.
 If the name is not found it will return nil.
 You should retain the returned copy if you are going to use it.
 */
- (S2SpriteFrame *) spriteFrameByName:(NSString *)name;

@end
