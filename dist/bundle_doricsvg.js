'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var doric = require('doric');

var __decorate = (undefined && undefined.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (undefined && undefined.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
class SVG extends doric.View {
    set innerElement(e) {
        this.rawString = e;
    }
}
__decorate([
    doric.Property,
    __metadata("design:type", String)
], SVG.prototype, "url", void 0);
__decorate([
    doric.Property,
    __metadata("design:type", String)
], SVG.prototype, "rawString", void 0);
__decorate([
    doric.Property,
    __metadata("design:type", doric.Resource)
], SVG.prototype, "localResource", void 0);
__decorate([
    doric.Property,
    __metadata("design:type", Number)
], SVG.prototype, "scaleType", void 0);
__decorate([
    doric.Property,
    __metadata("design:type", Function)
], SVG.prototype, "loadCallback", void 0);
function svg(config) {
    const ret = new SVG;
    ret.layoutConfig = doric.layoutConfig().fit();
    ret.scaleType = doric.ScaleType.ScaleAspectFit;
    if (config) {
        ret.apply(config);
    }
    return ret;
}

exports.SVG = SVG;
exports.svg = svg;
//# sourceMappingURL=bundle_doricsvg.js.map
