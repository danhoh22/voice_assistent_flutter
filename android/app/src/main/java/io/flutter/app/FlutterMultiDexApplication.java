package io.flutter.app;
import android.content.Context; // Добавленный импорт
import androidx.multidex.MultiDex;
import androidx.multidex.MultiDexApplication;

public class FlutterMultiDexApplication extends MultiDexApplication {
    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }
}
