import { View, Property, layoutConfig, ScaleType, Resource } from "doric";

export class SVG extends View implements JSX.ElementChildrenAttribute {
  @Property
  url?: string;

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
  set innerElement(e: string) {
    this.rawString = e;
  }

  @Property
  loadCallback?: (image: { width: number; height: number} | undefined) => void
}

export function svg(config?: Partial<SVG>) {
  const ret = new SVG;
  ret.layoutConfig = layoutConfig().fit();
  ret.scaleType = ScaleType.ScaleAspectFill;
  if (config) {
    ret.apply(config);
  }
  return ret;
}
