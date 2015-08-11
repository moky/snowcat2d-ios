//
//  S2FiniteTimeAction.h
//  SnowCat2D
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2Action.h"

/** Base class actions that do have a finite time duration.
 Possible actions:
 - An action with a duration of 0 seconds
 - An action with a duration of 35.5 seconds
 Infitite time actions are valid
 */
@interface S2FiniteTimeAction : S2Action {
	
	//! duration in seconds
	s2Time _duration;
}

//! duration in seconds of the action
@property(nonatomic, readwrite) s2Time duration;

/** returns a reversed action */
- (S2FiniteTimeAction *) reverse;

@end
