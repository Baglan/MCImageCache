//
//  MCImageCache.h
//  MCImageCache
//
//  Created by Baglan on 12/6/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COFFEEIMAGECACHE_IMAGE_READY_NOTIFICATION   @"MCImageCacheImageReadyNotification"

typedef void (^ MCImageCacheCompletionBlock)();

@interface MCImageCache : NSObject

+ (void)prerenderAndCacheImageForName:(NSString *)name completion:(MCImageCacheCompletionBlock)block;
+ (void)prerenderAndCacheImagesForNamesInSet:(NSSet *)names completion:(MCImageCacheCompletionBlock)block;
+ (void)prerenderAndCacheImagesForNamesInArray:(NSArray *)names completion:(MCImageCacheCompletionBlock)block;

+ (void)prerenderAndCacheImageWithNotificationsForName:(NSString *)names;
+ (void)prerenderAndCacheImagesWithNotificationsForNamesInSet:(NSSet *)names;
+ (void)prerenderAndCacheImagesWithNotificationsForNamesInArray:(NSArray *)names;

+ (UIImage *)imageForName:(id)name;

@end
