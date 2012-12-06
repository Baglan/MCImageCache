//
//  CoffeeImageCache.m
//  Coffee
//
//  Created by Baglan on 11/4/12.
//
//

#import "MCImageCache.h"

@interface MCImageCache () {
    NSMutableDictionary * _cache;
}

@end

@implementation MCImageCache

#pragma mark -
#pragma mark Initialization

// Singleton
// Taken from http://lukeredpath.co.uk/blog/a-note-on-objective-c-singletons.html
+ (MCImageCache *)sharedInstance
{
    __strong static id _sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

+ (UIImage *)renderImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(image.size);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    [image drawInRect:rect];
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderedImage;
}

- (id)init
{
    self = [super init];
    if (self) {
        _cache = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark -
#pragma mark Blocks

- (void)prerenderAndCacheImageForName:(NSString *)name completion:(MCImageCacheCompletionBlock)block;
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("CoffeeImageCache -prerenderAndCacheImageForName:completion:", NULL);
    
    dispatch_async(downloadQueue, ^(void) {
        UIImage * image = [UIImage imageNamed:name];
        UIImage * renderedImage = [self.class renderImage:image];
        [_cache setObject:renderedImage forKey:name];
        dispatch_async(dispatch_get_main_queue(), block);
    });
}

+ (void)prerenderAndCacheImageForName:(NSString *)name completion:(MCImageCacheCompletionBlock)block
{
    [[self sharedInstance] prerenderAndCacheImageForName:name completion:block];
}

- (void)prerenderAndCacheImagesForNamesInArray:(NSArray *)names completion:(MCImageCacheCompletionBlock)block;
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("CoffeeImageCache -prerenderAndCacheImagesForNamesInArray:completion:", NULL);
    
    dispatch_async(downloadQueue, ^(void) {
        [names enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIImage * image = [UIImage imageNamed:obj];
            UIImage * renderedImage = [self.class renderImage:image];
            [_cache setObject:renderedImage forKey:obj];
        }];
        dispatch_async(dispatch_get_main_queue(), block);
    });
}

+ (void)prerenderAndCacheImagesForNamesInArray:(NSArray *)names completion:(MCImageCacheCompletionBlock)block
{
    [[self sharedInstance] prerenderAndCacheImagesForNamesInArray:names completion:block];
}

+ (void)prerenderAndCacheImagesForNamesInSet:(NSSet *)names completion:(MCImageCacheCompletionBlock)block
{
    [[self sharedInstance] prerenderAndCacheImagesForNamesInArray:[names allObjects] completion:block];
}

#pragma mark -
#pragma mark Notifications

- (void)prerenderAndCacheImageWithNotificationsForName:(NSString *)name
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("CoffeeImageCache -prerenderAndCacheImageWithNotificationsForName:", NULL);
    
    dispatch_async(downloadQueue, ^(void) {
        UIImage * image = [UIImage imageNamed:name];
        UIImage * renderedImage = [self.class renderImage:image];
        [_cache setObject:renderedImage forKey:name];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:COFFEEIMAGECACHE_IMAGE_READY_NOTIFICATION object:name];
        });
    });
}

+ (void)prerenderAndCacheImageWithNotificationsForName:(NSString *)name
{
    [[self sharedInstance] prerenderAndCacheImageWithNotificationsForName:name];
}

- (void)prerenderAndCacheImagesWithNotificationsForNamesInArray:(NSArray *)names
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("CoffeeImageCache -prerenderAndCacheImagesWithNotificationsForNames:", NULL);
    
    dispatch_async(downloadQueue, ^(void) {
        [names enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString * imageName = obj;
            UIImage * image = [UIImage imageNamed:imageName];
            UIImage * renderedImage = [self.class renderImage:image];
            [_cache setObject:renderedImage forKey:imageName];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:COFFEEIMAGECACHE_IMAGE_READY_NOTIFICATION object:imageName];
            });
        }];
    });
}

+ (void)prerenderAndCacheImagesWithNotificationsForNamesInArray:(NSArray *)names
{
    [[self sharedInstance] prerenderAndCacheImagesWithNotificationsForNamesInArray:names];
}

+ (void)prerenderAndCacheImagesWithNotificationsForNamesInSet:(NSSet *)names
{
    [[self sharedInstance] prerenderAndCacheImagesWithNotificationsForNamesInArray:[names allObjects]];
}

#pragma mark -
#pragma mark Getters

- (UIImage *)imageForName:(id)name
{
    return [_cache objectForKey:name];
}

+ (UIImage *)imageForName:(id)name
{
    return [[self sharedInstance] imageForName:name];
}

@end
