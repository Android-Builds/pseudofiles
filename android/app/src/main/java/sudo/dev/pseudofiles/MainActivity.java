package sudo.dev.pseudofiles;

import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

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
                                        result.success(storageHelper.getDirectorySize(call.argument("path"), getApplicationContext()));
                                        break;
                                    }
                                    case "getStorageInfo": {
                                        StorageHelper storageHelper = new StorageHelper();
                                        result.success(storageHelper.getStorageDetails(getApplicationContext()));
                                        break;
                                    }
                                    case "getAllMedias": {
                                        MediaHelper mediaHelper = new MediaHelper(getApplicationContext(), call.argument("mediaType"));
                                        result.success(mediaHelper.getMediaPaths());
                                        break;
                                    }
                                    case "getAllDocuments": {
                                        result.success(DocumentHelper.getAllDocuments(getApplicationContext()));
                                        break;
                                    }
                                    case "getInstalledApps": {
                                        ApplicationHelper applicationHelper = new ApplicationHelper(getApplicationContext());
                                        result.success(applicationHelper.getInstalledApps());
                                        break;
                                    }
                                    case "getApkFromStorage": {
                                        ApplicationHelper applicationHelper = new ApplicationHelper(getApplicationContext());
                                        result.success(applicationHelper.getApkFromStorage());
                                        break;
                                    }
                                    case "getInstalledAppSizes": {
                                        ApplicationHelper applicationHelper = new ApplicationHelper(getApplicationContext());
                                        result.success(applicationHelper.getInstalledAppSizes());
                                        break;
                                    }
                                    case "getApkDetails": {
                                        ApplicationHelper applicationHelper = new ApplicationHelper(getApplicationContext());
                                        result.success(applicationHelper.getApkDetails(call.argument("path")));
                                        break;
                                    }
                                    case "getMediaSize": {
                                        MediaHelper mediaHelper = new MediaHelper(getApplicationContext(), call.argument("mediaType"));
                                        result.success(mediaHelper.getMediaSize());
                                        break;
                                    }
                                    case "getDocumentsSize": {
                                        result.success(DocumentHelper.getDocumentsSize(getApplicationContext()));
                                        break;
                                    }
                                    case "getRecentFiles": {
                                        MediaHelper mediaHelper = new MediaHelper(getApplicationContext());
                                        result.success(mediaHelper.getRecentFiles(call.argument("limit")));
                                        break;
                                    }
                                    default:
                                        throw new IllegalStateException("Unexpected value: " + call.method);
                                }
                            }).start();
                        }
                );
    }
}