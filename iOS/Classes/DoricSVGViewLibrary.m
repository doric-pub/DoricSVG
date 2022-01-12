#import "DoricSVGViewLibrary.h"
#import "DoricDemoPlugin.h"
#import "DoricSVGViewNode.h"

@implementation DoricSVGViewLibrary
- (void)load:(DoricRegistry *)registry {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *fullPath = [path stringByAppendingPathComponent:@"bundle_doricsvgview.js"];
    NSString *jsContent = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
    [registry registerJSBundle:jsContent withName:@"doricsvgview"];
    [registry registerViewNode:DoricSVGViewNode.class withName:@"SVGView"];
    [registry registerNativePlugin:DoricDemoPlugin.class withName:@"demoPlugin"];
}
@end
