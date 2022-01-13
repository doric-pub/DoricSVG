//
//  DoricSVGViewNode.m
//  DoricSVG
//
//  Created by shangkun on 2022/1/11.
//

#import "DoricSVGViewNode.h"
#import "DoricExtensions.h"
#import "DoricUtil.h"

@interface DoricSVGViewNode ()
@property(nonatomic, copy) NSString *loadCallbackId;
@property(nonatomic, assign) CGFloat imageScale;
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

- (void)blend:(NSDictionary *)props {
    [props[@"imageScale"] also:^(NSNumber *it) {
        self.imageScale = it.floatValue;
    }];
    [props[@"loadCallback"] also:^(NSString *it) {
        self.loadCallbackId = it;
    }];
    [super blend:props];
}

- (void)blendView:(SVGKImageView *)view forPropName:(NSString *)name propValue:(id)prop {
    if ([@"url" isEqualToString:name]) {
        NSURL *url = [NSURL URLWithString:prop];
        [self.view sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                NSLog(@"SVGKLayeredImageView SVG load success");
                if (self.loadCallbackId.length > 0) {
                    [self callJSResponse:self.loadCallbackId,
                     @{
                        @"width": @(image.size.width),
                        @"height": @(image.size.height),
                        @"imageURL": imageURL.absoluteString ?: @"",
                    }, nil];
                }
            } else {
                if (self.loadCallbackId.length > 0) {
                    [self callJSResponse:self.loadCallbackId, nil];
                }
            }
        }];
    } else if ([@"imageName" isEqualToString:name]) {
        SVGKImage *image = [SVGKImage imageNamed:prop];
        if (image) {
            self.view.image = image;
        }
        if (self.loadCallbackId.length > 0) {
            if (image) {
                [self callJSResponse:self.loadCallbackId,
                 @{
                    @"width": @(image.size.width),
                    @"height": @(image.size.height),
                }, nil];
            } else {
                [self callJSResponse:self.loadCallbackId, nil];
            }
        }
    } else if ([@"rawString" isEqualToString:name]) {
        SVGKSource *source = [SVGKSourceString sourceFromContentsOfString:prop];
        SVGKImage *image = [SVGKImage imageWithSource:source];
        if (image) {
            self.view.image = image;
        }
        if (self.loadCallbackId.length > 0) {
            if (image) {
                [self callJSResponse:self.loadCallbackId,
                 @{
                    @"width": @(image.size.width),
                    @"height": @(image.size.height),
                }, nil];
            } else {
                [self callJSResponse:self.loadCallbackId, nil];
            }
        }
        
    } else if ([@"localResource" isEqualToString:name]) {
        NSString *type = prop[@"type"];
        NSString *identifier = prop[@"identifier"];
        DoricAsyncResult <NSData *> *asyncResult = [[self.doricContext.driver.registry.loaderManager
                                                     load:identifier withResourceType:type withContext:self.doricContext] fetchRaw];
        [asyncResult setResultCallback:^(NSData *imageData) {
            [self.doricContext dispatchToMainQueue:^{
                SVGKImage *image = [SVGKImage imageWithData:imageData];
                if (image) {
                    self.view.image = image;
                }
                if (self.loadCallbackId.length > 0) {
                    if (image) {
                        [self callJSResponse:self.loadCallbackId,
                         @{
                            @"width": @(image.size.width),
                            @"height": @(image.size.height),
                        },
                         nil];
                    } else {
                        [self callJSResponse:self.loadCallbackId, nil];
                    }
                }
            }];
        }];
        [asyncResult setExceptionCallback:^(NSException *e) {
            DoricLog(@"Cannot load resource type = %@, identifier = %@, %@", type, identifier, e.reason);
        }];
    }else if ([@"scaleType" isEqualToString:name]) {
        self.view.sd_adjustContentMode = YES; // make `contentMode` works
        switch ([prop integerValue]) {
            case 1: {
                self.view.contentMode = UIViewContentModeScaleAspectFit;
                break;
            }
            case 2: {
                self.view.contentMode = UIViewContentModeScaleAspectFill;
                break;
            }
            case 3: {
                self.view.contentMode = UIViewContentModeRedraw;
                break;
            }
            default: {
                self.view.contentMode = UIViewContentModeScaleToFill;
                break;
            }
        }
    } else if ([@"loadCallback" isEqualToString:name]) {
        // Do not need set
    } else {
        [super blendView:view forPropName:name propValue:prop];
    }
}


@end
