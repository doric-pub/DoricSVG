#import "DoricSVGLibrary.h"
#import "DoricSVGViewNode.h"

@implementation DoricSVGLibrary
- (void)load:(DoricRegistry *)registry {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *fullPath = [path stringByAppendingPathComponent:@"bundle_doricsvg.js"];
    NSString *jsContent = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
    [registry registerJSBundle:jsContent withName:@"doricsvg"];
    [registry registerViewNode:DoricSVGViewNode.class withName:@"SVG"];
}
@end
