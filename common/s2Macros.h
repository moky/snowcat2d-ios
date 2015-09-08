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

#define s2_sleep(seconds)                             s9_sleep(seconds)
#define s2_difftime(time1, time2)                     s9_difftime((time1), (time2))

#define S2Log(...)                                    S9Log(__VA_ARGS__)

#define S2_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance) S9_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)

// foreach
#define S2_FOR_EACH(array, item)                      S9_FOR_EACH((array), (item))
#define S2_FOR_EACH_REVERSE(array, item)              S9_FOR_EACH_REVERSE((array), (item))
#define S2_FOR_EACH_SAFE(array, item)                 S9_FOR_EACH_SAFE((array), (item))
#define S2_FOR_EACH_REVERSE_SAFE(array, item)         S9_FOR_EACH_REVERSE_SAFE((array), (item))
#define S2_FOR_EACH_KEY_VALUE(dict, key, value)       S9_FOR_EACH_KEY_VALUE((dict), (key), (value))

#endif
