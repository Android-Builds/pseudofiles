package sudo.dev.pseudofiles;

import android.app.WallpaperColors;
import android.app.WallpaperManager;
import android.content.ContextWrapper;
import android.graphics.Color;
import android.os.Build;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Log;
import android.util.TypedValue;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.appcompat.view.ContextThemeWrapper;

import com.google.android.material.color.DynamicColors;
import com.google.android.material.color.MaterialColors;
import com.google.gson.Gson;
import com.kieronquinn.monetcompat.core.MonetCompat;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import dev.kdrag0n.monet.factory.ColorSchemeFactory;
import dev.kdrag0n.monet.theme.ColorScheme;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import sudo.dev.pseudofiles.classes.ApplicationHelper;
import sudo.dev.pseudofiles.classes.DocumentHelper;
import sudo.dev.pseudofiles.classes.MediaHelper;
import sudo.dev.pseudofiles.classes.StorageHelper;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "pseudoFiles";

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            new Thread(()->{
                                switch (call.method) {
                                    case "getDirectorySize": {
                                        StorageHelper storageHelper = new StorageHelper();
                                        result.success(storageHelper.getDirectorySize(call.argument("path"), this));
                                        break;
                                    }
                                    case "getStorageInfo": {
                                        StorageHelper storageHelper = new StorageHelper();
                                        result.success(storageHelper.getStorageDetails(this));
                                        break;
                                    }
                                    case "getAllMedias": {
                                        MediaHelper mediaHelper = new MediaHelper(this, call.argument("mediaType"));
                                        result.success(mediaHelper.getMediaPaths());
                                        break;
                                    }
                                    case "getAllDocuments": {
                                        result.success(DocumentHelper.getAllDocuments(this));
                                        break;
                                    }
                                    case "getInstalledApps": {
                                        ApplicationHelper applicationHelper = new ApplicationHelper(this);
                                        result.success(applicationHelper.getInstalledApps());
                                        break;
                                    }
                                    case "getApkFromStorage": {
                                        ApplicationHelper applicationHelper = new ApplicationHelper(this);
                                        result.success(applicationHelper.getApkFromStorage());
                                        break;
                                    }
                                    case "getInstalledAppSizes": {
                                        ApplicationHelper applicationHelper = new ApplicationHelper(this);
                                        result.success(applicationHelper.getInstalledAppSizes());
                                        break;
                                    }
                                    case "getApkDetails": {
                                        ApplicationHelper applicationHelper = new ApplicationHelper(this);
                                        result.success(applicationHelper.getApkDetails(call.argument("path")));
                                        break;
                                    }
                                    case "getMediaSize": {
                                        MediaHelper mediaHelper = new MediaHelper(this, call.argument("mediaType"));
                                        result.success(mediaHelper.getMediaSize());
                                        break;
                                    }
                                    case "getDocumentsSize": {
                                        result.success(DocumentHelper.getDocumentsSize(this));
                                        break;
                                    }
                                    case "getRecentFiles": {
                                        MediaHelper mediaHelper = new MediaHelper(this);
                                        result.success(mediaHelper.getRecentFiles(call.argument("limit")));
                                        break;
                                    }
                                    case "grantUsagePermission": {
                                        result.success(ApplicationHelper.grantUsagePermission(this));
                                        break;
                                    }
                                    case "getDynamicColors": {
                                        result.success(getDynamicColors());
                                        break;
                                    }
                                    default:
                                        throw new IllegalStateException("Unexpected value: " + call.method);
                                }
                            }).start();
                        }
                );
    }

    Map<String, String> getDynamicColors() {
        Map<String, String> colorMap = new HashMap<>();
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
            try {
                String darkColorName = "system_accent1_100";
                String lightColorName = "system_accent1_600";
                int darkColorId = getApplicationContext().getResources().getIdentifier(darkColorName, "color", "android");
                int lightColorId = getApplicationContext().getResources().getIdentifier(lightColorName, "color", "android");
                int d = getApplicationContext().getResources().getColor(darkColorId);
                int l = getApplicationContext().getResources().getColor(lightColorId);
                colorMap.put("systemDark", Integer.toHexString(d));
                colorMap.put("systemLight", Integer.toHexString(l));
                return colorMap;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        MonetCompat monetCompat = MonetCompat.setup(this);
        ColorScheme colorScheme = monetCompat.getMonetColors();
        colorMap.put("systemDark", Integer.toHexString(monetCompat.getPrimaryColor(this, true)));
        colorMap.put("systemLight", Integer.toHexString(monetCompat.getPrimaryColor(this, false)));

        return colorMap;
    }

    public static String getSystemProperty(String property, String defaultValue) {
        try {
            Class privateClass = Class.forName("android.os.SystemProperties");
            Method getter = privateClass.getDeclaredMethod("get", String.class);
            String value = (String) getter.invoke(null, property);
            if (!TextUtils.isEmpty(value)) {
                return value;
            }
        } catch (Exception e) {
            Log.d("PseudoFiles: ", "Unable to read system properties");
        }
        return defaultValue;
    }
}