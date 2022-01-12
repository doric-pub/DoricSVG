import { View, Property, layoutConfig, ScaleType, Resource } from "doric";

export class SVGView extends View {
  @Property
  url?: string;

  /**
   * Read svg image from resource
   * For android,it will try to read from drawable.
   * For iOS,it will try to read from Image.Assets.
   */
  @Property
  imageName?: string;

  @Property
  rawString?: string;

  /**
   * This could be loaded by customized resource loader
   */
  @Property
  localResource?: Resource;

  @Property
  scaleType?: ScaleType;

  @Property
  loadCallback?: (info: { width: number; height: number }) => void;
}

export function svgView(config?: Partial<SVGView>) {
  const ret = new SVGView();
  ret.layoutConfig = layoutConfig().fit();
  if (config) {
    ret.apply(config);
  }
  return ret;
}
