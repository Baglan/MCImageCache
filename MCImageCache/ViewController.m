//
//  ViewController.m
//  MCImageCache
//
//  Created by Baglan on 12/6/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
//

#import "ViewController.h"
#import "MCImageCache.h"

#define LARGE_IMAGE_NAME    @"large-image"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [MCImageCache prerenderAndCacheImageForName:LARGE_IMAGE_NAME completion:^{
        _imageView.image = [MCImageCache imageForName:LARGE_IMAGE_NAME];
        [_activityIndicator stopAnimating];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
