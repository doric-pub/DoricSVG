//
//  DoricSVGViewNode.m
//  DoricSVGView
//
//  Created by shangkun on 2022/1/11.
//

#import "DoricSVGViewNode.h"

@interface DoricSVGViewNode ()

@end

@implementation DoricSVGViewNode

- (SVGKImageView *)build {
    // `SVGKLayeredImageView`, best on performance and do actually vector image rendering (translate SVG to CALayer tree).
    SVGKImageView *imageView = [[SVGKLayeredImageView alloc] initWithSVGKImage:nil];
    imageView.sd_adjustContentMode = YES; // make `contentMode` works
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    return imageView;
}

- (void)blendView:(SVGKImageView *)view forPropName:(NSString *)name propValue:(id)prop {
    if ([@"url" isEqualToString:name]) {
        NSURL *url = [NSURL URLWithString:prop];
        [view sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                NSLog(@"SVGKLayeredImageView SVG load success");
            }
        }];
    } else {
        [super blendView:view forPropName:name propValue:prop];
    }
}
    
    
@end
