package pub.doric.library;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Picture;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.PictureDrawable;
import android.os.Build;
import android.text.TextUtils;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.widget.AppCompatImageView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.RequestBuilder;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.DrawableImageViewTarget;
import com.bumptech.glide.request.target.SizeReadyCallback;
import com.bumptech.glide.request.target.Target;

import com.caverock.androidsvg.SVG;
import com.caverock.androidsvg.SVGParseException;
import com.github.pengfeizhou.jscore.JSONBuilder;
import com.github.pengfeizhou.jscore.JSObject;
import com.github.pengfeizhou.jscore.JSValue;

import java.io.IOException;

import pub.doric.DoricContext;
import pub.doric.async.AsyncResult;
import pub.doric.extension.bridge.DoricPlugin;
import pub.doric.resource.DoricResource;
import pub.doric.shader.ViewNode;
import pub.doric.utils.DoricLog;
import pub.doric.utils.DoricUtils;

@DoricPlugin(name = "SVG")
public class DoricSVGViewNode extends ViewNode<ImageView> {
    private String loadCallbackId = "";
    private float imageScale = DoricUtils.getScreenScale();

    public DoricSVGViewNode(DoricContext doricContext) {
        super(doricContext);
    }

    @Override
    protected ImageView build() {
        ImageView imageView = new AppCompatImageView(getContext()) {
            @Override
            protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
                super.onMeasure(widthMeasureSpec, heightMeasureSpec);
            }
        };
        imageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
        imageView.setAdjustViewBounds(true);
        return imageView;
    }

    @Override
    public void blend(JSObject jsObject) {
        if (jsObject != null) {
            JSValue loadCallback = jsObject.getProperty("loadCallback");
            if (loadCallback.isString()) {
                this.loadCallbackId = loadCallback.asString().value();
            }
        }
        super.blend(jsObject);
    }

    @Override
    protected void blend(ImageView view, String name, JSValue prop) {
        switch (name) {
            case "url":
                if (!prop.isString()) {
                    return;
                }
                loadImageUrl(prop.asString().value());
                break;
            case "rawString":
                if (!prop.isString()) {
                    return;
                }
                loadSvgImageWithRawString(prop.asString().value());
                break;
            case "localResource":
                if (!prop.isObject()) {
                    return;
                }
                JSObject resource = prop.asObject();
                final String type = resource.getProperty("type").asString().value();
                final String identifier = resource.getProperty("identifier").asString().value();
                DoricResource doricResource = getDoricContext().getDriver().getRegistry().getResourceManager().load(getDoricContext(), type, identifier);
                if (doricResource != null) {
                    doricResource.fetchRaw().setCallback(new AsyncResult.Callback<byte[]>() {
                        @Override
                        public void onResult(byte[] imageData) {
                            loadIntoTarget(Glide.with(getContext()).load(imageData));
                        }

                        @Override
                        public void onError(Throwable t) {
                            t.printStackTrace();
                            DoricLog.e("Cannot load resource type = %s, identifier = %s, %s", type, identifier, t.getLocalizedMessage());
                        }

                        @Override
                        public void onFinish() {

                        }
                    });
                } else {
                    DoricLog.e("Cannot find loader for resource type = %s, identifier = %s", type, identifier);
                }
                break;
            case "scaleType":
                if (!prop.isNumber()) {
                    return;
                }
                int scaleType = prop.asNumber().toInt();
                switch (scaleType) {
                    case 1:
                        view.setScaleType(ImageView.ScaleType.FIT_CENTER);
                        break;
                    case 2:
                        view.setScaleType(ImageView.ScaleType.CENTER_CROP);
                        break;
                    default:
                        view.setScaleType(ImageView.ScaleType.FIT_XY);
                        break;
                }
                break;
            case "loadCallback":
                // Do not need set
                break;
            default:
                super.blend(view, name, prop);
                break;
        }
    }

    private void loadImageUrl(String url) {
        Context context = DoricUtils.unwrap(getContext());
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            if (context instanceof Activity && ((Activity) context).isDestroyed()) {
                return;
            }
        }
        RequestBuilder<Drawable> requestBuilder = Glide.with(context)
                .load(url);
        loadIntoTarget(requestBuilder);
    }

    private void loadSvgImageWithRawString(String rawString) {
        Context context = DoricUtils.unwrap(getContext());
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            if (context instanceof Activity && ((Activity) context).isDestroyed()) {
                return;
            }
        }
        try {
            SVG svg = SVG.getFromString(rawString);
            Picture picture = svg.renderToPicture();
            PictureDrawable drawable = new PictureDrawable(picture);
            mView.setImageDrawable(drawable);
            if (!TextUtils.isEmpty(loadCallbackId)) {
                callJSResponse(loadCallbackId, new JSONBuilder()
                        .put("width", DoricUtils.px2dp(drawable.getIntrinsicWidth()))
                        .put("height", DoricUtils.px2dp(drawable.getIntrinsicHeight()))
                        .toJSONObject());
            }

        } catch (SVGParseException ex) {
            if (!TextUtils.isEmpty(loadCallbackId)) {
                callJSResponse(loadCallbackId);
            }
            try {
                throw new IOException("Cannot load SVG from String", ex);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private void loadIntoTarget(RequestBuilder<Drawable> requestBuilder) {
        requestBuilder
                .listener(new RequestListener<Drawable>() {
                    @Override
                    public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                        if (!TextUtils.isEmpty(loadCallbackId)) {
                            callJSResponse(loadCallbackId);
                        }
                        return false;
                    }

                    @Override
                    public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                        if (!TextUtils.isEmpty(loadCallbackId)) {
                            if (resource instanceof BitmapDrawable) {
                                Bitmap bitmap = ((BitmapDrawable) resource).getBitmap();
                                callJSResponse(loadCallbackId, new JSONBuilder()
                                        .put("width", DoricUtils.px2dp(bitmap.getWidth()))
                                        .put("height", DoricUtils.px2dp(bitmap.getHeight()))
                                        .toJSONObject());
                            } else {
                                callJSResponse(loadCallbackId, new JSONBuilder()
                                        .put("width", DoricUtils.px2dp(resource.getIntrinsicWidth()))
                                        .put("height", DoricUtils.px2dp(resource.getIntrinsicHeight()))
                                        .toJSONObject());
                            }
                        }
                        return false;
                    }
                }).into(new DrawableImageViewTarget(mView) {

            @SuppressLint("MissingSuperCall")
            @Override
            public void getSize(@NonNull SizeReadyCallback cb) {
                cb.onSizeReady(SIZE_ORIGINAL, SIZE_ORIGINAL);
            }

            @Override
            protected void setResource(@Nullable Drawable resource) {
                if (resource instanceof BitmapDrawable) {
                    Bitmap bitmap = ((BitmapDrawable) resource).getBitmap();
                    float scale = DoricUtils.getScreenScale() / imageScale;
                    if (imageScale != DoricUtils.getScreenScale()) {
                        Matrix matrix = new Matrix();
                        matrix.setScale(scale, scale);
                        bitmap = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
                        resource = new BitmapDrawable(getContext().getResources(), bitmap);
                    }
                    super.setResource(resource);
                } else {
                    super.setResource(resource);
                }
            }
        });
    }

    @Override
    protected void reset() {
        super.reset();
        mView.setImageDrawable(null);
        mView.setScaleType(ImageView.ScaleType.CENTER_CROP);
        loadCallbackId = "";
        imageScale = DoricUtils.getScreenScale();
    }
}
