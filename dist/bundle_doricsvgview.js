'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var doric = require('doric');

function demoPlugin(context) {
    return {
        call: () => {
            return context.callNative("demoPlugin", "call");
        },
    };
}

var __decorate = (undefined && undefined.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (undefined && undefined.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
class SVGView extends doric.View {
}
__decorate([
    doric.Property,
    __metadata("design:type", String)
], SVGView.prototype, "url", void 0);
__decorate([
    doric.Property,
    __metadata("design:type", String)
], SVGView.prototype, "imageName", void 0);
__decorate([
    doric.Property,
    __metadata("design:type", String)
], SVGView.prototype, "rawString", void 0);
__decorate([
    doric.Property,
    __metadata("design:type", doric.Resource)
], SVGView.prototype, "localResource", void 0);
__decorate([
    doric.Property,
    __metadata("design:type", Number)
], SVGView.prototype, "scaleType", void 0);
__decorate([
    doric.Property,
    __metadata("design:type", Function)
], SVGView.prototype, "loadCallback", void 0);
function svgView(config) {
    const ret = new SVGView();
    ret.layoutConfig = doric.layoutConfig().fit();
    if (config) {
        ret.apply(config);
    }
    return ret;
}

exports.SVGView = SVGView;
exports.demoPlugin = demoPlugin;
exports.svgView = svgView;
//# sourceMappingURL=bundle_doricsvgview.js.map
