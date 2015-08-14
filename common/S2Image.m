//
//  S2Image.m
//  SnowCat2D
//
//  Created by Moky on 15-8-7.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S2Image.h"

@implementation S2Image

+ (UIImage *) imageNamed:(NSString *)name
{
	NSAssert([name length] > 0, @"error image name: %@", name);
	if ([name rangeOfString:@"/"].location == NSNotFound) {
		return [UIImage imageNamed:name];
	}
	if ([name rangeOfString:@"://"].location == NSNotFound &&
		![name hasPrefix:@"file://"]) {
		return [UIImage imageWithContentsOfFile:name];
	}
	NSURL * url = [NSURL URLWithString:name];
	NSData * data = [NSData dataWithContentsOfURL:url];
	NSAssert(data, @"failed to get data from: %@", name);
	return [UIImage imageWithData:data];
}

@end
