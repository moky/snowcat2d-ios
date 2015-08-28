//
//  s2Macros.h
//  SnowCat2D
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#ifndef SnowCat2D_s2Macros_h
#define SnowCat2D_s2Macros_h

#import "SlanissueToolkit.h"

#define s2_sleep(seconds)                [S9Time sleep:(seconds)]
#define s2_difftime(time1, time2)        s9_difftime(time1, time2)

#define S2Log                            S9Log

#define S2_IMPLEMENT_SINGLETON_FUNCTIONS S9_IMPLEMENT_SINGLETON_FUNCTIONS

#define S2_FOR_EACH                      S9_FOR_EACH
#define S2_FOR_EACH_SAFE                 S9_FOR_EACH_SAFE
#define S2_FOR_EACH_REVERSE              S9_FOR_EACH_REVERSE
#define S2_FOR_EACH_REVERSE_SAFE         S9_FOR_EACH_REVERSE_SAFE
#define S2_FOR_EACH_KEY_VALUE            S9_FOR_EACH_KEY_VALUE

#endif
