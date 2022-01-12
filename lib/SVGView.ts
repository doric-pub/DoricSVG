import {View, Property, layoutConfig } from "doric";

export class SVGView extends View {
  @Property
  url?: string;
}

export function svgView(config?: Partial<SVGView>) {
  const ret = new SVGView();
  ret.layoutConfig = layoutConfig().fit();
  if (config) {
    ret.apply(config);
  }
  return ret;
}
