package pub.doric.library;

import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.util.Log;
import android.widget.ImageView;

import com.github.megatronking.svg.support.SVGDrawable;
import com.github.megatronking.svg.support.SVGRenderer;
import com.github.pengfeizhou.jscore.JSValue;

import pub.doric.DoricContext;
import pub.doric.extension.bridge.DoricPlugin;
import pub.doric.shader.ViewNode;

@DoricPlugin(name = "SVG")
public class DoricSVGViewNode extends ViewNode<ImageView> {

    public DoricSVGViewNode(DoricContext doricContext) {
        super(doricContext);
    }

    @Override
    protected ImageView build() {
        ImageView view = new ImageView(getContext());
        return view;
    }

    @Override
    protected void blend(ImageView view, String name, JSValue prop) {
        Log.d("blend", "ImageView view, String name, JSValue prop");
        switch (name) {
            case "url":
                if (prop.isString()) {
                    Uri uri = Uri.parse(prop.asString().value());
//                    view.setImageResource(R.drawable.ic_svg_01);
                    SVGRenderer renderer = new ic_android_red_01(getContext());
                    Drawable drawable = new SVGDrawable(renderer);
                    view.setImageDrawable(drawable);
//                    view.loadUrl(prop.asString().value());
                }
                break;
//            case "content":
//                if (prop.isString()) {
//                    view.loadData(prop.asString().value(), "text/html", "UTF-8");
//                }
//                break;
//            case "allowJavaScript":
//                if (prop.isBoolean()) {
//                    WebSettings settings = view.getSettings();
//                    settings.setJavaScriptEnabled(prop.asBoolean().value());
//                }
//                break;
            default:
                super.blend(view, name, prop);
                break;
        }

    }
}
