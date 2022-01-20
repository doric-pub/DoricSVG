//
//  DoricSVGViewNode.m
//  DoricSVG
//
//  Created by shangkun on 2022/1/11.
//

#import "DoricSVGViewNode.h"
#import "DoricExtensions.h"
#import "DoricUtil.h"
#import <SKSVG/SDSVGKImage.h>
#import <SKSVG/SVGKImageView+WebCache.h>

@interface DoricSVGViewNode ()
@property(nonatomic, copy) NSString *loadCallbackId;
@end

@implementation DoricSVGViewNode
- (SVGKImageView *)build {
    // `SVGKLayeredImageView`, best on performance and do actually vector image rendering (translate SVG to CALayer tree).
    SVGKImageView *imageView = [[SVGKLayeredImageView alloc] initWithSVGKImage:nil];
    // hide "Missing SVG" placeholder.
    ((SVGKLayer*) imageView.layer).SVGImage = nil;
    imageView.sd_adjustContentMode = YES; // make `contentMode` works
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    return imageView;
}

- (void)blend:(NSDictionary *)props {
    [props[@"loadCallback"] also:^(NSString *it) {
        self.loadCallbackId = it;
    }];
    [super blend:props];
}

- (void)blendView:(SVGKImageView *)view forPropName:(NSString *)name propValue:(id)prop {
    if ([@"url" isEqualToString:name]) {
        NSURL *url = [NSURL URLWithString:prop];
        __weak typeof(self) weakself = self;
        [self.view sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            __strong typeof(weakself) self = weakself;
            if (!self) {
                return;
            }
            if (image) {
                if (self.loadCallbackId.length > 0) {
                    [self callJSResponse:self.loadCallbackId,
                     @{
                        @"width": @(image.size.width),
                        @"height": @(image.size.height),
                    }, nil];
                }
            } else {
                if (self.loadCallbackId.length > 0) {
                    [self callJSResponse:self.loadCallbackId, nil];
                }
            }
        }];
    } else if ([@"rawString" isEqualToString:name]) {
        NSData *data = [prop dataUsingEncoding:NSUTF8StringEncoding];
        [self configImageWithData:data];
    } else if ([@"localResource" isEqualToString:name]) {
        NSString *type = prop[@"type"];
        NSString *identifier = prop[@"identifier"];
        DoricAsyncResult <NSData *> *asyncResult = [[self.doricContext.driver.registry.loaderManager
                                                     load:identifier withResourceType:type withContext:self.doricContext] fetchRaw];
        [asyncResult setResultCallback:^(NSData *imageData) {
            [self.doricContext dispatchToMainQueue:^{
                [self configImageWithData:imageData];
            }];
        }];
        [asyncResult setExceptionCallback:^(NSException *e) {
            DoricLog(@"Cannot load resource type = %@, identifier = %@, %@", type, identifier, e.reason);
        }];
    }else if ([@"scaleType" isEqualToString:name]) {
        switch ([prop integerValue]) {
            case 1: {
                self.view.contentMode = UIViewContentModeScaleAspectFit;
                break;
            }
            case 2: {
                self.view.contentMode = UIViewContentModeScaleAspectFill;
                break;
            }
            default: {
                self.view.contentMode = UIViewContentModeScaleToFill;
                break;
            }
        }
        NSLog(@"scaleType size = %@",NSStringFromCGSize(self.view.image.size));
        [self adjustContentViewMode:self.view.image];
    } else if ([@"loadCallback" isEqualToString:name]) {
        // Do not need set
    } else {
        [super blendView:view forPropName:name propValue:prop];
    }
}

- (void)configImageWithData:(NSData *)imageData {
    SDSVGKImage *image = [SDSVGKImage imageWithData:imageData];
    SVGKImage *svgImage;
    if ([image isKindOfClass:[SDSVGKImage class]]) {
        svgImage = ((SDSVGKImage *)image).SVGKImage;
    }
    if (svgImage) {
        [self adjustContentViewMode:svgImage];
    }
    if (self.loadCallbackId.length > 0) {
        if (svgImage) {
            [self callJSResponse:self.loadCallbackId,
             @{
                @"width": @(svgImage.size.width),
                @"height": @(svgImage.size.height),
            },
             nil];
        } else {
            [self callJSResponse:self.loadCallbackId, nil];
        }
    }
}

- (void)adjustContentViewMode:(SVGKImage *)svgImage {
    if (svgImage && svgImage.hasSize && svgImage.size.width > 0.1f) {
#if SD_UIKIT
        if (self.view.sd_adjustContentMode) {
            SDAdjustSVGContentMode(svgImage, self.view.contentMode, self.view.bounds.size);
        }
#endif
        self.view.image = svgImage;
    }
}

@end
