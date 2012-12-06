# MCImageCache

Pre-render and cache images

## Installation

Copy files from the 'Classes' folder to your project.

## Usage

	#import "MCImageCache.h"
	
	…

    [MCImageCache prerenderAndCacheImageForName:@"large-image.png" completion:^{
       	_imageView.image = [MCImageCache imageForName:@"large-imahe.png"];
       	[_activityIndicator stopAnimating];
   	}];
   	
See the MCImageCache.h file for additional ways to use it.

## License

Code in this project is available under the MIT license.