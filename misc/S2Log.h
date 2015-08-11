//
//  S2Log.h
//  SnowCat2D
//
//  Created by Moky on 15-7-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#ifndef SnowCat2D_S2Log_h
#define SnowCat2D_S2Log_h

#import "s2Macros.h"

//{
//	char * str = path;
//	if (str) {
//		str = strrchr(path, '/');
//		if (str) {
//			str += 1;
//		} else {
//			str = strrchr(path, '\\');
//			if (str) {
//				str += 1;
//			} else {
//				str = path;
//			}
//		}
//	}
//	return str;
//}
#define S2FilenameFromString(czPath) ({                                        \
    const char * path = czPath; /* avoid multi-accessing */                    \
    const char * str = path;                                                   \
    if (str) {                                                                 \
        str = strrchr(path, '/');                                              \
        if (str) {                                                             \
            str += 1; /* skip '/' */                                           \
        } else {                                                               \
            str = strrchr(path, '\\');                                         \
            if (str) {                                                         \
                str += 1; /* skip '\' */                                       \
            } else {                                                           \
                str = path; /* the whole string */                             \
            }                                                                  \
        }                                                                      \
    }                                                                          \
    str;})                                                                     \
                                                /* EOF 'S2FilenameFromString' */

#ifdef S2_DEBUG
#	define S2Log(...)                                                          \
        printf("<%s:%d>%s %s\r\n", S2FilenameFromString(__FILE__), __LINE__,   \
            __FUNCTION__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#	define S2Log(...)   do {} while(0)
#endif

#endif
