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
} from "doric";
import { SVG } from "doric-svg";

const svgUrls = [
    "https://upload.wikimedia.org/wikipedia/commons/1/14/Mahuri.svg",
    "https://upload.wikimedia.org/wikipedia/commons/2/2d/Sample_SVG_file%2C_signature.svg",
    "https://simpleicons.org/icons/github.svg",
]

@Entry
class Example extends Panel {

    index: number = 0

    onShow() {
        navbar(context).setTitle("SVG");
    }
    build(rootView: Group) {
        const svgRef = createRef<SVG>();
        <VLayout parent={rootView} layoutConfig={layoutConfig().most()}>
            <SVG
                ref={svgRef}
                backgroundColor={Color.CYAN}
                layoutConfig={layoutConfig().mostWidth().justHeight().configWeight(1)}
                scaleType={ScaleType.ScaleAspectFit}
                url={svgUrls[this.index % svgUrls.length]}
                loadCallback={(info) => {
                    if (info) {
                        log(`load width: ${info.width}, height: ${info.height}`)
                    }
                }}
            // localResource={Environment.platform === 'Android'
            // ? new AndroidAssetsResource('assets/Lion.svg')
            // : new MainBundleResource("assets/Lion.svg")}
            />


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
