//
//  s2Macros.h
//  SnowCat2D
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#ifndef SnowCat2D_s2Macros_h
#define SnowCat2D_s2Macros_h


#ifdef NDEBUG
#elif DEBUG
#define S2_DEBUG
#endif


#define s2sleep(seconds) usleep((seconds) * 1000000)
#define s2difftime(timeval2, timeval1) (((timeval2).tv_sec - (timeval1).tv_sec) + ((timeval2).tv_usec - (timeval1).tv_usec) / 1000000.0f)

#define CGImageCreateCopyWithImageInRect(imageRef, rect)                       \
    ({                                                                         \
        CGImageRef __ref = (imageRef);                                         \
        CGRect __rect = (rect);                                                \
        __ref = CGImageCreateWithImageInRect(__ref, __rect);                   \
        UIImage * __img = [UIImage imageWithCGImage:__ref];                    \
        CGImageRelease(__ref);                                                 \
        __rect.origin = CGPointZero;                                           \
        UIGraphicsBeginImageContext(__rect.size);                              \
        [__img drawInRect:__rect];                                             \
        __img = UIGraphicsGetImageFromCurrentImageContext();                   \
        UIGraphicsEndImageContext();                                           \
        CGImageRetain(__img.CGImage);                                          \
    })                                                                         \
                                    /* EOF 'CGImageCreateCopyWithImageInRect' */

#define CTLineGetSize(line)                                                    \
    ({                                                                         \
        CGFloat __a, __d, __l;                                                 \
        double __w = CTLineGetTypographicBounds((line), &__a, &__d, &__l);     \
        CGSizeMake(__w, __a + __d + __l);                                      \
    })                                                                         \
                                                       /* EOF 'CTLineGetSize' */

//------------------------------------------------------------------------- safe
#define CFRetainSafe(ref)  if (ref) CFRetain(ref)
#define CFReleaseSafe(ref) if (ref) CFRelease(ref)


//--------------------------------------------------------------------- for each
#define S2_FOR_EACH(item, array)                                               \
    for (NSEnumerator * __e = [(array) objectEnumerator];                      \
         ((item) = [__e nextObject]); )                                        \
                                                         /* EOF 'S2_FOR_EACH' */

#define S2_FOR_EACH_SAFE(item, array)                                          \
    for (NSUInteger __i = 0;                                                   \
         (__i < [(array) count]) && ((item) = [(array) objectAtIndex:__i]);    \
         ++__i)                                                                \
                                                    /* EOF 'S2_FOR_EACH_SAFE' */

#define S2_FOR_EACH_REVERSE(item, array)                                       \
    for (NSEnumerator * __e = [(array) reverseObjectEnumerator];               \
         ((item) = [__e nextObject]); )                                        \
                                                 /* EOF 'S2_FOR_EACH_REVERSE' */

#define S2_FOR_EACH_REVERSE_SAFE(item, array)                                  \
    for (NSInteger __i = [(array) count] - 1;                                  \
         (__i>=0 && __i<[(array) count])&&((item)=[(array) objectAtIndex:__i]);\
         --__i)                                                                \
                                            /* EOF 'S2_FOR_EACH_REVERSE_SAFE' */

#define S2_FOR_EACH_KEY_VALUE(key, value, dict)                                \
    for (NSEnumerator * __e = [(dict) keyEnumerator];                          \
         ((key)=[__e nextObject]) && ((value)=[(dict) objectForKey:(key)]); )  \
                                               /* EOF 'S2_FOR_EACH_KEY_VALUE' */

//-------------------------------------------------------------------- singleton
#define S2_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)                          \
    static id s_singleton_instance = nil;                                      \
    + (instancetype) getInstance                                               \
    {                                                                          \
        @synchronized(self) {                                                  \
            if (!s_singleton_instance) {                                       \
                [self new]; /* alloc & init */                                 \
            }                                                                  \
        }                                                                      \
        return s_singleton_instance;                                           \
    }                                                                          \
    + (instancetype) allocWithZone:(NSZone *)zone                              \
    {                                                                          \
        NSAssert(s_singleton_instance == nil, @"Singleton!");                  \
        @synchronized(self) {                                                  \
            if (!s_singleton_instance) {                                       \
                s_singleton_instance = [super allocWithZone:zone];             \
            }                                                                  \
        }                                                                      \
        return s_singleton_instance;                                           \
    }                                                                          \
    - (id) copy { return self; }                                               \
    - (id) mutableCopy { return self; }                                        \
    - (instancetype) retain { return self; }                                   \
    - (oneway void) release { /* do nothing */ }                               \
    - (instancetype) autorelease { return self; }                              \
    - (NSUInteger) retainCount { return NSUIntegerMax; }                       \
                                    /* EOF 'S2_IMPLEMENT_SINGLETON_FUNCTIONS' */

//
//  CoreFoundation
//
#define CFStringCreateWithNSString(nsString)                                   \
        CFStringCreateWithCString(NULL,                                        \
                [(nsString) UTF8String],                                       \
                kCFStringEncodingUTF8)                                         \
                                          /* EOF 'CFStringCreateWithNSString' */

#define CFDictionaryCreateWithKeysAndValues(keys, values)                      \
        CFDictionaryCreate(NULL,                                               \
                (const void **)&(keys),                                        \
                (const void **)&(values),                                      \
                sizeof(keys) / sizeof((keys)[0]),                              \
                &kCFTypeDictionaryKeyCallBacks,                                \
                &kCFTypeDictionaryValueCallBacks);                             \
                                 /* EOF 'CFDictionaryCreateWithKeysAndValues' */

#endif
