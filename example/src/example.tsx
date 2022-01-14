import {
    createRef,
    Panel,
    Group,
    layoutConfig,
    navbar,
    jsx,
    VLayout,
    Text,
    Color,
    log,
    MainBundleResource,
    AndroidAssetsResource,
    ScaleType,
    Gravity,
    Scroller,
} from "doric";
import { SVG } from "doric-svg";

const svgUrls = [
    "https://upload.wikimedia.org/wikipedia/commons/1/14/Mahuri.svg",
    "https://upload.wikimedia.org/wikipedia/commons/2/2d/Sample_SVG_file%2C_signature.svg",
    "https://simpleicons.org/icons/github.svg",
]

const svgRawString = `<?xml version="1.1" encoding="UTF-8"?>
<svg width="480px" height="480px" xmlns="http://www.w3.org/2000/svg" version="1.1">
	<title>Note</title>
	<g>
		<path d="M240,476 C370,476 476,370 476,240 C476,109 370,4 240,4 C109,4 4,109 4,240 C4,370 109,476 240,476" fill="rgb(230,250,210)"></path>
		<path d="M179,311 C179,311 176,305 157,305 C138,305 108,314 108,349 C108,370 132,383 154,383 C176,383 202,364 202,342 C202,318 202,201 202,201 C202,201 268,177 330,177 L330,277 C330,277 318,273 307,273 C288,273 255,287 259,317 C263,347 291,351 306,351 C330,351 354,331 354,311 C354,295 354,96 354,96 C354,96 232,99 179,129 Z M179,311" fill="darkgreen"></path>
	</g>
</svg>
`

@Entry
class Example extends Panel {

    index: number = 0

    onShow() {
        navbar(context).setTitle("SVG");
    }

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
                            loadCallback={(info) => {
                                if (info) {
                                    log(`load width22: ${info.width}, height: ${info.height}`)
                                    // svgRef.current.width = info.width
                                    // svgRef.current.height = info.height
                                }
                            }}
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
}
