//
//  S2ActionInterval+Visibility.h
//  SnowCat2D
//
//  Created by Moky on 15-8-3.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2ActionInterval.h"

/** Blinks a Node object by modifying it's visible attribute
 */
@interface S2Blink : S2ActionInterval {
	
	NSUInteger _times;
}

- (instancetype) initWithDuration:(s2Time)duration blinks:(NSUInteger)blinks;
+ (instancetype) actionWithDuration:(s2Time)duration blinks:(NSUInteger)blinks;

@end

#pragma mark Fade

/** Fades In an object that implements the RGBA protocol. It modifies the opacity from 0 to 255.
 The "reverse" of this action is FadeOut
 */
@interface S2FadeIn : S2ActionInterval

@end

/** Fades Out an object that implements the RGBA protocol. It modifies the opacity from 255 to 0.
 The "reverse" of this action is FadeIn
 */
@interface S2FadeOut : S2ActionInterval

@end

/** Fades an object that implements the RGBA protocol. It modifies the opacity from the current value to a custom one.
 @warning This action doesn't support "reverse"
 */
@interface S2FadeTo : S2ActionInterval {
	
	s2Byte _fromOpacity;
	s2Byte _toOpacity;
}

- (instancetype) initWithDuration:(s2Time)duration opacity:(s2Byte)opacity;
+ (instancetype) actionWithDuration:(s2Time)duration opacity:(s2Byte)opacity;

@end

#pragma mark Tint

/** Tints a Node that implements the RGB protocol from current tint to a custom one.
 @warning This action doesn't support "reverse"
 */
@interface S2TintTo : S2ActionInterval {
	
	s2Color3B _fromColor;
	s2Color3B _toColor;
	s2Color3B _delta;
}

- (instancetype) initWithDuration:(s2Time)duration red:(s2Byte)r green:(s2Byte)g blue:(s2Byte)b;
+ (instancetype) actionWithDuration:(s2Time)duration red:(s2Byte)r green:(s2Byte)g blue:(s2Byte)b;

@end

/** Tints a Node that implements the RGB protocol from current tint to a custom one.
 */
@interface S2TintBy : S2TintTo

@end
