# DoricSVG
Doric plugins for SVG.

- loaded by URL.
- loaded by customized resource loader.
- loaded by rawString

<img src="../main/images/android.png" width="50%">

### Doric

> [Doric](https://doric.pub/docs/index.html) 是一个极简高效的跨端开发框架，使用[TypeScript](https://www.typescriptlang.org/)作为开发语言，
上层遵循MVVM设计，可在多平台上执行，目前已经支持Android、iOS、Web及Qt等平台。

### Usage

```
build(rootView: Group) {
        const svgRef = createRef<SVG>();
        <VLayout parent={rootView} layoutConfig={layoutConfig().most()}>
            <Scroller
                layoutConfig={layoutConfig().mostWidth().fitHeight().configWeight(1)}
                backgroundColor={Color.CYAN}
                scrollable={true}
                content={
                    <VLayout
                        space={20}
                        gravity={Gravity.CenterX}
                        layoutConfig={layoutConfig().mostWidth().fitHeight()}>
                        <SVG
                            // 1. loaded by URL.
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
                        <SVG
                            // 2. loaded by customized resource loader
                            backgroundColor={Color.WHITE}
                            layoutConfig={layoutConfig().just().configAlignment(Gravity.Center)}
                            width={300}
                            height={300}
                            scaleType={ScaleType.ScaleAspectFit}
                            localResource={Environment.platform === 'Android'
                                ? new AndroidAssetsResource('assets/Lion.svg')
                                : new MainBundleResource("assets/Lion.svg")}
                        />

                        <SVG
                            // 3. loaded by rawString
                            backgroundColor={Color.WHITE}
                            layoutConfig={layoutConfig().just().configAlignment(Gravity.Center)}
                            width={300}
                            height={300}
                            scaleType={ScaleType.ScaleAspectFit}
                        >
                            {svgRawString}
                        </SVG>
                    </VLayout>
                }></Scroller>

            <Text layoutConfig={layoutConfig().mostWidth().justHeight()} height={60}
                backgroundColor={Color.BLACK} textSize={18} textColor={Color.WHITE} fontStyle="bold"
                onClick={() => {
                    this.index++
                    svgRef.current.url = svgUrls[this.index % svgUrls.length]
                    log('onClick Next')
                }}>
                Next
            </Text>
        </VLayout>;
    }
```

##### 部分图片

<img src="../main/images/iOS.png" width="50%">


