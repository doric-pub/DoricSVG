# DoricSVG
Doric plugins for SVG.

- support loaded by URL.
- support loaded by customized resource loader.
- support loaded by xml string.

下图分别为代码在Android及iOS应用上的运行截图

| Android | iOS |
| ---- | ---- |
| !<img src="../main/images/android.png" height="500px"/> | <img src="../main/images/iOS.png" height="500px"/>|


### Usage

#### loaded by URL

```
<SVG
    ref={svgRef}
    backgroundColor={Color.WHITE}
    layoutConfig={layoutConfig().just().configAlignment(Gravity.Center)}
    width={300}
    height={300}
    scaleType={ScaleType.ScaleAspectFit}
    url={svgUrls[this.index % svgUrls.length]}
    loadCallback={(info) => {
        if (info) {
            log(`image width: ${info.width}, height: ${info.height}`)
        }
    }}
/>
```

#### loaded by customized resource loader

```
<SVG
    backgroundColor={Color.WHITE}
    layoutConfig={layoutConfig().just().configAlignment(Gravity.Center)}
    width={200}
    height={200}
    scaleType={ScaleType.ScaleAspectFit}
    localResource={Environment.platform === 'Android'
        ? new AssetsResource('android.svg')
        : new MainBundleResource("assets/apple.svg")}
/>
```

#### loaded by xml string

```
const xmlString = `<?xml version="1.1" encoding="UTF-8"?>
<svg width="480px" height="480px" xmlns="http://www.w3.org/2000/svg" version="1.1">
    <title>Note</title>
    <g>
        <path d="M240,476 C370,476 476,370 476,240 C476,109 370,4 240,4 C109,4 4,109 4,240 C4,370 109,476 240,476" fill="rgb(230,250,210)"></path>
        <path d="M179,311 C179,311 176,305 157,305 C138,305 108,314 108,349 C108,370 132,383 154,383 C176,383 202,364 202,342 C202,318 202,201 202,201 C202,201 268,177 330,177 L330,277 C330,277 318,273 307,273 C288,273 255,287 259,317 C263,347 291,351 306,351 C330,351 354,331 354,311 C354,295 354,96 354,96 C354,96 232,99 179,129 Z M179,311" fill="darkgreen"></path>
    </g>
</svg>
`
<SVG
    backgroundColor={Color.WHITE}
    layoutConfig={layoutConfig().just().configAlignment(Gravity.Center)}
    width={100}
    height={100}
    scaleType={ScaleType.ScaleAspectFit}
>
    {xmlString}
</SVG>
```
