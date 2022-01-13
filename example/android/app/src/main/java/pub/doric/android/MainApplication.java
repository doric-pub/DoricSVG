package pub.doric.android;

import android.app.Application;
import android.util.Log;

import pub.doric.Doric;
import pub.doric.library.DoricSVGLibrary;

public class MainApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        Doric.init(this);
        Log.d("blend", "registerLibrary");
        Doric.registerLibrary(new DoricSVGLibrary());
    }
}
